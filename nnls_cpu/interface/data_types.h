#include <Eigen/Dense>

#ifndef NNLS_DATA_TYPES
#define NNLS_DATA_TYPES

const unsigned long MATRIX_SIZE = 10;
const unsigned long VECTOR_SIZE = 10;

typedef Eigen::Matrix<double, MATRIX_SIZE, MATRIX_SIZE> FixedMatrix;
typedef Eigen::Matrix<double, VECTOR_SIZE, 1> FixedVector;

#define USE_LDLT 0
#define USE_LLT 1
#define USE_HOUSEHOLDER 2

#ifndef DECOMPOSITION
#define DECOMPOSITION USE_LDLT
#endif

#endif