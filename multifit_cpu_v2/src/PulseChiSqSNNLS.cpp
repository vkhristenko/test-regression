// #include "multifit_cpu_v2/interface/PulseChiSqSNNLS.h"
#include "../interface/PulseChiSqSNNLS.h"
#include <math.h>
#include <iostream>
#include <vector>
#include <map>

PulseChiSqSNNLS::PulseChiSqSNNLS() :_chisq(0.), _computeErrors(true){
  // In later versions of eigen this should not be necessary
  Eigen::initParallel(); 
}  

PulseChiSqSNNLS::~PulseChiSqSNNLS() {}


bool PulseChiSqSNNLS::DoFit(const SampleVector &samples, 
                            const SampleMatrix &samplecor, 
                            double pederr, 
                            const BXVector &bxs, 
                            const FullSampleVector &fullpulse,
                            const FullSampleMatrix &fullpulsecov) {
  // why they have a full sample vector and a sample vector?


  // The input data looks like a matrix in which the time slot are in the x-axis
  // and the y-axes contains the enegy measurements.

  const unsigned int nsample = SampleVector::RowsAtCompileTime;
  const unsigned int npulse = bxs.rows();
  
  // They are saving the input data inside the class, probably to pass it through 
  // different function call.
  _sampvec = samples;
  _bxs = bxs;
  
  // basic initialization, in the end this should contain the result? Not sure
  // about this
  _pulsemat = SamplePulseMatrix::Zero(nsample,npulse);
  _ampvec = PulseVector::Zero(npulse);
  _errvec = PulseVector::Zero(npulse);  
  _nP = 0;
  _chisq = 0.;
  
  // initialize pulse template matrix
  for (unsigned int ipulse=0; ipulse<npulse; ++ipulse) {
    // this resembles a sliding window 
    // BXS might be a sensors vector
    int bx = _bxs.coeff(ipulse);
    int firstsamplet = std::max(0,bx + 3);
    int offset = 7-3-bx;
    
    const unsigned int nsamplepulse = nsample-firstsamplet;
    // initializing the resulting matrix with the values taken from the sliding window
    _pulsemat.col(ipulse).segment(firstsamplet,nsamplepulse) = 
        fullpulse.segment(firstsamplet+offset,nsamplepulse);
  }
  
  // do the actual fit
  bool status = Minimize(samplecor,pederr,fullpulsecov);
  _ampvecmin = _ampvec;
    
  _bxsmin = _bxs;
  
  if (!status || !_computeErrors) return status;
      
  // compute MINOS-like uncertainties for in-time amplitude

  bool foundintime = false;
  unsigned int ipulseintime = 0;

  for (unsigned int ipulse=0; ipulse<npulse; ++ipulse) {
    // special case for current state
    if (_bxs.coeff(ipulse)==0) {
      ipulseintime = ipulse;
      foundintime = true;
      break;
    }
  }

  if (!foundintime) return status;
  
  const unsigned int ipulseintimemin = ipulseintime;
  double approxerr = ComputeApproxUncertainty(ipulseintime);
  double chisq0 = _chisq;
  double x0 = _ampvecmin[ipulseintime];  
  

  // move in time pulse first to active set if necessary
  if (ipulseintime<_nP) {
    _pulsemat.col(_nP-1).swap(_pulsemat.col(ipulseintime));
    std::swap(_ampvec.coeffRef(_nP-1),_ampvec.coeffRef(ipulseintime));
    std::swap(_bxs.coeffRef(_nP-1),_bxs.coeffRef(ipulseintime));
    ipulseintime = _nP - 1;
    --_nP;    
  }
  
  
  
  SampleVector pulseintime = _pulsemat.col(ipulseintime);
  _pulsemat.col(ipulseintime).setZero();
  
  // two point interpolation for upper uncertainty when amplitude is away from boundary
  double xplus100 = x0 + approxerr;
  _ampvec.coeffRef(ipulseintime) = xplus100;
  _sampvec = samples - _ampvec.coeff(ipulseintime)*pulseintime;  

  status &= Minimize(samplecor,pederr,fullpulsecov);
  if (!status) return status;


  double chisqplus100 = ComputeChiSq();  
  double sigmaplus = std::abs(xplus100-x0)/sqrt(chisqplus100-chisq0);
  
  // if amplitude is sufficiently far from the boundary, compute also the lower 
  // uncertainty and average them
  if ( (x0/sigmaplus) > 0.5 ) {
    for (unsigned int ipulse=0; ipulse<npulse; ++ipulse) {
      if (_bxs.coeff(ipulse)==0) {
        ipulseintime = ipulse;
        break;
      }
    }    

    double xminus100 = std::max(0.,x0-approxerr);
    _ampvec.coeffRef(ipulseintime) = xminus100;
    _sampvec = samples - _ampvec.coeff(ipulseintime)*pulseintime;
    status &= Minimize(samplecor,pederr,fullpulsecov);
    if (!status) return status;
    double chisqminus100 = ComputeChiSq();
    
    double sigmaminus = std::abs(xminus100-x0)/sqrt(chisqminus100-chisq0);
    _errvec[ipulseintimemin] = 0.5*(sigmaplus + sigmaminus);
    
  } else _errvec[ipulseintimemin] = sigmaplus;
  
  _chisq = chisq0;  
  
  return status;
  
}

