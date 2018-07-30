
#include "data_types.h"

#ifndef KENRELS_H
#define KENRELS_H


__global__ void nnls_kernel(NNLS_args *args, 
                 FixedVector* x,
                 const unsigned int n,
                 const double eps=1e-11,
                 const unsigned int max_iterations=1000);

__global__ void fnnls_kernel(NNLS_args *args, 
                 FixedVector* x,
                 const unsigned int n,
                 const double eps=1e-11,
                 const unsigned int max_iterations=1000);

#endif