#ifndef PULSECHISQSNNLSWRAPPER
#define PULSECHISQSNNLSWRAPPER

#include "multifit_gpu/interface/EigenMatrixTypes.h"
#include "multifit_gpu/interface/PulseChiSqSNNLS.h"

class PulseChiSqSNNLSWrapper{
    public:
        void disableErrorCalculation();
        const SamplePulseMatrix &pulsemat() const { return pulseChiSq.pulsemat(); }
        const SampleMatrix &invcov() const { return pulseChiSq.invcov(); }
  
        const PulseVector &X() const { return pulseChiSq.X(); }
        const BXVector &BXs() const { return pulseChiSq.BXs(); }
  
        double ChiSq() const { return pulseChiSq.ChiSq(); }

        void DoFit(DoFitArgs* args, double* result);
        explicit PulseChiSqSNNLSWrapper();
        virtual ~PulseChiSqSNNLSWrapper();
    private:
        PulseChiSqSNNLS pulseChiSq;
};

#endif
