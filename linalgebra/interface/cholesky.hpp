#ifndef cholesky_hpp
#define cholesky_hpp

#include <cmath>

#include "common.hpp"

template<typename T>
void cholesky_decomp(T *pM, T *pL, int full_size, int view_size) {
    using data_type = T;

    for (int i=0; i<view_size; ++i) {

        // first compute elements to the left of the diagoanl
        data_type sumsq = 0;
        for (int j=0; j<i; ++j) {

            data_type sumsq2 = 0;
            for (int k=0; k<j; ++k) {
                sumsq2 += M_LINEAR_ACCESS(pL, i, k, full_size) * 
                    M_LINEAR_ACCESS(pL, j, k, full_size);
            }

            // compute the i,j : i>j. elements to the left of the diagonal
            M_LINEAR_ACCESS(pL, i, j, full_size) = 
                (M_LINEAR_ACCESS(pM, i, j, full_size) - sumsq2)
                / M_LINEAR_ACCESS(pL, j, j, full_size);

            // needed to compute diagonal element
            sumsq += M_LINEAR_ACCESS(pL, i, j, full_size) * 
                M_LINEAR_ACCESS(pL, i, j, full_size);
        }

        // second, compute the diagonal element
        M_LINEAR_ACCESS(pL, i, i, full_size) =
            SIMPLE_SQRT(M_LINEAR_ACCESS(pM, i, i, full_size) - sumsq);
    }
}

#endif
