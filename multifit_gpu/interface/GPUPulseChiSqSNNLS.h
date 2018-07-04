#ifndef GPUPulseChiSqSNNLS_h
#define GPUPulseChiSqSNNLS_h

#include "EigenMatrixTypes.h"
#include <set>
#include <array>

class GPUPulseChiSqSNNLS {
public:
  
  typedef BXVector::Index Index;

  typedef struct _DoFitArgs {
    SampleVector samples;
    SampleMatrix samplecor;
    double pederr;
    BXVector bxs;
    FullSampleVector fullpulse;
    FullSampleMatrix fullpulsecov;
  } DoFitArgs;

  GPUPulseChiSqSNNLS();
  ~GPUPulseChiSqSNNLS();
  
  bool DoFitGPU(DoFitArgs* parameters);
  
  bool DoFit(const SampleVector &samples, const SampleMatrix &samplecor, double pederr, 
             const BXVector &bxs, const FullSampleVector &fullpulse, const FullSampleMatrix &fullpulsecov);
  
  const SamplePulseMatrix &pulsemat() const { return _pulsemat; }
  const SampleMatrix &invcov() const { return _invcov; }
  
  const PulseVector &X() const { return _ampvecmin; }
  const PulseVector &Errors() const { return _errvec; }
  const BXVector &BXs() const { return _bxsmin; }
  
  double ChiSq() const { return _chisq; }
  void disableErrorCalculation() { _computeErrors = false; }
  
protected:
  
  bool Minimize(const SampleMatrix &samplecor, double pederr, const FullSampleMatrix &fullpulsecov);
  bool NNLS();
  bool updateCov(const SampleMatrix &samplecor, double pederr, const FullSampleMatrix &fullpulsecov);
  double ComputeChiSq();
  double ComputeApproxUncertainty(unsigned int ipulse);
  
  
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
