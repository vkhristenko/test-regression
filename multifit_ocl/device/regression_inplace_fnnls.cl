//
// inplace fnnls.
// for simplicity assume row major storage of all the matrices
//

//
// definitions of constants
//
#define NUM_TIME_SAMPLES 10
#define NUM_TIME_SAMPLES_SQ 100 
// to easily switch between row major and column major matrix representations
#define M_LINEAR_ACCESS(M, row, col) M[row * NUM_TIME_SAMPLES + col]
typedef float data_type;
#define SIMPLE_SQRT(x) sqrt(x)


//
// Various Matrix and Vector Multiplications 
// C = A * A_T -> the result is symmetric matrix.
// the restult matrix C will be stored in column major
//
void transpose_multiply_gm_lm(__global data_type const* A, 
                              __local data_type *restrict result);
void transpose_multiply_gm_gv_lv(__global data_type const *M, 
                                 __global data_type const *v, 
                                 __local data_type * restrict result);
void multiply_lm_lv_lv(__local data_type const * M, 
                       __local data_type const *v, 
                       __local data_type *restrict result);

void transpose_multiply_gm_lm(__global data_type const* A, 
                              __local data_type *restrict result) {
    for (int i=0; i<NUM_TIME_SAMPLES; ++i) {
        for (int j=i; j<NUM_TIME_SAMPLES; ++j) {
            M_LINEAR_ACCESS(result, i, j) = 0;
            for (int k=0; k<NUM_TIME_SAMPLES; ++k)
                M_LINEAR_ACCESS(result, i, j) += M_LINEAR_ACCESS(A, i, k) * M_LINEAR_ACCESS(A, j, k);
            M_LINEAR_ACCESS(result, j, i) = M_LINEAR_ACCESS(result, i, j);
       }
    }
}

void transpose_multiply_gm_gv_lv(__global data_type const *M, 
                                 __global data_type const *v, 
                                 __local data_type *restrict result) {
    for (int i=0; i<NUM_TIME_SAMPLES; ++i) {
        result[i] = 0;
        for (int k=0; k<NUM_TIME_SAMPLES; ++k) {
            result[i] += M_LINEAR_ACCESS(M, k, i) * v[k];
        }
    }
}

void multiply_lm_lv_lv(__local data_type const *M, 
                       __local data_type const *v, 
                       __local data_type *restrict result) {
    for (int i=0; i<NUM_TIME_SAMPLES; ++i) {
        result[i] = 0;
        for (int k=0; k<NUM_TIME_SAMPLES; ++k) 
            result[i] += M_LINEAR_ACCESS(M, i, k) * v[k];
    }
}

//
// Swap Functions
//
void swap_permm(__local data_type *permutation, int idx1, int idx2);
void swap_row_column(__local data_type *pM, 
                     int i, int j, int full_size, int view_size);
void swap_element(__local data_type *pv, int i, int j);
void swap_perm_element(__local int *pv, int i, int j);

void swap_element(__local data_type *pv,
                  int i, int j) {
    data_type tmp = pv[i];
    pv[i] = pv[j];
    pv[j] = tmp;
}

void swap_perm_element(__local int *pv,
                       int i, int j) {
    int tmp = pv[i];
    pv[i] = pv[j];
    pv[j] = tmp;
}

void swap_row_column(__local data_type *pM, 
                     int i, int j, int full_size, int view_size) {
    // diagnoal
    data_type tmptmp = M_LINEAR_ACCESS(pM, i, i);
    M_LINEAR_ACCESS(pM, i, i) = M_LINEAR_ACCESS(pM, j, j);
    M_LINEAR_ACCESS(pM, j, j) = tmptmp;

    // the rest 
    for (int elem=0; elem<i; ++elem) {
        data_type tmp = M_LINEAR_ACCESS(pM, i, elem);

        M_LINEAR_ACCESS(pM, i, elem) =
            M_LINEAR_ACCESS(pM, j, elem);
        M_LINEAR_ACCESS(pM, j, elem) = tmp;

        // for the column
        M_LINEAR_ACCESS(pM, elem, i) =
            M_LINEAR_ACCESS(pM, elem, j);
        M_LINEAR_ACCESS(pM, elem, j) = tmp;
    }
    for (int elem=i+1; elem<view_size; ++elem) {
        data_type tmp = M_LINEAR_ACCESS(pM, i, elem);

        M_LINEAR_ACCESS(pM, i, elem) =
            M_LINEAR_ACCESS(pM, j, elem);
        M_LINEAR_ACCESS(pM, j, elem) = tmp;

        // for the column
        M_LINEAR_ACCESS(pM, elem, i) =
            M_LINEAR_ACCESS(pM, elem, j);
        M_LINEAR_ACCESS(pM, elem, j) = tmp;
    }
}

