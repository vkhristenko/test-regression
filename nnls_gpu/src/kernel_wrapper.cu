#include "../interface/kernel_wrapper.h"
#include "../interface/nnls.h"
#include "../interface/fnnls.h"

#include <iostream>
#include <string>


using namespace std;

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

        // cudaDeviceSetLimit(cudaLimitPrintfFifoSize, 0);
        // host solution vector
        std::vector<FixedVector> x(args.size());
        
        // device pointers
        NNLS_args* d_args;
        FixedVector* d_x;
        
        #ifdef DEBUG_NNLS_WRAPPER
        cout << "sizes: " << args.size() << endl;

        for(auto& arg: args){
            
            cout << "A" << endl;
            cout << arg.A << endl;
            cout << "b" << endl;
            cout << arg.b << endl;
        }
        #endif
        // arguments allocation
        if(cudaMalloc(&d_args, sizeof(NNLS_args) * args.size()) != cudaSuccess){
            cout << "first malloc failed" << endl;
            assert(false);
        }
        assert_if_error("nnls argument allocation");
        // results allocation
        if(cudaMalloc(&d_x, sizeof(FixedVector) * args.size()) != cudaSuccess){
            cout << "second malloc failed" << endl;
            assert(false);
        }
        assert_if_error("nnls result allocation");
        
        
        // arguments copy
        auto error = cudaMemcpy(d_args, args.data(), sizeof(NNLS_args) * args.size(), cudaMemcpyHostToDevice);
        if(error != cudaSuccess){
            cout << "memcpy failed" << endl;
            assert(false);
        }

        assert_if_error("nnls parameters copy");
        

        printf("launch kernel nnls\n");

        int nthreadsPerBlock = 256;
        int nblocks = (args.size() + nthreadsPerBlock - 1) / nthreadsPerBlock;
        cout << "threads per block " << nthreadsPerBlock << 
        " blocks " << nblocks <<
        " input size " << args.size() << endl; 
        nnls_kernel<<<nblocks, nthreadsPerBlock>>>(d_args, d_x, args.size(), eps, max_iterations);
        // nnls_kernel<<<10,10>>>(d_args, d_x, args.size(), eps, max_iterations);
        // nnls_kernel<<<args.size(),1>>>(d_args, d_x, args.size(), eps, max_iterations);
        // nnls_kernel<<<10, 10>>>(d_args, d_x, args.size(), eps, max_iterations);
        cudaDeviceSynchronize();
        assert_if_error("nnls kernel");
        printf("finish kernel nnls\n");
        
        // copy the results back from the device
        cudaMemcpy(x.data(), d_x, sizeof(FixedVector) * args.size(), cudaMemcpyDeviceToHost);
        
        // clear and exit
        cudaFree(d_args);
        cudaFree(d_x);
        #ifdef DEBUG_NNLS_WRAPPER
        for(const auto& result: x){
            cout << "x" << endl;
            cout << result.transpose() << endl;
            // break;
        }
        #endif
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
        int nthreadsPerBlock = 256;
        int nblocks = (args.size() + nthreadsPerBlock - 1) / nthreadsPerBlock;
        fnnls_kernel<<<nblocks, nthreadsPerBlock>>>(d_args, d_x, args.size(), eps, max_iterations);
        // fnnls_kernel<<<1,1>>>(d_args, d_x, args.size(), eps, max_iterations);
        cudaDeviceSynchronize();
        assert_if_error("fnnls");
        printf("finish kernel fnnls\n");
        
        // copy the results back from the device
        cudaMemcpy(x.data(), d_x, sizeof(FixedVector) * args.size(), cudaMemcpyDeviceToHost);

        // clear and exit
        cudaFree(d_args);
        cudaFree(d_x);

        // for(const auto& result: x){
            // cout << "x" << endl;
            // cout << result.transpose() << endl;
            // break;
        // }
        
        return x;            

    }
