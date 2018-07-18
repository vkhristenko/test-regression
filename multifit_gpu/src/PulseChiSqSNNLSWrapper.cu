#include "multifit_gpu/interface/PulseChiSqSNNLSWrapper.h"
#include "multifit_gpu/interface/PulseChiSqSNNLS.h"

#include <vector>
#include <iostream>

std::vector<DoFitResults> doFitWrapper(std::vector<DoFitArgs> const& vargs) {
    // input parameters to the multifit on gpu
    DoFitArgs* d_args;
    DoFitResults* d_results;
    std::vector<DoFitResults> results;

    // allocate on the device
    std::cout << "allocate on the device" << std::endl;
    cudaMalloc((void**) &d_args, sizeof(DoFitArgs) * vargs.size());
    cudaMalloc((void**) &d_results, sizeof(DoFitResults) * vargs.size());

    // transfer to the device
    std::cout << "copy to the device " << std::endl;
    cudaMemcpy(d_args, vargs.data(), sizeof(DoFitArgs) * vargs.size(), cudaMemcpyHostToDevice);

    // kernel invoacation
    std::cout << "launch the kenrel" << std::endl;;
    kernel_multifit<<<1,1>>>(d_args, d_results, vargs.size());
    cudaDeviceSynchronize();
    cudaError err = cudaGetLastError();
    if (err != cudaSuccess) {
        std::cout << "cuda eror!" << std::endl
            << cudaGetErrorString(err) << std::endl;
        std::cout << "test " << name << " failed" << std::endl;
    }

    // copy results back
    std::cout << "copy back to the host" << std::endl;
    cudaMemcpy(&results[0], d_args, sizeof(DoFitResults) * vargs.size(), cudaMemcpyDeviceToHost);

    // free resources
    std::cout << "free the device memory" << std::endl;
    cudaFree(d_args);
    cudaFree(d_results);

    return results;
}
