#include "../interface/kernels.h"

__global__ void nnls_kernel(NNLS_args *args, FixedVector* x, unsigned int n, double eps, unsigned int max_iterations){
        // thread idx
        int i = blockIdx.x*blockDim.x + threadIdx.x;
        if (i>=n) return;
        auto &A = args[i].A;
        auto &b = args[i].b;
        x[i] = nnls(A, b, eps, max_iterations);
    }

__global__ void fnnls_kernel(NNLS_args *args, FixedVector* x, unsigned int n, double eps, unsigned int max_iterations){
        // thread idx
        int i = blockIdx.x*blockDim.x + threadIdx.x;
        if (i>=n) return;
        auto &A = args[i].A;
        auto &b = args[i].b;
        x[i] = fnnls(A, b, eps, max_iterations);
    }