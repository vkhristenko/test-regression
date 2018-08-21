#include "data_types.h"

#ifndef ONE_PASS_FNNLS_H
#define ONE_PASS_FNNLS_H

#ifdef NVCC
__device__ __host__
#endif
    void
    inplace_fnnls(const FixedMatrix& A,
                  const FixedVector& b,
                  FixedVector& x,
                  const double eps = 1e-11,
                  const unsigned int max_iterations = 1000);

#endif

#ifdef NVCC
__global__ void inplace_fnnls_kernel(NNLS_args *args, 
                 FixedVector* x,
                 const unsigned int n,
                 const double eps=1e-11,
                 const unsigned int max_iterations=1000);

#endif