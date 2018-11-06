#ifndef substitution_hpp
#define substitution_hpp

#include "common.hpp"

/*
 * Solving Ax=b using forward substitution.
 * pM - Lower triangular matrix
 */
template<typename T>
void solve_forward_substitution(T *pM, T *pb, T *psolution, 
                                int full_size, int view_size) {
    // very first element is trivial
    psolution[0] = pb[0] / pM[0];

    // for the rest
    for (int i=1; i<view_size; ++i) {
        T total = pb[i];
        for (int j=0; j<i; j++) {
            total -= M_LINEAR_ACCESS(pM, i, j, full_size) * psolution[j];
        }

        // set the value of the i-solution
        psolution[i] = total / M_LINEAR_ACCESS(pM, i, i, full_size);
    }
}

/*
 * Solving Ax=b using backward substitution
 * pM - Lower triangular matrix.
 * Note: we take lower triangular (not upper triangular) to remove the transposition
 * step required otherwise.
 */
template<typename T>
void solve_backward_substitution(T *pM, T *pb, T *psolution, 
                                 int full_size, int view_size) {
    // very last element is trivial
    psolution[view_size-1] = pb[view_size-1] /
        M_LINEAR_ACCESS(pM, view_size-1, view_size-1, full_size);

    // for the rest
    for (int i=view_size-2; i>=0; --i) {
        T total = pb[i];
        for (int j=i+1; j<view_size; ++j) {
            total -= M_LINEAR_ACCESS(pM, j, i, full_size) * psolution[j];
        }

        psolution[i] = total / M_LINEAR_ACCESS(pM, i, i, full_size);
    }
}

#endif
