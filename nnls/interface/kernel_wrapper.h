#ifndef KERNEL_WRAPPER_H
#define KERNEL_WRAPPER_H

#include <vector>
#include "../interface/data_types.h"

__global__ 
void inplace_fnnls_kernel(NNLS_args *args,
                                     FixedVector* x,
                                     const unsigned int n,
                                     const double eps=1e-11,
                                     const unsigned int max_iterations=1000);

__global__
void fnnls_kernel(NNLS_args *args,
                  FixedVector* x,
                  const unsigned int n,
                  const double eps=1e-11,
                  const unsigned int max_iterations=1000);

std::vector<FixedVector> fnnls_wrapper(
    std::vector<NNLS_args> const& args,
    const double eps = 1e-11,
    const unsigned int max_iterations = 1000);

#endif
