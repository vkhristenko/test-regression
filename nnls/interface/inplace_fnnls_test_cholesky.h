#ifndef inplace_fnnls_test_cholesky_h
#define inplace_fnnls_test_cholesky_h

#include "data_types.h"

#ifdef __CUDA_ARCH__
__device__ __host__
#endif
    void
    inplace_fnnls_test_cholesky(const FixedMatrix& A,
                  const FixedVector& b,
                  FixedVector& x,
                  const double eps = 1e-11,
                  const unsigned int max_iterations = 1000);

#endif // inplace_fnnls_test_cholesky
