#include "linalgebra/interface/cholesky.hpp"

/*
 * M - input symmetric positive definite squared matrix
 * L - output lower triangular matrix
 * n - dimension
 */
void cholesky_decomp(data_type *pM, data_type *pL, int n) {
    for (int i=0; i<n; ++i) {

        // first compute elements to the left of the diagoanl
        data_type sumsq = 0;
        for (int j=0; j<i; ++j) {
            
            data_type sumsq2 = 0;
            for (int k=0; k<j; ++k) {
                sumsq2 += M_LINEAR_ACCESS(pL, i, k, n) * M_LINEAR_ACCESS(pL, j, k, n);
            }
            
            // compute the i,j : i>j. elements to the left of the diagonal
            M_LINEAR_ACCESS(pL, i, j, n) = (M_LINEAR_ACCESS(pM, i, j, n) - sumsq2)
                / M_LINEAR_ACCESS(pL, j, j, n);

            // needed to compute diagonal element
            sumsq += M_LINEAR_ACCESS(pL, i, j, n) * M_LINEAR_ACCESS(pL, i, j, n);
        }

        // second, compute the diagonal element
        M_LINEAR_ACCESS(pL, i, i, n) = 
            SIMPLE_SQRT(M_LINEAR_ACCESS(pM, i, i, n) - sumsq);
    }
}
