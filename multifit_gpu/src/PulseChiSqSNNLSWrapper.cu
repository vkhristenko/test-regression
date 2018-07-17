#include "multifit_gpu/interface/PulseChiSqSNNLSWrapper.h"
#include "multifit_gpu/interface/EigenMatrixTypes.h"
#include "multifit_gpu/interface/PulseChiSqSNNLS.h"

// PulseChiSqSNNLSWrapper::PulseChiSqSNNLSWrapper(){};
// PulseChiSqSNNLSWrapper::~PulseChiSqSNNLSWrapper(){};

// void PulseChiSqSNNLSWrapper::disableErrorCalculation(){
//     pulseChiSq.disableErrorCalculation();
// }

// void PulseChiSqSNNLSWrapper::DoFit(DoFitArgs* args, bool* status){
//     GpuDoFit<<<1,1>>>(&pulseChiSq, args, status);
// }

DoFitResults* doFitWrapper(DoFitArgs* args, unsigned int n){
    DoFitArgs* deviceArgs;
    cudaMalloc((void**) &deviceArgs, sizeof(DoFitArgs)*n);
    cudaMemcpy(deviceArgs, args, sizeof(DoFitArgs)*n, cudaMemcpyHostToDevice);
    DoFitResults* deviceResults;
    DoFitResults* results;
    cudaMalloc((void**) &deviceResults, sizeof(DoFitResults)*n);
    GpuDoFit<<<1,1>>>(deviceArgs, deviceResults, n);
    cudaMemcpy(deviceResults, results, sizeof(DoFitResults)*n, cudaMemcpyDeviceToHost);
    cudaFree(deviceArgs);
    cudaFree(deviceResults);
    return results;
}
