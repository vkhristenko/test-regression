#include "multifit_gpu/interface/PulseChiSqSNNLSWrapper.h"

PulseChiSqSNNLSWrapper::PulseChiSqSNNLSWrapper(){};
PulseChiSqSNNLSWrapper::~PulseChiSqSNNLSWrapper(){};

void PulseChiSqSNNLSWrapper::disableErrorCalculation(){
    pulseChiSq.disableErrorCalculation();
}

void PulseChiSqSNNLSWrapper::DoFit(DoFitArgs* args, bool* status){
    GpuDoFit<<<1,1>>>(&pulseChiSq, args, status);
}
