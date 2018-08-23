#include <math.h>
#include <thrust/swap.h>
#include <iostream>
#include "../interface/PulseChiSqSNNLS.h"
#include "nnls/interface/data_types.h"
#include "nnls/interface/inplace_fnnls.h"

__host__ __device__ bool PulseChiSqSNNLS::DoFit(
    const SampleVector& samples,
    const SampleMatrix& samplecor,
    double pederr,
    const BXVector& bxs,
    const FullSampleVector& fullpulse,
    const FullSampleMatrix& fullpulsecov) {
  const unsigned int nsample = SampleVector::RowsAtCompileTime;
  const unsigned int npulse = bxs.rows();

  _sampvec = samples;
  _bxs = bxs;

  _pulsemat = SamplePulseMatrix::Zero(nsample, npulse);
  _ampvec = PulseVector::Zero(npulse);
  _errvec = PulseVector::Zero(npulse);
  _nP = 0;
  _chisq = 0.;

  // initialize pulse template matrix
  for (unsigned int ipulse = 0; ipulse < npulse; ++ipulse) {
    int bx = _bxs.coeff(ipulse);
    int firstsamplet = std::max(0, bx + 3);
    int offset = 7 - 3 - bx;

    const unsigned int nsamplepulse = nsample - firstsamplet;
    _pulsemat.col(ipulse).segment(firstsamplet, nsamplepulse) =
        fullpulse.segment(firstsamplet + offset, nsamplepulse);
  }

  // do the actual fit
  bool status = Minimize(samplecor, pederr, fullpulsecov);
  _ampvecmin = _ampvec;

  //   std::cout << " _sampvec = " << _sampvec << std::endl;
  //   std::cout << " bxs = " << bxs << std::endl;
  //   std::cout << " fullpulse = " << fullpulse << std::endl;
  //   std::cout << " _ampvecmin = " << _ampvecmin << std::endl;

  _bxsmin = _bxs;

  if (!status)
    return status;

  //   std::cout << " _computeErrors = " << _computeErrors << std::endl;

  if (!_computeErrors)
    return status;

  // compute MINOS-like uncertainties for in-time amplitude
  bool foundintime = false;
  unsigned int ipulseintime = 0;
  //   std::cout << " npulse = " << npulse << std::endl;
  for (unsigned int ipulse = 0; ipulse < npulse; ++ipulse) {
    //     std::cout << " _bxs.coeff( " << ipulse << "::" << npulse << " ) = "
    //     << _bxs.coeff(ipulse) << std::endl;
    if (_bxs.coeff(ipulse) == 0) {
      ipulseintime = ipulse;
      foundintime = true;
      break;
    }
  }
  //   std::cout << " foundintime = " << foundintime << std::endl;
  if (!foundintime)
    return status;

  const unsigned int ipulseintimemin = ipulseintime;

  double approxerr = ComputeApproxUncertainty(ipulseintime);
  double chisq0 = _chisq;
  double x0 = _ampvecmin[ipulseintime];

  // move in time pulse first to active set if necessary
  if (ipulseintime < _nP) {
    _pulsemat.col(_nP - 1).swap(_pulsemat.col(ipulseintime));
    thrust::swap(_ampvec.coeffRef(_nP - 1), _ampvec.coeffRef(ipulseintime));
    thrust::swap(_bxs.coeffRef(_nP - 1), _bxs.coeffRef(ipulseintime));
    ipulseintime = _nP - 1;
    --_nP;
  }

  SampleVector pulseintime = _pulsemat.col(ipulseintime);
  _pulsemat.col(ipulseintime).setZero();

  // two point interpolation for upper uncertainty when amplitude is away from
  // boundary
  double xplus100 = x0 + approxerr;
  _ampvec.coeffRef(ipulseintime) = xplus100;
  _sampvec = samples - _ampvec.coeff(ipulseintime) * pulseintime;

  //   std::cout << " here 1 " << std::endl;
  status &= Minimize(samplecor, pederr, fullpulsecov);
  if (!status)
    return status;
  double chisqplus100 = ComputeChiSq();

  //   std::cout << " here 2 " << std::endl;

  double sigmaplus = std::abs(xplus100 - x0) / sqrt(chisqplus100 - chisq0);

  // if amplitude is sufficiently far from the boundary, compute also the lower
  // uncertainty and average them
  if ((x0 / sigmaplus) > 0.5) {
    for (unsigned int ipulse = 0; ipulse < npulse; ++ipulse) {
      if (_bxs.coeff(ipulse) == 0) {
        ipulseintime = ipulse;
        break;
      }
    }
    double xminus100 = std::max(0., x0 - approxerr);
    _ampvec.coeffRef(ipulseintime) = xminus100;
    _sampvec = samples - _ampvec.coeff(ipulseintime) * pulseintime;
    status &= Minimize(samplecor, pederr, fullpulsecov);
    if (!status)
      return status;
    double chisqminus100 = ComputeChiSq();

    double sigmaminus = std::abs(xminus100 - x0) / sqrt(chisqminus100 - chisq0);
    _errvec[ipulseintimemin] = 0.5 * (sigmaplus + sigmaminus);

  } else {
    _errvec[ipulseintimemin] = sigmaplus;
  }

  _chisq = chisq0;

  return status;
}