bool PulseChiSqSNNLS::Minimize(const SampleMatrix &samplecor,
                               double pederr, 
                               const FullSampleMatrix &fullpulsecov) {
  
  // iterate for at mox 50 iterations
  const int maxiter = 50;
  for (int i=0; i<maxiter; ++i){    
    if (!(updateCov(samplecor,pederr,fullpulsecov) && NNLS()))
      return false;
    
    double chisqnow = ComputeChiSq();
    double deltachisq = chisqnow-_chisq;
    
    _chisq = chisqnow;
    if (std::abs(deltachisq)<1e-3) 
      return true;
  }  
  return true;  
}

// TODO: this functions cannot fail. Should be void 
bool PulseChiSqSNNLS::updateCov(const SampleMatrix &samplecor, double pederr, const FullSampleMatrix &fullpulsecov) {  
  
  const unsigned int nsample = SampleVector::RowsAtCompileTime;
  const unsigned int npulse = _bxs.rows();
  
  _invcov.triangularView<Eigen::Lower>() = (pederr*pederr)*samplecor;
  
  for (unsigned int ipulse=0; ipulse<npulse; ++ipulse) {
    if (_ampvec.coeff(ipulse)==0.) continue;
    int bx = _bxs.coeff(ipulse);
    int firstsamplet = std::max(0,bx + 3);
    int offset = 7-3-bx;
    
    double ampsq = _ampvec.coeff(ipulse)*_ampvec.coeff(ipulse);
    
    const unsigned int nsamplepulse = nsample-firstsamplet;    
    _invcov.block(firstsamplet,firstsamplet,nsamplepulse,nsamplepulse).triangularView<Eigen::Lower>()
        += ampsq*fullpulsecov.block(firstsamplet+offset,firstsamplet+offset,nsamplepulse,nsamplepulse);    
  }  
  _covdecomp.compute(_invcov);
  return true;  
}

double PulseChiSqSNNLS::ComputeChiSq() {
  return _covdecomp.matrixL().solve(_pulsemat*_ampvec - _sampvec).squaredNorm();
}

double PulseChiSqSNNLS::ComputeApproxUncertainty(unsigned int ipulse) {
  // compute approximate uncertainties
  // (using 1/second derivative since full Hessian is not meaningful in
  // presence of positive amplitude boundaries.)
  return 1./_covdecomp.matrixL().solve(_pulsemat.col(ipulse)).norm();
}

