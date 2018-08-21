#include <Eigen/Dense>
#include "nnls_cpu/interface/data_types.h"

#ifndef NNLS_GPU_DATA_TYPES
#define NNLS_GPU_DATA_TYPES

typedef struct NNLS_args {
  FixedMatrix const A;
  FixedVector const b;
  NNLS_args(FixedMatrix const A, FixedVector const b) : A(A), b(b){};
} NNLS_args;

#endif