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
#define DECOMPOSITION USE_LLT
#endif

#include <iostream>

template <typename M, typename V>
Eigen::Matrix<typename M::Scalar,
              Eigen::Dynamic,
              Eigen::Dynamic,
              M::Options,
              M::RowsAtCompileTime,
              M::ColsAtCompileTime>
sub_matrix(const M& full, const V& index, unsigned int size) {
  using matrix_t =
      Eigen::Matrix<typename M::Scalar, Eigen::Dynamic, Eigen::Dynamic,
                    M::Options, M::RowsAtCompileTime, M::ColsAtCompileTime>;
  matrix_t _matrix(size, size);

  // std::cout << "full" << std::endl << full << std::endl;

  auto idx = 0;
#pragma unroll
  for (int i = 0; i < VECTOR_SIZE; i++) {
    if (index[i])
      continue;
    // std::cout << i << ' ';
    auto idy = 0;
#pragma vectorise
    for (int j = 0; j < VECTOR_SIZE; j++) {
      if (index[j])
        continue;
      _matrix(idx, idy) = full(i, j);
      ++idy;
    }
    ++idx;
  }
  // std::cout << std::endl
  // << "small matrix " << std::endl
  // << _matrix << std::endl;
  return _matrix;
}

template <typename M, typename V>
Eigen::Matrix<typename M::Scalar,
              Eigen::Dynamic,
              1,
              M::Options,
              M::RowsAtCompileTime,
              1>
sub_vector(const M& full, const V& index, unsigned int size) {
  using matrix_t = Eigen::Matrix<typename M::Scalar, Eigen::Dynamic, 1,
                                 M::Options, M::RowsAtCompileTime, 1>;
  matrix_t _vector(size);
  // std::cout << "full vector" << std::endl << full << std::endl;

  auto idx = 0;
#pragma unroll
  for (int i = 0; i < VECTOR_SIZE; i++) {
    if (index[i])
      continue;
    // std::cout << i << ' ';
    _vector[idx++] = full[i];
  }
  // std::cout << std::endl
  // << "small vector " << std::endl
  // << _vector << std::endl;
  return _vector;
}

#endif