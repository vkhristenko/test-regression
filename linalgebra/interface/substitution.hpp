#ifndef substitution_hpp
#define substitution_hpp

#include "common.hpp"

/*
 * Solving Ax=b using forward substitution.
 * pM - Lower triangular matrix
 */
template<typename T>
void solve_forward_substitution(T *pM, T *pb, T *psolution, int n) {
    // very first element is trivial
    psolution[0] = pb[0] / pM[0];

    // for the rest
    for (int i=1; i<n; ++i) {
        T total = pb[i];
        for (int j=0; j<i; j++) {
            total -= M_LINEAR_ACCESS(pM, i, j, n) * psolution[j];
        }

        // set the value of the i-solution
        psolution[i] = total / M_LINEAR_ACCESS(pM, i, i, n);
    }
}

/*
 * Solving Ax=b using backward substitution
 * pM - Lower triangular matrix.
 * Note: we take lower triangular (not upper triangular) to remove the transposition
 * step required otherwise.
 */
template<typename T>
void solve_backward_substitution(T *pM, T *pb, T *psolution, int n) {
    // very last element is trivial
    psolution[n-1] = pb[n-1] / pM[n * n - 1];

    // for the rest
    for (int i=n-2; i>=0; --i) {
        T total = pb[i];
        for (int j=i+1; j<n; ++j) {
            total -= M_LINEAR_ACCESS(pM, j, i, n) * psolution[j];
        }

        psolution[i] = total / M_LINEAR_ACCESS(pM, i, i, n);
    }
}

#endif