//
// Cholesky Decomposition + Forward/Backward Substituion Solvers
//
void cholesky_decomp(__local data_type const* pM,
                     __local data_type * restrict pL,
                     int full_size, int view_size);
void fused_cholesky_forward_substitution_solver_rcadd(
        __local data_type const *pM, 
        __local data_type *restrict pL, 
        __local data_type const *pb,
        __local data_type *restrict py, 
        int full_size, int view_size);
void fused_cholesky_forward_substitution_solver_inbetween_removal(
        __local data_type const *pM, 
        __local data_type *restrict pL, 
        __local data_type const *pb, 
        __local data_type *restrict py, 
        int position, int full_size, int view_size);

void cholesky_decomp(__local data_type const* pM,  
                     __local data_type *restrict pL, 
                     int full_size, int view_size) {
    for (int i=0; i<view_size; ++i) {

        // first compute elements to the left of the diagoanl
        data_type sumsq = 0;
        for (int j=0; j<i; ++j) {

            data_type sumsq2 = 0;
            for (int k=0; k<j; ++k) {
                sumsq2 += M_LINEAR_ACCESS(pL, i, k) *
                    M_LINEAR_ACCESS(pL, j, k);
            }

            // compute the i,j : i>j. elements to the left of the diagonal
            M_LINEAR_ACCESS(pL, i, j) =
                (M_LINEAR_ACCESS(pM, i, j) - sumsq2)
                / M_LINEAR_ACCESS(pL, j, j);

            // needed to compute diagonal element
            sumsq += M_LINEAR_ACCESS(pL, i, j) *
                M_LINEAR_ACCESS(pL, i, j);
        }

        // second, compute the diagonal element
        M_LINEAR_ACCESS(pL, i, i) =
            SIMPLE_SQRT(M_LINEAR_ACCESS(pM, i, i) - sumsq);
    }
}

void fused_cholesky_forward_substitution_solver_rcadd(
        __local data_type const *pM, 
        __local data_type *restrict pL, 
        __local data_type const *pb,
        __local data_type *restrict py, 
        int full_size, int view_size) {
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
            sum2 += M_LINEAR_ACCESS(pL, row, j) *
                M_LINEAR_ACCESS(pL, col, j);
        }

        // compute the row,col : row > col. elements to the left of the diagonal
        data_type value_row_col = (M_LINEAR_ACCESS(pM, row, col) - sum2)
            / M_LINEAR_ACCESS(pL, col, col);

        // update the sum needed for forward substitution
        total -= value_row_col * py[col];

        // needed to compute the diagonal element
        sum += value_row_col * value_row_col;

        // set the value
        M_LINEAR_ACCESS(pL, row, col) = value_row_col;
    }

    // compute the diagonal value
    data_type diag_value = SIMPLE_SQRT(M_LINEAR_ACCESS(pM, row, row)
        - sum);
    M_LINEAR_ACCESS(pL, row, row) = diag_value;

    // compute the new value (view_size - 1 ) of the result of forward substitution
    data_type y_last = total / diag_value;
    py[row] = y_last;
}

void fused_cholesky_forward_substitution_solver_inbetween_removal(
        __local data_type const *pM, 
        __local data_type *restrict pL, 
        __local data_type const *pb, 
        __local data_type *restrict py, 
        int position, int full_size, int view_size) {
    // only for elements with >= position
    for (int i=position; i<view_size; ++i) {

        // first compute elements to the left of the diagoanl
        data_type sumsq = 0;
        data_type total = pb[i];
        for (int j=0; j<i; ++j) {

            data_type sumsq2 = 0;
            for (int k=0; k<j; ++k) {
                sumsq2 += M_LINEAR_ACCESS(pL, i, k) *
                    M_LINEAR_ACCESS(pL, j, k);
            }

            // compute the i,j : i>j. elements to the left of the diagonal
            data_type value_i_j =
                (M_LINEAR_ACCESS(pM, i, j) - sumsq2)
                / M_LINEAR_ACCESS(pL, j, j);
            M_LINEAR_ACCESS(pL, i, j) = value_i_j;
            total -= value_i_j * py[j];

            // needed to compute diagonal element
            sumsq += value_i_j * value_i_j;
        }

        // second, compute the diagonal element
        data_type value_i_i =
            SIMPLE_SQRT(M_LINEAR_ACCESS(pM, i, i) - sumsq);
        M_LINEAR_ACCESS(pL, i, i) = value_i_i;

        // compute the i-th solution value for forward sub
        py[i] = total / value_i_i;
    }
}

