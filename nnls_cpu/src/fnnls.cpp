#include <Eigen/Dense>

#include <vector>

#ifdef DEBUG_FNNLS_CPU
#include <iostream>
#endif

#include "../interface/fnnls.h"

using namespace std;
using namespace Eigen;

FixedVector fnnls(const FixedMatrix& A,
                  const FixedVector& b,
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

// initial set of indexes
#pragma unroll
  for (unsigned int i = 0; i < VECTOR_SIZE; ++i)
    R[i] = i;

  // initial solution vector
  FixedVector x = FixedVector::Zero();

  auto AtA = A.transpose() * A;
  auto Atb = A.transpose() * b;

  // main loop
  for (int iter = 0; iter < max_iterations; ++iter) {
#ifdef DEBUG_FNNLS_CPU
    cout << "iter " << iter << endl;
#endif

    // FNNLS
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

    FixedMatrix A_P = FixedMatrix::Zero();

    for (auto index : P)
      A_P.col(index) = A.col(index);

#if DECOMPOSITION == USE_LLT
    FixedVector s = A_P.llt().matrixL().solve(b);
#elif DECOMPOSITION == USE_LDLT
    FixedVector s = A_P.ldlt().matrixL().solve(b);
#elif DECOMPOSITION == USE_HOUSEHOLDER
    FixedVector s = A_P.colPivHouseholderQr().solve(b);
#endif

#ifdef DEBUG_FNNLS_CPU
    cout << "s" << endl << s << endl;
#endif

    // inner loop
    while (true) {
      auto min_s = std::numeric_limits<double>::max();

      for (auto index : P)
        min_s = std::min(s[index], min_s);

#ifdef DEBUG_FNNLS_CPU
      cout << "min_s " << min_s << endl;
#endif

      if (min_s > 0)
        break;

      auto alpha = std::numeric_limits<double>::max();

      for (auto index : P) {
        if (s[index] <= 0) {
          alpha = std::min(-x[index] / (s[index] - x[index]), alpha);
        }
      }
#ifdef DEBUG_FNNLS_CPU

      cout << "alpha " << alpha << endl;

      cout << "x before" << endl << x << endl;

#endif

      for (auto index : P)
        x[index] += alpha * (s[index] - x[index]);

#ifdef DEBUG_FNNLS_CPU
      cout << "x after" << endl << x << endl;
#endif

      std::vector<unsigned int> tmp;

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

      A_P.setZero();

      for (auto index : P)
        A_P.col(index) = A.col(index);

#if DECOMPOSITION == USE_LLT
      s = A_P.llt().matrixL().solve(b);
#elif DECOMPOSITION == USE_LDLT
      s = A_P.ldlt().matrixL().solve(b);
#elif DECOMPOSITION == USE_HOUSEHOLDER
      s = A_P.colPivHouseholderQr().solve(b);
#endif

      for (auto index : R)
        s[index] = 0;
    }

    x = s;
  }

  return x;
}
