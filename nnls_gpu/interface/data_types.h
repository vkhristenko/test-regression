#include <Eigen/Dense>

#ifndef NNLS_DATA_TYPES
#define NNLS_DATA_TYPES

const unsigned long MATRIX_SIZE = 10;
const unsigned long VECTOR_SIZE = 10;

typedef Eigen::Matrix<double, MATRIX_SIZE, MATRIX_SIZE> FixedMatrix;
typedef Eigen::Matrix<double, VECTOR_SIZE, 1> FixedVector;


typedef struct NNLS_args{
    FixedMatrix &A;
    FixedVector &b;
    NNLS_args(FixedMatrix &A, FixedVector &b): A(A), b(b) {};
} NNLS_args;

#endif