void solve_forward_substitution(__local data_type const *pM, 
                                __local data_type const* pb, 
                                __local data_type *restrict psolution,
                                int full_size, int view_size);
void solve_forward_substitution(__local data_type const *pM, 
                                __local data_type const* pb, 
                                __local data_type *restrict psolution,
                                int full_size, int view_size) {
    // very first element is trivial
    psolution[0] = pb[0] / pM[0];

    // for the rest
    for (int i=1; i<view_size; ++i) {
        data_type total = pb[i];
        for (int j=0; j<i; j++) {
            total -= M_LINEAR_ACCESS(pM, i, j) * psolution[j];
        }

        // set the value of the i-solution
        psolution[i] = total / M_LINEAR_ACCESS(pM, i, i);
    }
}

/*
 * Solving Ax=b using backward substitution
 * pM - Lower triangular matrix.
 * Note: we take lower triangular (not upper triangular) to remove the transposition
 * step required otherwise.
 */
void solve_backward_substitution(__local data_type const *pM, 
                                 __local data_type const *pb, 
                                 __local data_type *restrict psolution,
                                 int full_size, int view_size);
void solve_backward_substitution(__local data_type const *pM, 
                                 __local data_type const *pb, 
                                 __local data_type *restrict psolution,
                                 int full_size, int view_size) {
    // very last element is trivial
    psolution[view_size-1] = pb[view_size-1] /
        M_LINEAR_ACCESS(pM, view_size-1, view_size-1);

    // for the rest
    for (int i=view_size-2; i>=0; --i) {
        data_type total = pb[i];
        for (int j=i+1; j<view_size; ++j) {
            total -= M_LINEAR_ACCESS(pM, j, i) * psolution[j];
        }

        psolution[i] = total / M_LINEAR_ACCESS(pM, i, i);
    }
}

void permutation_identity(__local int *permutation);
void permutation_identity(__local int *permutation) {
    for (int i=0; i<NUM_TIME_SAMPLES; ++i)
        permutation[i] = i;
}

//
// fast nnls w/o copying (inplace updates)
//
void inplace_fnnls(__global data_type const *A,
                   __global data_type const *b,
                   __global data_type *restrict x,
                   float const epsilon,
                   unsigned int const max_iterations);

