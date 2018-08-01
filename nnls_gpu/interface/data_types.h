#include <Eigen/Dense>

#ifndef NNLS_DATA_TYPES
#define NNLS_DATA_TYPES

#ifdef __CUDACC__
#define __CUDA__FUNC__ __host__ __device__
#else
#define __CUDA__FUNC__
#endif

const unsigned long MATRIX_SIZE = 10;
const unsigned long VECTOR_SIZE = 10;

typedef Eigen::Matrix<double, MATRIX_SIZE, MATRIX_SIZE> FixedMatrix;
typedef Eigen::Matrix<double, VECTOR_SIZE, 1> FixedVector;

typedef struct NNLS_args {
  FixedMatrix const& A;
  FixedVector const& b;
  NNLS_args(FixedMatrix const& A, FixedVector const& b) : A(A), b(b){};
} NNLS_args;

#define USE_SPARSE_QR 0
#define USE_LLT 1
#define USE_HOUSEHOLDER 2

#ifndef DECOMPOSITION
#define DECOMPOSITION USE_HOUSEHOLDER
#endif

// #ifndef __CUDACC__

// void print_fixed_matrix(const FixedMatrix& M);

// void print_fixed_vector(const FixedVector& V);

// #endif

// #ifdef __CUDACC__

// #include <stdio.h>
// // 
// __CUDA__FUNC__
// void print_fixed_matrix(const FixedMatrix& M) {
//   printf("ciao");
//   for (unsigned int i = 0; i < MATRIX_SIZE; i++) {
//     for (unsigned int j = 0; j < MATRIX_SIZE; j++) {
//       printf("%d ", M(i, j));
//     }
//     printf("\n");
//   }
// }

// __CUDA__FUNC__
// void print_fixed_vector(const FixedVector& V) {
//   printf("ciao");
//   for (unsigned int i = 0; i < MATRIX_SIZE; i++) {
//     printf("%d ", V[i]);
//   }
//   printf("\n");
// }
// #endif

#endif