bool PulseChiSqSNNLS::NNLS() {
  // Fast NNLS (fnnls) algorithm as per 
  // http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.157.9203&rep=rep1&type=pdf
  
  // declarations of all needed parameters
  auto &A = _invcov;
  auto &b = _sampvec;
  // TODO: this should be a parameter not a magic number 
  auto epsilon = 1e-11;
  auto &x = _ampvec;
  std::vector<unsigned int> P;
  std::map<unsigned int, unsigned int> R;
  
  // initialization
  // cost vector
  auto w = A.transpose()*(b - A*x);
  
  // initial solution vector
  x.setZero();

  // initial set of indexes
  for ( unsigned int i=0; i<_bxs.rows(); ++i)
    R[i] = i;
  // initialize the value for the while guard
  // j will contain the index of the max coeff anf max_w is the max coeff 
  unsigned int max_index = 0;
  auto max_w = w[0];
  
  // main loop 
  do {
    // theres no eigen helper function for this. Thats why is calculated manually
    for (auto const &coeff: R){
      if(coeff.second>max_w){
        max_w = coeff.second;
        max_index = coeff.first;
      }  
    }
    // update P and R
    P.emplace_back(max_index);
    R.erase(max_index);
    
    // construct the submatrix A^P
    SampleMatrix sub_matrix(P.size(),_bxs.rows());
    SampleVector s;
    s.setZero();

    for (int i=0; i<P.size(); ++i){
      sub_matrix.col(i)=A.col(P[i]);
    }
    auto tmp_vector = (sub_matrix.transpose()*sub_matrix).inverse()*sub_matrix.transpose()*b;
    for (auto index: P){
      s[index]=tmp_vector[index];
    }
    SampleVector r_vector(R.size());
    
    while (s.minCoeff() <= 0){
      auto alpha = std::numeric_limits<double>::max();
      for(auto index: P){
        if (s[index] < 0){
          alpha = std::min(x[index]/(x[index]-s[index]), alpha);
        }
      }
      x += alpha*(s-x);
      for (unsigned int i; i<P.size(); ++i){
        if(x[i]==0){
          R[i];
        }
      }
    }
  

  } while(!R.empty() && max_w>epsilon);

  /*
  const unsigned int npulse = _bxs.rows();  
  SamplePulseMatrix invcovp = _covdecomp.matrixL().solve(_pulsemat);
  PulseMatrix aTamat(npulse,npulse);
  aTamat.triangularView<Eigen::Lower>() = invcovp.transpose()*invcovp;
  aTamat = aTamat.selfadjointView<Eigen::Lower>();
  PulseVector aTbvec = invcovp.transpose()*_covdecomp.matrixL().solve(_sampvec);  
  PulseVector wvec(npulse);
  
  
  for (int iter=0; iter<1000; ++iter){
    //can only perform this step if solution is guaranteed viable
    if (iter>0 || _nP==0) {
      if ( _nP==npulse ) break;                  
      
      const unsigned int nActive = npulse - _nP;
      
      wvec.tail(nActive) = aTbvec.tail(nActive) - (aTamat.selfadjointView<Eigen::Lower>()*_ampvec).tail(nActive);       
      
      Index idxwmax;
      double wmax = wvec.tail(nActive).maxCoeff(&idxwmax);
      
      //convergence
      if (wmax<1e-11) break;
    
      //unconstrain parameter
      Index idxp = _nP + idxwmax;
      //printf("adding index %i, orig index %i\n",int(idxp),int(_bxs.coeff(idxp)));
      aTamat.col(_nP).swap(aTamat.col(idxp));
      aTamat.row(_nP).swap(aTamat.row(idxp));
      _pulsemat.col(_nP).swap(_pulsemat.col(idxp));
      std::swap(aTbvec.coeffRef(_nP),aTbvec.coeffRef(idxp));
      std::swap(_ampvec.coeffRef(_nP),_ampvec.coeffRef(idxp));
      std::swap(_bxs.coeffRef(_nP),_bxs.coeffRef(idxp));
      ++_nP;
    }
        
    while (_nP>0) {  
      PulseVector ampvecpermtest = _ampvec;      
      //solve for unconstrained parameters      
      ampvecpermtest.head(_nP) = aTamat.topLeftCorner(_nP,_nP).ldlt().solve(aTbvec.head(_nP));     
      
      //check solution
      if (ampvecpermtest.head(_nP).minCoeff()>0.) {
        _ampvec.head(_nP) = ampvecpermtest.head(_nP);
        break;
      }      
      
      //update parameter vector
      Index minratioidx=0;
      
      double minratio = std::numeric_limits<double>::max();
      for (unsigned int ipulse=0; ipulse<_nP; ++ipulse) {
        if (ampvecpermtest.coeff(ipulse)<=0.) {
          double ratio = _ampvec.coeff(ipulse)/(_ampvec.coeff(ipulse)-ampvecpermtest.coeff(ipulse));
          if (ratio<minratio) {
            minratio = ratio;
            minratioidx = ipulse;
          }
        }
      }
      
      _ampvec.head(_nP) += minratio*(ampvecpermtest.head(_nP) - _ampvec.head(_nP));
      
      //avoid numerical problems with later ==0. check
      _ampvec.coeffRef(minratioidx) = 0.;
      
      //printf("removing index %i, orig idx %i\n",int(minratioidx),int(_bxs.coeff(minratioidx)));
      aTamat.col(_nP-1).swap(aTamat.col(minratioidx));
      aTamat.row(_nP-1).swap(aTamat.row(minratioidx));
      _pulsemat.col(_nP-1).swap(_pulsemat.col(minratioidx));
      std::swap(aTbvec.coeffRef(_nP-1),aTbvec.coeffRef(minratioidx));
      std::swap(_ampvec.coeffRef(_nP-1),_ampvec.coeffRef(minratioidx));
      std::swap(_bxs.coeffRef(_nP-1),_bxs.coeffRef(minratioidx));
      --_nP;
    }    
  }
  */
  return true;  
}
