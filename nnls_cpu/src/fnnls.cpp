#include <Eigen/Dense>

#include <algorithm>
#include <vector>

#ifdef DEBUG_FNNLS_CPU
#include <iostream>
#endif

// #define DEBUG_FNNLS_CPU

#include "../interface/fnnls.h"

using namespace std;
using namespace Eigen;

void print_active_set(std::vector<bool> v, std::string s = "") {
  std::cout << s;
  for (size_t i = 0; i < VECTOR_SIZE; i++) {
    std::cout << i << ' ';
  }
  std::cout << std::endl;

  for (size_t i = 0; i < VECTOR_SIZE; i++) {
    std::cout << v[i] << ' ';
  }
  std::cout << std::endl;
}

void fnnls(const FixedMatrix& A,
           const FixedVector& b,
           FixedVector& x,
           const double eps,
           const unsigned int max_iterations) {
  // Fast NNLS (fnnls) algorithm as per
  // http://users.wfu.edu/plemmons/papers/Chennnonneg.pdf
  // page 8

  // FNNLS memorizes the A^T * A and A^T * b to reduce the computation.
  // The pseudo-inverse obtained has the same numerical problems so
  // I keep the same decomposition utilized for NNLS.

  // pseudoinverse (A^T * A)^-1 * A^T
  // this pseudo-inverse has numerical issues
  // in order to avoid that I substituted the pseudoinverse whit the QR
  // decomposition

  // std::vector<bool> P(VECTOR_SIZE, false);
  // std::vector<bool> R(VECTOR_SIZE, true);

  // I'm substituting the vectors P and R that represents active and passive set
  // with a boolean vector: if active_set[i] the i belogns to R else to P

  // std::vector<bool> active_set(VECTOR_SIZE, true);
  bool active_set[VECTOR_SIZE];
  memset(active_set, true, VECTOR_SIZE * sizeof(bool));

  // print_active_set(active_set);

  // std::vector<unsigned int> tmp;

  // initial set of indexes

  // #pragma unroll
  // for (unsigned int i = 0; i < VECTOR_SIZE; ++i)
  // R[i] = i;

  // initial solution vector

  auto AtA = A.transpose() * A;
  auto Atb = A.transpose() * b;

#if DECOMPOSITION != USE_HOUSEHOLDER
  Eigen::Matrix<double, -1, -1, 0, 10, 10> AtA_P;
  Eigen::Matrix<double, -1, 1, 0, 10, 1> Atb_P;
  Eigen::Matrix<double, -1, 1, 0, 10, 1> tmp_s;
#endif

  FixedVector s = FixedVector::Zero();
  FixedVector w;

  // main loop
  for (int iter = 0; iter < max_iterations; ++iter) {
#ifdef DEBUG_FNNLS_CPU
    cout << "iter " << iter << endl;
#endif

    w = Atb - (AtA * x);

#ifdef DEBUG_FNNLS_CPU
    cout << "w" << endl << w << endl;
#endif

    // initialize the value for the while guard
    // max_index will contain the index of the max coeff anf max_w is the max
    // coeff
    unsigned int max_index = 0;
    // unsigned int remove_index = 0;

    int n_active = -1;

#pragma vectorise
    for (auto i = 0; i < VECTOR_SIZE; ++i) {
      if (active_set[i]) {
        ++n_active;
        if (w[i] > w[max_index]) {
          max_index = i;
        }
      }
    }
    // print_active_set(active_set);

#ifdef DEBUG_FNNLS_CPU
    cout << "max index " << max_index << endl;
#endif

    active_set[max_index] = false;

    // print_active_set(active_set);

    // std::cout << "n_active " << n_active << std::endl;

    // termination condition
    // if n_active == 0 then exit
    if (!n_active || w[max_index] < eps)
      break;

#if DECOMPOSITION != USE_HOUSEHOLDER
    // std::sort(P.begin(), P.end());
    AtA_P = sub_matrix<FixedMatrix, bool[VECTOR_SIZE]>(AtA, active_set,
                                                       VECTOR_SIZE - n_active);
    Atb_P = sub_vector<FixedVector, bool[VECTOR_SIZE]>(Atb, active_set,
                                                       VECTOR_SIZE - n_active);
    // s.setZero();
#elif DECOMPOSITION == USE_HOUSEHOLDER
    FixedMatrix A_P = FixedMatrix::Zero();
    for (auto index : P) {
      A_P.col(index) = A.col(index);
    }
#endif

#if DECOMPOSITION == USE_LLT
    tmp_s = AtA_P.llt().solve(Atb_P);
    auto index = 0;
#pragma unroll
    for (auto i = 0; i < VECTOR_SIZE; i++) {
      if (active_set[i])
        s[i] = 0.;
      else
        s[i] = tmp_s[index++];
    }
#elif DECOMPOSITION == USE_LDLT
    tmp_s = AtA_P.ldlt().solve(Atb_P);
    for (auto i = 0; i < P.size(); i++) {
      auto index = P[i];
      s[index] = tmp_s[i];
    }
#elif DECOMPOSITION == USE_HOUSEHOLDER
    s = A_P.colPivHouseholderQr().solve(b);
#endif

#ifdef DEBUG_FNNLS_CPU
    cout << "s" << endl << s << endl;
#endif

    // inner loop
    while (true) {
      auto alpha = std::numeric_limits<double>::max();

#pragma vectorise
      for (auto i = 0; i < VECTOR_SIZE; i++) {
        if (!active_set[i] && s[i] <= 0.) {
          alpha = std::min(-x[i] / (s[i] - x[i]), alpha);
        }
      }
      if (std::numeric_limits<double>::max() == alpha) {
        x = s;
        break;
      }

#ifdef DEBUG_FNNLS_CPU

      cout << "alpha " << alpha << endl;

      cout << "x before" << endl << x << endl;

#endif

      x += alpha * (s - x);

#ifdef DEBUG_FNNLS_CPU
      cout << "x after" << endl << x << endl;
#endif

#ifdef DEBUG_FNNLS_CPU
      // cout << "P  before" << endl;
      // for (auto elem : P)
      //   cout << elem << " ";
      // cout << endl;
      // cout << "R before" << endl;
      // for (auto elem : R)
      //   cout << elem << " ";
      // cout << endl;
#endif

#pragma vectorise
      for (auto i = 0; i < VECTOR_SIZE; i++) {
        if (!active_set[i] && x[i] == 0) {
          active_set[i] = true;
          ++n_active;
        }
      }

#if DECOMPOSITION != USE_HOUSEHOLDER
      AtA_P = sub_matrix<FixedMatrix, bool[VECTOR_SIZE]>(
          AtA, active_set, VECTOR_SIZE - n_active);
      Atb_P = sub_vector<FixedVector, bool[VECTOR_SIZE]>(
          Atb, active_set, VECTOR_SIZE - n_active);
#elif DECOMPOSITION == USE_HOUSEHOLDER
      A_P.setZero();
      for (auto index : P) {
        A_P.col(index) = A.col(index);
      }
#endif

#if DECOMPOSITION == USE_LLT
      tmp_s = AtA_P.llt().solve(Atb_P);
      auto idx = 0;
#pragma vectorise
      for (unsigned int i = 0; i < VECTOR_SIZE; i++) {
        // auto index = P[i];
        if (active_set[i])
          s[i] = 0;
        else
          s[i] = tmp_s[idx++];
      }
#elif DECOMPOSITION == USE_LDLT
      tmp_s = AtA_P.ldlt().solve(Atb_P);
      for (unsigned int i = 0; i < P.size(); i++) {
        auto index = P[i];
        s[index] = tmp_s[i];
      }
#elif DECOMPOSITION == USE_HOUSEHOLDER
      s = A_P.colPivHouseholderQr().solve(b);
#endif
    }
  }
}
