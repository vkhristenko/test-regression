#include "multifit_gpu/interface/PulseChiSqSNNLSWrapper.h"
#include "multifit_gpu/interface/PulseChiSqSNNLS.h"

#include <vector>
#include <iostream>
#include <string>

std::vector<DoFitResults> doFitWrapper(std::vector<DoFitArgs> const& vargs) {
    // input parameters to the multifit on gpu
    DoFitArgs* d_args;
    DoFitResults* d_results;
    std::vector<DoFitResults> results;
    std::cout << "sizeof (DoFitResults) = " << sizeof(DoFitResults) << std::endl;
    std::cout << "sizeof (BXVector) = " << sizeof(BXVector) << std::endl;
    std::cout << "sizeof (PulseVector) = " << sizeof(PulseVector) << std::endl;
    std::cout << "vargs.size() = " << vargs.size() << std::endl;
    results.resize(100);
    std::cout << "size = " << results.size() << std::endl;
    std::cout << "capacity = " << results.capacity() << std::endl;

    // allocate on the device
    /*
    std::cout << "allocate on the device" << std::endl;
    cudaMalloc((void**) &d_args, sizeof(DoFitArgs) * vargs.size());
    cudaMalloc((void**) &d_results, sizeof(DoFitResults) * vargs.size());

    // transfer to the device
    std::cout << "copy to the device " << std::endl;
    cudaMemcpy(d_args, vargs.data(), sizeof(DoFitArgs) * vargs.size(), cudaMemcpyHostToDevice);

    // kernel invoacation
    std::cout << "launch the kenrel" << std::endl;
    int nthreadsPerBlock = 256;
    int nblocks = (vargs.size() + nthreadsPerBlock - 1) / nthreadsPerBlock;
    kernel_multifit<<<nblocks, nthreadsPerBlock>>>(d_args, d_results, vargs.size());
    cudaDeviceSynchronize();
    cudaError err = cudaGetLastError();
    std::string name = "multifit_gpu";
    if (err != cudaSuccess) {
        std::cout << "cuda eror!" << std::endl
            << cudaGetErrorString(err) << std::endl;
        std::cout << "test " << name << " failed" << std::endl;
    }

    // copy results back
    std::cout << "copy back to the host" << std::endl;
    cudaMemcpy(&(results[0]), d_results, sizeof(DoFitResults) * results.size(), cudaMemcpyDeviceToHost);
    std::cout << "vresults.size() = " << results.size() << std::endl;

    // free resources
    std::cout << "free the device memory" << std::endl;
    cudaFree(d_args);
    cudaFree(d_results);
    */

    return std::vector<DoFitResults>{};
}
