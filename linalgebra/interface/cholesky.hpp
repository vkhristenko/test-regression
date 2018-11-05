#ifndef cholesky_hpp
#define cholesky_hpp

#include <cmath>

using data_type = float;
#define M_LINEAR_ACCESS(M, row, col, dim) M[row * dim + col]
#define SIMPLE_SQRT(x) std::sqrt(x)

void cholesky_decomp(data_type*, data_type*, int);

#endif
