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

// #include <iostream>

template <typename M, typename V>
Eigen::Matrix<typename M::Scalar,
              Eigen::Dynamic,
              Eigen::Dynamic,
              M::Options,
              M::RowsAtCompileTime,
              M::ColsAtCompileTime>
sub_matrix(const M& full, const V& index) {
  using matrix_t =
      Eigen::Matrix<typename M::Scalar, Eigen::Dynamic, Eigen::Dynamic,
                    M::Options, M::RowsAtCompileTime, M::ColsAtCompileTime>;
  matrix_t _matrix(index.size(), index.size());
  for (int i = 0; i < index.size(); i++) {
    auto idx = index[i];
    // std::cout << ' ' << idx;
    for (int j = 0; j < index.size(); j++) {
      auto idy = index[j];
      _matrix(i, j) = full(idx, idy);
    }
  }
  return _matrix;
}

template <typename M, typename V>
Eigen::Matrix<typename M::Scalar,
              Eigen::Dynamic,
              1,
              M::Options,
              M::RowsAtCompileTime,
              1>
sub_vector(const M& full, const V& index) {
  using matrix_t = Eigen::Matrix<typename M::Scalar, Eigen::Dynamic, 1,
                                 M::Options, M::RowsAtCompileTime, 1>;
  matrix_t _vector(index.size());
  for (int i = 0; i < index.size(); i++) {
    auto idx = index[i];
    _vector[i] = full[idx];
  }
  return _vector;
}

#endif