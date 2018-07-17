#ifndef PULSECHISQSNNLSWRAPPER
#define PULSECHISQSNNLSWRAPPER

// #define EIGEN_DISABLE_UNALIGNED_ARRAY_ASSERT
// #define EIGEN_DONT_VECTORIZE 



#include "multifit_gpu/interface/PulseChiSqSNNLS.h"

DoFitResults* doFitWrapper(DoFitArgs* args, unsigned int n);

// class PulseChiSqSNNLSWrapper{
//     public:
//         // EIGEN_MAKE_ALIGNED_OPERATOR_NEW
//         void disableErrorCalculation();
//         const SamplePulseMatrix &pulsemat() const { return pulseChiSq.pulsemat(); }
//         const SampleMatrix &invcov() const { return pulseChiSq.invcov(); }
  
//         const PulseVector &X() const { return pulseChiSq.X(); }
//         const BXVector &BXs() const { return pulseChiSq.BXs(); }
  
//         double ChiSq() const { return pulseChiSq.ChiSq(); }

//         void DoFit(DoFitArgs* args, bool* status);
//         explicit PulseChiSqSNNLSWrapper();
//         virtual ~PulseChiSqSNNLSWrapper();
//     private:
//         PulseChiSqSNNLS pulseChiSq;
// };

#endif
