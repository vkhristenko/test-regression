#ifndef PulseChiSqSNNLS_h
#define PulseChiSqSNNLS_h

#include "EigenMatrixTypes.h"
#include <set>
#include <array>

typedef struct _DoFitArgs {
    SampleVector samples;
    SampleMatrix samplecor;
    double pederr;
    BXVector bxs;
    FullSampleVector fullpulse;
    FullSampleMatrix fullpulsecov;
} DoFitArgs;

__global__ void DoFitGPU(DoFitArgs* parameters, double* result);

class PulseChiSqSNNLS {
public:

  __device__ __host__ explicit PulseChiSqSNNLS();
  virtual ~PulseChiSqSNNLS();

  typedef BXVector::Index Index;
    
  __device__ bool DoFit(const SampleVector &samples, const SampleMatrix &samplecor, double pederr, 
             const BXVector &bxs, const FullSampleVector &fullpulse, const FullSampleMatrix &fullpulsecov);
  
  const SamplePulseMatrix &pulsemat() const { return _pulsemat; }
  const SampleMatrix &invcov() const { return _invcov; }
  
  const PulseVector &X() const { return _ampvecmin; }
  const PulseVector &Errors() const { return _errvec; }
  const BXVector &BXs() const { return _bxsmin; }
  
  double ChiSq() const { return _chisq; }
  __device__ __host__ void disableErrorCalculation() { _computeErrors = false; }
  
protected:
  
  __device__ bool Minimize(const SampleMatrix &samplecor, double pederr, const FullSampleMatrix &fullpulsecov);
  __device__ bool NNLS();
  __device__ bool updateCov(const SampleMatrix &samplecor, double pederr, const FullSampleMatrix &fullpulsecov);
  __device__ double ComputeChiSq();
  __device__ double ComputeApproxUncertainty(unsigned int ipulse);
  
  
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

#endif
