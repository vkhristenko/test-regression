#include "../interface/kernel_wrapper.h"
#include "../interface/nnls.h"
#include "../interface/fnnls.h"



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
        // results allocation
        cudaMalloc((void**) &d_x, sizeof(FixedVector) * args.size());


        // arguments copy
        cudaMemcpy(d_args, args.data(), sizeof(NNLS_args) * args.size(), cudaMemcpyHostToDevice);
        
        
        nnls_kernel<<<1, 1>>>(d_args, d_x, args.size(), eps, max_iterations);
        
        // copy the results back from the device
        cudaMemcpy(d_x, &(x[0]), sizeof(FixedVector) * args.size(), cudaMemcpyDeviceToHost);
        
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
        
        
        fnnls_kernel<<<1, 1>>>(d_args, d_x, args.size(), eps, max_iterations);
        
        // copy the results back from the device
        cudaMemcpy(d_x,  &(x[0]), sizeof(FixedVector) * args.size(), cudaMemcpyDeviceToHost);

        // clear and exit
        cudaFree(d_args);
        cudaFree(d_x);

        return x;            

    }