__host__ __device__ bool PulseChiSqSNNLS::Minimize(
    const SampleMatrix& samplecor,
    double pederr,
    const FullSampleMatrix& fullpulsecov) {
  const int maxiter = 50;
  for (int iter = 0; iter < maxiter; ++iter) {
    if (!(updateCov(samplecor, pederr, fullpulsecov) && NNLS()))
      return false;
    double chisqnow = ComputeChiSq();
    double deltachisq = chisqnow - _chisq;
    _chisq = chisqnow;
    if (std::abs(deltachisq) < 1e-3)
      break;
  }
  return true;
}

__host__ __device__ bool PulseChiSqSNNLS::updateCov(
    const SampleMatrix& samplecor,
    double pederr,
    const FullSampleMatrix& fullpulsecov) {
  const unsigned int nsample = SampleVector::RowsAtCompileTime;
  const unsigned int npulse = _bxs.rows();

  _invcov.triangularView<Eigen::Lower>() = (pederr * pederr) * samplecor;

  for (unsigned int ipulse = 0; ipulse < npulse; ++ipulse) {
    if (_ampvec.coeff(ipulse) == 0.)
      continue;
    int bx = _bxs.coeff(ipulse);
    int firstsamplet = std::max(0, bx + 3);
    int offset = 7 - 3 - bx;

    double ampsq = _ampvec.coeff(ipulse) * _ampvec.coeff(ipulse);

    const unsigned int nsamplepulse = nsample - firstsamplet;
    _invcov.block(firstsamplet, firstsamplet, nsamplepulse, nsamplepulse)
        .triangularView<Eigen::Lower>() +=
        ampsq * fullpulsecov.block(firstsamplet + offset, firstsamplet + offset,
                                   nsamplepulse, nsamplepulse);
  }

  _covdecomp.compute(_invcov);

  return true;
}

__host__ __device__ double PulseChiSqSNNLS::ComputeChiSq() {
  //   SampleVector resvec = _pulsemat*_ampvec - _sampvec;
  //   return resvec.transpose()*_covdecomp.solve(resvec);

  // TODO: port Eigen::LLT solve to gpu
  return _covdecomp.matrixL()
      .solve(_pulsemat * _ampvec - _sampvec)
      .squaredNorm();
  // return 1.0;
}

__host__ __device__ double PulseChiSqSNNLS::ComputeApproxUncertainty(
    unsigned int ipulse) {
  // compute approximate uncertainties
  //(using 1/second derivative since full Hessian is not meaningful in
  // presence of positive amplitude boundaries.)

  // TODO: port Eigen::LLT solve to gpu
  return 1. / _covdecomp.matrixL().solve(_pulsemat.col(ipulse)).norm();
  // return 1.;
}

__host__ __device__ bool PulseChiSqSNNLS::NNLS() {
  FixedMatrix A = _covdecomp.matrixL().solve(_pulsemat);
  FixedVector b = _covdecomp.matrixL().solve(_sampvec);

  // std::cout << A << std::endl;
  // std::cout << b << std::endl;

  // TODO: this should be a parameter not a magic number
  auto const epsilon = 1e-11;
  auto const max_iter = 1000;
  FixedVector x = FixedVector(_ampvec);
  inplace_fnnls(A, b, x, epsilon, max_iter);

  _ampvec = x;

  return true;
}

__host__ __device__ PulseChiSqSNNLS::PulseChiSqSNNLS()
    : _chisq(0.), _computeErrors(true) {}

__global__ void kernel_multifit(DoFitArgs* vargs,
                                Output* vresults,
                                unsigned int n) {
  // thread idx
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i >= n)
    return;

  PulseChiSqSNNLS pulse;
  pulse.disableErrorCalculation();
  auto args = vargs[i];

  // perform the regression
  auto status = pulse.DoFit(args.samples, args.samplecor, args.pederr, args.bxs,
                            args.fullpulse, args.fullpulsecov);

  unsigned int ip_in_time = 0;
  for (unsigned int ip = 0; ip < pulse.BXs().rows(); ++ip) {
    if (ip < pulse.BXs().coeff(ip) == 0) {
      ip_in_time = ip;
      break;
    }
  }

  // assing the result
  vresults[i] =
      Output{pulse.ChiSq(), status ? pulse.X()[ip_in_time] : 0.0, status};

  // assing the result
  // vresults[i] = DoFitResults{pulse.ChiSq(), pulse.BXs(), pulse.X(), (bool)
  // status};
}
