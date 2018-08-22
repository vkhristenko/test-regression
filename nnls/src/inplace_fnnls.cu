#include <Eigen/Dense>

#include "../interface/inplace_fnnls.h"

using namespace Eigen;


// #define DEBUG_FNNLS_CPU
#ifdef __CUDA_ARCH__
__device__ __host__ 
#endif
void inplace_fnnls(const FixedMatrix& A,
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

  // I'm substituting the vectors P and R that represents active and passive set
  // with a boolean vector: if active_set[i] the i belogns to R else to P

  // bool active_set[VECTOR_SIZE];
  // memset(active_set, true, VECTOR_SIZE * sizeof(bool));
  auto nPassive = 0;

  FixedMatrix AtA = A.transpose() * A; 
  FixedVector Atb = A.transpose() * b;

  FixedVector s;
  FixedVector w;

  Eigen::PermutationMatrix<VECTOR_SIZE> permutation;
  permutation.setIdentity();

// main loop
#pragma unroll VECTOR_SIZE
  for (auto iter = 0; iter < max_iterations; ++iter) {
    const auto nActive = VECTOR_SIZE - nPassive;

#ifdef DEBUG_FNNLS_CPU
    cout << "iter " << iter << endl;
#endif
    
    if(!nActive)
      break;

    w.tail(nActive) = Atb.tail(nActive) - (AtA * x).tail(nActive);

#ifdef DEBUG_FNNLS_CPU
    cout << "w" << endl << w.tail(nActive) << endl;
#endif
    // get the index of w that gives the maximum gain
    Index w_max_idx;
    const auto max_w = w.tail(nActive).maxCoeff(&w_max_idx);

    // check for convergence
    if (max_w < eps )
      break;

    // cout << "n active " << nActive << endl;
    // cout << "w max idx " << w_max_idx << endl;

    // need to translate the index into the right part of the vector
    w_max_idx += nPassive;

    // swap AtA to avoid copy
    AtA.col(nPassive).swap(AtA.col(w_max_idx));
    AtA.row(nPassive).swap(AtA.row(w_max_idx));
    // swap Atb to match with AtA
    Eigen::numext::swap(Atb.coeffRef(nPassive), Atb.coeffRef(w_max_idx));
    Eigen::numext::swap(x.coeffRef(nPassive), x.coeffRef(w_max_idx));
    // swap the permutation matrix to reorder the solution in the end
    Eigen::numext::swap(permutation.indices()[nPassive],
                        permutation.indices()[w_max_idx]);

    ++nPassive;

#ifdef DEBUG_FNNLS_CPU
    cout << "max index " << w_max_idx << endl;
    std::cout << "n_active " << nActive << std::endl;
#endif

// inner loop
#pragma unroll VECTOR_SIZE
    while (nPassive > 0) {
      s.head(nPassive) =
          AtA.topLeftCorner(nPassive, nPassive).llt().solve(Atb.head(nPassive));

      if (s.head(nPassive).minCoeff() > 0.) {
        x.head(nPassive) = s.head(nPassive);
        break;
      }

#ifdef DEBUG_FNNLS_CPU
      cout << "s" << endl << s.head(nPassive) << endl;
#endif

      auto alpha = std::numeric_limits<double>::max();
      Index alpha_idx = 0;

#pragma unroll VECTOR_SIZE
      for (auto i = 0; i < nPassive; ++i) {
        if (s[i] <= 0.) {
          auto const ratio = x[i] / (x[i] - s[i]);
          if (ratio < alpha) {
            alpha = ratio;
            alpha_idx = i;
          }
        }
      }
      if (std::numeric_limits<double>::max() == alpha) {
        x.head(nPassive) = s.head(nPassive);
        break;
      }

#ifdef DEBUG_FNNLS_CPU

      cout << "alpha " << alpha << endl;

      cout << "x before" << endl << x << endl;

#endif

      x.head(nPassive) += alpha * (s.head(nPassive) - x.head(nPassive));
      x[alpha_idx] = 0;
      --nPassive;

#ifdef DEBUG_FNNLS_CPU
      cout << "x after" << endl << x << endl;
#endif
      AtA.col(nPassive).swap(AtA.col(alpha_idx));
      AtA.row(nPassive).swap(AtA.row(alpha_idx));
      // swap Atb to match with AtA
      Eigen::numext::swap(Atb.coeffRef(nPassive), Atb.coeffRef(alpha_idx));
      Eigen::numext::swap(x.coeffRef(nPassive), x.coeffRef(alpha_idx));
      // swap the permutation matrix to reorder the solution in the end
      Eigen::numext::swap(permutation.indices()[nPassive],
                          permutation.indices()[alpha_idx]);
    }
  }
  x = x.transpose() * permutation.transpose();
}
