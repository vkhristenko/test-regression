#ifndef PulseChiSqSNNLS_h
#define PulseChiSqSNNLS_h

#include "EigenMatrixTypes.h"
#include <set>
#include <array>

class PulseChiSqSNNLS {
public:
  typedef BXVector::Index Index;

  bool DoFit(const SampleVector &samples, const SampleMatrix &samplecor, double pederr, const BXVector &bxs, const FullSampleVector &fullpulse, const FullSampleMatrix &fullpulsecov);
  
  const SamplePulseMatrix &pulsemat() const { return _pulsemat; }
  const SampleMatrix &invcov() const { return _invcov; }
  
  const PulseVector &X() const { return _ampvecmin; }
  const PulseVector &Errors() const { return _errvec; }
  const BXVector &BXs() const { return _bxsmin; }
  
  double ChiSq() const { return _chisq; }
  void disableErrorCalculation() { _computeErrors = false; }
    
  PulseChiSqSNNLS();
  ~PulseChiSqSNNLS();
  
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


// template <typename T, typename T2, typename T3>
// inline T3 sub_vector(const T2& full, const T& ind)
// {
//     int num_indices = ind.size();
//     T3 target = T3::Zero(full.size());
//     for (int i = 0; i < num_indices; i++){
//         auto index = ind[i];
//         target[i] = full[ind[i]];
//     }
//     return target;
// }

template <typename T, typename T2, typename T3>
inline T3 sub_matrix(const T2& full, const T& ind)
{
    int num_indices = ind.size();
    T3 target = T3::Zero(full.rows(), full.cols());
    
    for (auto index: ind){
        target.col(index) = full.col(index);
    }
    // for (int i = 0; i < num_indices; i++)
    //   for (int j = 0; j < num_indices; j++)
    
    //     target(i,j) = full(ind[i], ind[j]);
    return target;
}


#endif
