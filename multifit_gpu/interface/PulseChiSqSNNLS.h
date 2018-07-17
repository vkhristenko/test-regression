#ifndef PulseChiSqSNNLS_h
#define PulseChiSqSNNLS_h

#ifdef __CUDACC__
#define CUDA_CALLABLE_MEMBER __host__ __device__
#else
#define CUDA_CALLABLE_MEMBER
#endif 


#include "EigenMatrixTypes.h"
#include <set>
#include <array>


typedef struct DoFitArgs{
    SampleVector samples;
    SampleMatrix samplecor;
    double pederr;
    BXVector bxs;
    FullSampleVector fullpulse;
    FullSampleMatrix fullpulsecov;
    DoFitArgs(
              const SampleVector &samples, 
              const SampleMatrix &samplecor, 
              double pederr, 
              const BXVector &bxs, 
              const FullSampleVector &fullpulse,
              const FullSampleMatrix &fullpulsecov) :
      samples(samples), 
      samplecor(samplecor), 
      pederr(pederr), 
      bxs(bxs), 
      fullpulse(fullpulse),
      fullpulsecov(fullpulsecov) {};
} DoFitArgs;


class PulseChiSqSNNLS {
public:
  // EIGEN_MAKE_ALIGNED_OPERATOR_NEW

  CUDA_CALLABLE_MEMBER explicit PulseChiSqSNNLS();
  CUDA_CALLABLE_MEMBER ~PulseChiSqSNNLS();

  typedef BXVector::Index Index;
    
  CUDA_CALLABLE_MEMBER bool DoFit(const SampleVector &samples, const SampleMatrix &samplecor, double pederr, 
             const BXVector &bxs, const FullSampleVector &fullpulse, const FullSampleMatrix &fullpulsecov);
  
  const SamplePulseMatrix &pulsemat() const { return _pulsemat; }
  const SampleMatrix &invcov() const { return _invcov; }
  
  const PulseVector &X() const { return _ampvecmin; }
  const PulseVector &Errors() const { return _errvec; }
  const BXVector &BXs() const { return _bxsmin; }
  
  double ChiSq() const { return _chisq; }
  CUDA_CALLABLE_MEMBER void disableErrorCalculation() { _computeErrors = false; }
  
protected:
  
  CUDA_CALLABLE_MEMBER bool Minimize(const SampleMatrix &samplecor, double pederr, const FullSampleMatrix &fullpulsecov);
  CUDA_CALLABLE_MEMBER bool NNLS();
  CUDA_CALLABLE_MEMBER bool updateCov(const SampleMatrix &samplecor, double pederr, const FullSampleMatrix &fullpulsecov);
  CUDA_CALLABLE_MEMBER double ComputeChiSq();
  CUDA_CALLABLE_MEMBER double ComputeApproxUncertainty(unsigned int ipulse);
  
  
  SampleVector _sampvec;
  SampleMatrix _invcov;
  SamplePulseMatrix _pulsemat;
  PulseVector _ampvec;
  PulseVector _errvec;
  PulseVector _ampvecmin;
  
  SampleDecompLLT _covdecomp;
  
  BXVector _bxs;
  BXVector _bxsmin;
  unsigned int _nP;
  
  double _chisq;
  bool _computeErrors;
};

#ifdef __CUDACC__
__global__ void GpuDoFit(PulseChiSqSNNLS *pulse, DoFitArgs *parameters, bool *status);
#endif

#endif
