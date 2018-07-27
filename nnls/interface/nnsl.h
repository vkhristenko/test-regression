#include "data_types.h"

#ifndef NNLS
#define NNLS

FixedVector nnls(const FixedMatrix &A, const FixedVector &b, const double eps=1e-11, const unsigned int max_iterations=10);

#endif