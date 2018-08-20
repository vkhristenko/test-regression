#ifndef PulseChiSqSNNLS_h
#define PulseChiSqSNNLS_h

#include "EigenMatrixTypes.h"
#include "DeviceData.h"

class PulseChiSqSNNLS {
public:

  __host__ __device__ explicit PulseChiSqSNNLS();
  typedef BXVector::Index Index;
    
  __host__ __device__ bool DoFit(const SampleVector &samples, const SampleMatrix &samplecor, double pederr, 
             const BXVector &bxs, const FullSampleVector &fullpulse, const FullSampleMatrix &fullpulsecov);
  
  __host__ __device__ const SamplePulseMatrix &pulsemat() const { return _pulsemat; }
  __host__ __device__ const SampleMatrix &invcov() const { return _invcov; }
  
  __host__ __device__ const PulseVector &X() const { return _ampvecmin; }
  __host__ __device__ const PulseVector &Errors() const { return _errvec; }
  __host__ __device__ const BXVector &BXs() const { return _bxsmin; }
  
  __host__ __device__ double ChiSq() const { return _chisq; }
  __host__ __device__ void disableErrorCalculation() { _computeErrors = false; }
  
protected:
  
  __host__ __device__ bool Minimize(const SampleMatrix &samplecor, double pederr, const FullSampleMatrix &fullpulsecov);
  __host__ __device__ bool NNLS();
  __host__ __device__ bool updateCov(const SampleMatrix &samplecor, double pederr, const FullSampleMatrix &fullpulsecov);
  __host__ __device__ double ComputeChiSq();
  __host__ __device__ double ComputeApproxUncertainty(unsigned int ipulse);
  
  
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

__global__ void kernel_multifit(DoFitArgs *parameters, Output* results, unsigned int n);

#endif
