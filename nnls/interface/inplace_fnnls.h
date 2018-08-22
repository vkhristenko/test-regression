#ifndef ONE_PASS_FNNLS_H
#define ONE_PASS_FNNLS_H

#include "data_types.h"

#ifdef __CUDA_ARCH__
__device__ __host__
#endif
    void
    inplace_fnnls(const FixedMatrix& A,
                  const FixedVector& b,
                  FixedVector& x,
                  const double eps = 1e-11,
                  const unsigned int max_iterations = 1000);

#endif
