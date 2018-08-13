#include <Eigen/Dense>

#include <algorithm>
#include <vector>

#ifdef DEBUG_FNNLS_CPU
#include <iostream>
#endif

#include "../interface/fnnls.h"

using namespace std;
using namespace Eigen;

void fnnls(const FixedMatrix& A,
           const FixedVector& b,
           FixedVector& x,
           const double eps,
           const unsigned int max_iterations) {
  // Fast NNLS (fnnls) algorithm as per
  // http://users.wfu.edu/plemmons/papers/Chennnonneg.pdf
  // page 8

  // FNNLS memorizes the A^T * A and A^T * b to reduce the computation.
  // The pseudo-inverse obtined has the same numerical problems so
  // I keep the same decomposition utilized for NNLS.

  // pseudoinverse (A^T * A)^-1 * A^T
  // this pseudo-inverse has numerical issues
  // in order to avoid that I substitued the pseudoinvese wiht the QR
  // decomposition

  std::vector<unsigned int> P;
  std::vector<unsigned int> R(VECTOR_SIZE);
  std::vector<unsigned int> tmp;

// initial set of indexes
#pragma unroll
  for (unsigned int i = 0; i < VECTOR_SIZE; ++i)
    R[i] = i;

  // initial solution vector

  auto AtA = (A.transpose() * A);
  auto Atb = A.transpose() * b;

  // main loop
  for (int iter = 0; iter < max_iterations; ++iter) {
#ifdef DEBUG_FNNLS_CPU
    cout << "iter " << iter << endl;
#endif

    FixedVector w = Atb - (AtA * x);

#ifdef DEBUG_FNNLS_CPU
    cout << "w" << endl << w << endl;
#endif

    // initialize the value for the while guard
    // max_index will contain the index of the max coeff anf max_w is the max
    // coeff
    unsigned int max_index = R[0];
    unsigned int remove_index = 0;

    for (unsigned int i = 0; i < R.size(); ++i) {
      auto index = R[i];
      if (w[index] > w[max_index]) {
        max_index = index;
        remove_index = i;
      }
    }

#ifdef DEBUG_FNNLS_CPU
    cout << "max index " << max_index << endl;
#endif

    P.emplace_back(max_index);
    R.erase(R.begin() + remove_index);

    // termination condition
    if (R.empty() || w[max_index] < eps)
      break;

#ifdef DEBUG_FNNLS_CPU
    cout << "P " << endl;
    for (auto elem : P)
      cout << elem << " ";
    cout << endl;
    cout << "R " << endl;
    for (auto elem : R)
      cout << elem << " ";
    cout << endl;
#endif

#if DECOMPOSITION != USE_HOUSEHOLDER
    std::sort(P.begin(), P.end());
    Eigen::Matrix<double, -1, -1, 0, 10, 10> AtA_P =
        sub_matrix<FixedMatrix, std::vector<unsigned int> >(AtA, P);
    Eigen::Matrix<double, -1, 1, 0, 10, 1> Atb_P =
        sub_vector<FixedVector, std::vector<unsigned int> >(Atb, P);
    FixedVector s = FixedVector::Zero();
#elif DECOMPOSITION == USE_HOUSEHOLDER
    FixedMatrix A_P = FixedMatrix::Zero();
    for (auto index : P) {
      A_P.col(index) = A.col(index);
    }
#endif

#if DECOMPOSITION == USE_LLT
    Eigen::Matrix<double, -1, 1, 0, 10, 1> tmp_s = AtA_P.llt().solve(Atb_P);
    // Eigen::Matrix<double, -1, 1, 0, 10, 1> tmp_s = AtA_P.inverse() * Atb_P;
    for (unsigned int i = 0; i < P.size(); i++) {
      auto index = P[i];
      s[index] = tmp_s[i];
    }
#elif DECOMPOSITION == USE_LDLT
    Eigen::Matrix<double, -1, 1, 0, 10, 1> tmp_s = AtA_P.ldlt().solve(Atb_P);
    for (unsigned int i = 0; i < P.size(); i++) {
      auto index = P[i];
      s[index] = tmp_s[i];
    }
#elif DECOMPOSITION == USE_HOUSEHOLDER
    FixedVector s = A_P.colPivHouseholderQr().solve(b);
#endif

#ifdef DEBUG_FNNLS_CPU
    cout << "s" << endl << s << endl;
#endif

    // inner loop
    while (true) {
      auto alpha = std::numeric_limits<double>::max();

      for (auto index : P) {
        if (s[index] <= 0) {
          alpha = std::min(-x[index] / (s[index] - x[index]), alpha);
        }
      }

      if (std::numeric_limits<double>::max() == alpha)
        break;

#ifdef DEBUG_FNNLS_CPU

      cout << "alpha " << alpha << endl;

      cout << "x before" << endl << x << endl;

#endif

      x += alpha * (s - x);

#ifdef DEBUG_FNNLS_CPU
      cout << "x after" << endl << x << endl;
#endif

#ifdef DEBUG_FNNLS_CPU
      cout << "P  before" << endl;
      for (auto elem : P)
        cout << elem << " ";
      cout << endl;
      cout << "R before" << endl;
      for (auto elem : R)
        cout << elem << " ";
      cout << endl;
#endif

      tmp.clear();

      for (int i = P.size() - 1; i >= 0; --i) {
        auto index = P[i];
        if (x[index] == 0) {
          R.emplace_back(index);
          tmp.emplace_back(i);
        }
      }

      for (auto index : tmp)
        P.erase(P.begin() + index);

#ifdef DEBUG_FNNLS_CPU
      cout << "P  after" << endl;
      for (auto elem : P)
        cout << elem << " ";
      cout << endl;
      cout << "R after" << endl;
      for (auto elem : R)
        cout << elem << " ";
      cout << endl;
#endif

#if DECOMPOSITION != USE_HOUSEHOLDER
      std::sort(P.begin(), P.end());
      AtA_P = sub_matrix<FixedMatrix, std::vector<unsigned int> >(AtA, P);
      Atb_P = sub_vector<FixedVector, std::vector<unsigned int> >(Atb, P);
      s.setZero();
#elif DECOMPOSITION == USE_HOUSEHOLDER
      A_P.setZero();
      for (auto index : P) {
        A_P.col(index) = A.col(index);
      }
#endif

#if DECOMPOSITION == USE_LLT
      tmp_s = AtA_P.llt().solve(Atb_P);
      // tmp_s = AtA_P.inverse() * Atb_P;
      for (unsigned int i = 0; i < P.size(); i++) {
        auto index = P[i];
        s[index] = tmp_s[i];
      }
#elif DECOMPOSITION == USE_LDLT
      tmp_s = AtA_P.ldlt().solve(Atb_P);
      for (unsigned int i = 0; i < P.size(); i++) {
        auto index = P[i];
        s[index] = tmp_s[i];
      }
#elif DECOMPOSITION == USE_HOUSEHOLDER
      A_P.colPivHouseholderQr().solve(b);
#endif
    }
    x = s;
  }
}
