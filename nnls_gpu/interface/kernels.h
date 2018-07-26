
#include "data_types.h"

typedef struct NNLS_args{
    FixedMatrix &A;
    FixedVector &b;
} NNLS_args;


__global__ void nnls_kernel(NNLS_args *args, 
                 FixedVector* x,
                 double eps=1e-11,
                 unsigned int max_iterations=1000);

__global__ void fnnls_kernel(NNLS_args *args, 
                 FixedVector* x,
                 double eps=1e-11,
                 unsigned int max_iterations=1000);