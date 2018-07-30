#include "../interface/kernel_wrapper.h"
#include "../interface/nnls.h"
#include "../interface/fnnls.h"

#include <iostream>
#include <string>

void assert_if_error(std::string const& name) {
    auto check = [&name](auto code) {
        if (code != cudaSuccess) {
            std::cout << cudaGetErrorString(code) << ' ';
            std::cout << "in " << name << std::endl;
            assert(false);
        }
    };

    check(cudaGetLastError());
}

std::vector<FixedVector> nnls_wrapper(
                            std::vector<NNLS_args> const& args,
                            double eps,
                            unsigned int max_iterations){
        // host solution vector
        std::vector<FixedVector> x(args.size());
        
        // device pointers
        NNLS_args* d_args;
        FixedVector* d_x;
        
        // arguments allocation
        cudaMalloc((void**) &d_args, sizeof(NNLS_args) * args.size());
        assert_if_error("nnls argument allocation");
        // results allocation
        cudaMalloc((void**) &d_x, sizeof(FixedVector) * args.size());
        assert_if_error("nnls result allocation");
        
        
        // arguments copy
        cudaMemcpy(d_args, args.data(), sizeof(NNLS_args) * args.size(), cudaMemcpyHostToDevice);
        assert_if_error("nnls parameters copy");
        

        printf("launch kernel nnls\n");
        // nnls_kernel<<<args.size()+255/256, 256>>>(d_args, d_x, args.size(), eps, max_iterations);
        nnls_kernel<<<1,1>>>(d_args, d_x, args.size(), eps, max_iterations);
        cudaDeviceSynchronize();
        assert_if_error("nnls kernel");
        printf("finish kernel nnls\n");
        
        // copy the results back from the device
        cudaMemcpy(&(x[0]), d_x, sizeof(FixedVector) * args.size(), cudaMemcpyDeviceToHost);
        
        // clear and exit
        cudaFree(d_args);
        cudaFree(d_x);

        return x;
    }
    
    std::vector<FixedVector> fnnls_wrapper(
                            std::vector<NNLS_args> const& args,
                            double eps,
                            unsigned int max_iterations){
        // host solution vector
        std::vector<FixedVector> x(args.size());
        
        // device pointers
        NNLS_args* d_args;
        FixedVector* d_x;
        
        // arguments allocation
        cudaMalloc((void**) &d_args, sizeof(NNLS_args) * args.size());
        // results allocation
        cudaMalloc((void**) &d_x, sizeof(FixedVector) * args.size());


        // arguments copy
        cudaMemcpy(d_args, args.data(), sizeof(NNLS_args) * args.size(), cudaMemcpyHostToDevice);
        
        printf("launch kernel fnnsl\n");
        // fnnls_kernel<<<args.size()+255/256, 256>>>(d_args, d_x, args.size(), eps, max_iterations);
        fnnls_kernel<<<1,1>>>(d_args, d_x, args.size(), eps, max_iterations);
        cudaDeviceSynchronize();
        assert_if_error("fnnls");
        printf("finish kernel fnnls\n");
        
        // copy the results back from the device
        cudaMemcpy(&(x[0]), d_x, sizeof(FixedVector) * args.size(), cudaMemcpyDeviceToHost);

        // clear and exit
        cudaFree(d_args);
        cudaFree(d_x);

        return x;            

    }