void inplace_fnnls(__global data_type const *A,
                   __global data_type const *b,
                   __global data_type *restrict x,
                   float const epsilon,
                   unsigned int const max_iterations) {
    // initial setup
    int npassive = 0;
    __local data_type AtA[NUM_TIME_SAMPLES_SQ];
    __local data_type Atb[NUM_TIME_SAMPLES];
    __local data_type s[NUM_TIME_SAMPLES];
    __local data_type w[NUM_TIME_SAMPLES];
    __local data_type final_s[NUM_TIME_SAMPLES];
    __local int permutation[NUM_TIME_SAMPLES];
    __local data_type AtAx[NUM_TIME_SAMPLES];
    __local data_type pL[NUM_TIME_SAMPLES_SQ];
    __local data_type py[NUM_TIME_SAMPLES];
    transpose_multiply_gm_lm(A, AtA);
    transpose_multiply_gm_gv_lv(A, b, Atb);
    permutation_identity(permutation);

    // loop over all iterations. 
    for (unsigned int iter = 0; iter < max_iterations; ++iter) {
        int nactive = NUM_TIME_SAMPLES - npassive;

        // exit condition
        if (!nactive)
            break;

        // update the gradient vector but only for the active constraints
        multiply_lm_lv_lv(AtA, final_s, AtAx);
        data_type max_w_value; int max_w_idx; 
        int iii = 0;
        for (int i=npassive; i<NUM_TIME_SAMPLES; ++i) {
            w [ i ] = Atb [ i ] - AtAx [ i ];

            if (iii == 0 || w [ i ] > max_w_value) {
                max_w_value = w [ i ];
                max_w_idx = i;
            }

            ++iii;
        }

        // convergence check
        if (max_w_value < epsilon)
            break;

        // note, max_w_idx already points to the right location in the vector
        // run swaps
        swap_row_column(AtA, npassive, max_w_idx, 
            NUM_TIME_SAMPLES, NUM_TIME_SAMPLES);
        swap_element(Atb, npassive, max_w_idx);
        swap_element(final_s, npassive, max_w_idx);
        swap_perm_element(permutation, npassive, max_w_idx);

        ++npassive;

        // inner loop
        int inner_iteration = 0;
        int position_removed = -1;
        while (npassive > 0) {
            if (npassive == 1) {
                // scalar case
                data_type l_0_0 = sqrt(AtA[0]);
                data_type y_0_0 = Atb[0] / l_0_0;
                pL[0] = l_0_0;
                py[0] = y_0_0;
                position_removed = -1;
            } else if (inner_iteration == 0) {
                fused_cholesky_forward_substitution_solver_rcadd(
                    AtA, pL, Atb, py, NUM_TIME_SAMPLES, npassive);
            } else {
                fused_cholesky_forward_substitution_solver_inbetween_removal(
                    AtA, pL, Atb, py, position_removed, NUM_TIME_SAMPLES, npassive);
            }
            solve_backward_substitution(pL, py, s, NUM_TIME_SAMPLES, npassive);

            // update the elements from the passive set
            data_type min_s_value = s [ 0 ];
            for (int i=1; i<npassive; ++i) {
                if (s [ i ] < min_s_value)
                    min_s_value = s [ i ];
            }

            // if elements of the passive set are all positive
            // set the solution vector and break from the inner loop
            if (min_s_value > 0.0f) {
                for (int i=0; i<npassive; ++i)
                    final_s [ i ] = s [ i ];
                break;
            }

            // 
            data_type alpha = FLT_MAX;
            int alpha_idx = 0;
            for (int i=0; i<npassive; ++i) {
                if (s [ i ] <= 0.0f) {
                    data_type const ratio = final_s [ i ] / ( final_s [ i ] - s [ i ] );
                    if (ratio < alpha) {
                        alpha = ratio;
                        alpha_idx = i;
                    }
                }
            }

            if (alpha == FLT_MAX) {
                for (int i=0; i<npassive; ++i) 
                    final_s [ i ] = s [ i ];
                break;
            }

            // update solution using alpha
            for (int i=0; i<npassive; ++i) {
                final_s [ i ] += alpha * (s [ i ] - final_s [ i ]);
            }
            final_s [ alpha_idx] = 0;
            --npassive;

            // run swaps
            swap_row_column(AtA, npassive, alpha_idx,
                NUM_TIME_SAMPLES, NUM_TIME_SAMPLES);
            swap_element(Atb, npassive, alpha_idx);
            swap_element(final_s, npassive, alpha_idx);
            swap_perm_element(permutation, npassive, alpha_idx);
            inner_iteration++;
            position_removed = alpha_idx;
        }
    }

    // permute the solution vector back to have x[i] sit at the original position
    for (int i=0; i<NUM_TIME_SAMPLES; ++i) {
        x [ permutation[i] ] = final_s [i];
    }
}

//
// a wrapper around inplace_fnnls to arrange the data per work item
//
__kernel void inplace_fnnls_facade(__global data_type const *vA,
                                   __global data_type const *vb,
                                   __global data_type const *vx,
                                   float const epsilon,
                                   unsigned int const max_iterations) {
    // get the global index - identifies the detector channel 
    int idx = get_global_id(0);
        
    // get the pointer to the right location for the idx
    __global data_type const *ptrA = vA + idx * NUM_TIME_SAMPLES_SQ;
    __global data_type const *ptrb = vb + idx * NUM_TIME_SAMPLES;
    __global data_type const *ptrx = vx + idx * NUM_TIME_SAMPLES;

    // launch the fnnls itself for the right worker item
    inplace_fnnls(ptrA, ptrb, ptrx, epsilon, max_iterations);
}
