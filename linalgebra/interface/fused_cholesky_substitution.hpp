#ifndef fused_cholesky_substitution_hpp
#define fused_cholesky_substitution_hpp

#include "common.hpp"

/*
 * Fused Cholesky + Forward Substitutions Solver
 * assume 
 *   0) view_size - size of the matrix view within matrix of dimension size.
 *   view_size is the newly updated view size after adding a row/column
 *   1) that pM points to a squared symetric matrix, 
 *   which just got a new column/row at view_size - 1
 *   2) that pL points to the lower triangular matrix which has been the result of 
 *   Cholesky before adding a new row/column
 *   3) py the result of doing Ly=b
 *
 */
template<typename T>
void fused_cholesky_forward_substitution_solver_rcaddition(
        T *pM, T *pL, T *pb,T *py, int full_size, int view_size) {
    using data_type = T;

    /*
     * cholesky decomposition using partial computation
     * only compute values in the row that was just added
     */
    data_type sum = 0;
    int row = view_size - 1;
    data_type total = pb[row];
    for (int col=0; col<row; ++col) {
        data_type sum2 = 0;
        for (int j=0; j<col; ++j) {
            sum2 += M_LINEAR_ACCESS(pL, row, j, full_size) * 
                M_LINEAR_ACCESS(pL, col, j, full_size);
        }

        // compute the row,col : row > col. elements to the left of the diagonal
        data_type value_row_col = (M_LINEAR_ACCESS(pM, row, col, full_size) - sum2)
            / M_LINEAR_ACCESS(pL, col, col, full_size);

        // update the sum needed for forward substitution
        total -= value_row_col * py[col];

        // needed to compute the diagonal element
        sum += value_row_col * value_row_col;

        // set the value
        M_LINEAR_ACCESS(pL, row, col, full_size) = value_row_col;
    }

    // compute the diagonal value
    data_type diag_value = SIMPLE_SQRT(M_LINEAR_ACCESS(pM, row, row, full_size) 
        - sum);
    M_LINEAR_ACCESS(pL, row, row, full_size) = diag_value;

    // compute the new value (view_size - 1 ) of the result of forward substitution
    data_type y_last = total / diag_value;
    py[row] = y_last;
}

/*
 * Assume position at which a row/column was removed is neither last nor first
 */
template<typename T>
void fused_cholesky_forward_substitution_solver_inbetween_removal(
        T *pM, T *pL, T *pb, T *py, int position, int full_size, int view_size) {
    using data_type = T;

    // only for elements with >= position
    for (int i=position; i<view_size; ++i) {

        // first compute elements to the left of the diagoanl
        data_type sumsq = 0;
        data_type total = pb[i];
        for (int j=0; j<i; ++j) {

            data_type sumsq2 = 0;
            for (int k=0; k<j; ++k) {
                sumsq2 += M_LINEAR_ACCESS(pL, i, k, full_size) *
                    M_LINEAR_ACCESS(pL, j, k, full_size);
            }

            // compute the i,j : i>j. elements to the left of the diagonal
            data_type value_i_j =
                (M_LINEAR_ACCESS(pM, i, j, full_size) - sumsq2)
                / M_LINEAR_ACCESS(pL, j, j, full_size);
            M_LINEAR_ACCESS(pL, i, j, full_size) = value_i_j;
            total -= value_i_j * py[j];

            // needed to compute diagonal element
            sumsq += value_i_j * value_i_j;
        }

        // second, compute the diagonal element
        data_type value_i_i =
            SIMPLE_SQRT(M_LINEAR_ACCESS(pM, i, i, full_size) - sumsq);
        M_LINEAR_ACCESS(pL, i, i, full_size) = value_i_i;

        // compute the i-th solution value for forward sub
        py[i] = total / value_i_i;
    }
}

#endif // fused_cholesky_substitution_hpp
