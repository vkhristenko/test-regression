#include "data_types.h"

#ifndef NNLS_H
#define NNLS_H

void nnls(const FixedMatrix &A, 
              const FixedVector &b, 
              FixedVector& x,
              const double eps=1e-11,
              const unsigned int max_iterations=1000
              );

#endif