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
#define M_LINEAR_ACCESS(M, row, col) M[row * 10 + col]
typedef float data_type;


//
// C = A * A_T -> the result is symmetric matrix.
// the restult matrix C will be stored in column major
//
void transpose_multiply_mm_same_matrix(__global data_type const* A, data_type *result);
void transpose_multiply_mv(__global data_type const *M, __global data_type const *v, data_type *result);
void multiply_m_globalv(data_type const *M, data_type const *v, data_type *result);
void swap_m_row(data_type *matrix, int row1, int row2);
void swap_m_col(data_type *matrix, int col1, int col2);
void swap_v(data_type *vector, int idx1, int idx2);
void swap_permm(data_type *permutation, int idx1, int idx2);
void cholesky_decomposition(data_type *AtA, data_type *result_cholesky, int nrows, int ncols);
void solve(data_type *result_cholesky, data_type *Atb, data_type *solution , int npassive);

void transpose_multiply_mm_same_matrix(__global data_type const* A, data_type *result) {
    for (int i=0; i<NUM_TIME_SAMPLES; ++i) {
        for (int j=i; j<NUM_TIME_SAMPLES; ++j) {
            M_LINEAR_ACCESS(result, i, j) = 0;
            for (int k=0; k<NUM_TIME_SAMPLES; ++k)
                M_LINEAR_ACCESS(result, i, j) += M_LINEAR_ACCESS(A, i, k) * M_LINEAR_ACCESS(A, j, k);
            M_LINEAR_ACCESS(result, j, i) = M_LINEAR_ACCESS(result, i, j);
       }
    }
}

void transpose_multiply_mv(__global data_type const *M, __global data_type const *v, data_type *result) {
    for (int i=0; i<NUM_TIME_SAMPLES; ++i) {
        result[i] = 0;
        for (int k=0; k<NUM_TIME_SAMPLES; ++k) {
            result[i] += M_LINEAR_ACCESS(M, k, i);
        }
    }
}

void multiply_m_globalv(data_type const *M, data_type const *v, data_type *result) {}
void swap_m_row(data_type *matrix, int row1, int row2) {}
void swap_m_col(data_type *matrix, int col1, int col2) {}
void swap_v(data_type *vector, int idx1, int idx2) {}
void swap_permm(data_type *permutation, int idx1, int idx2) {}

void cholesky_decomposition(data_type *AtA, data_type *result_cholesky, int nrows, int ncols) {}
void solve(data_type *result_cholesky, data_type *Atb, data_type *solution , int npassive) {}

//
// fast nnls
//
/*
void fnnls(__global data_type const *A,
           __global data_type const *b,
           __global data_type const *x,
           float const epsilon,
           unsigned int const max_iterations);
*/

//
// fast nnls w/o copying (inplace updates)
//
void inplace_fnnls(__global data_type const *A,
                   __global data_type const *b,
                   __global data_type const * x,
                   float const epsilon,
                   unsigned int const max_iterations);

/*
void fnnls(__global data_type const *A,
           __global data_type const *b,
           __global data_type const *x,
           float const epsilon,
           unsigned int const max_iterations) {

    // initial setup
    int npassive = 0;
    data_type AtA[NUM_TIME_SAMPLES_SQ];
    data_type Atb[NUM_TIME_SAMPLES];
//    data_type s[NUM_TIME_SAMPLES];
    data_type w[NUM_TIME_SAMPLES];
    data_type final_s[NUM_TIME_SAMPLES];
    transpose_multiply_mm_same_matrix(A, AtA);
    transpose_multiply_mv(A, b, Atb);

    // loop over all iterations. 
    for (unsigned int iter = 0; iter < max_iterations; ++iter) {
        int nactive = NUM_TIME_SAMPLES - npassive;

        // exit condition
        if (!nactive)
            break;

        // update the gradient vector but only for the active constraints
        data_type AtAx[NUM_TIME_SAMPLES];
        multiply_m_globalv(AtA, final_s, AtAx);
        float max_w_value; int max_w_idx; 
        int iii = 0;
        for (int i=npassive; i<NUM_TIME_SAMPLES; ++i) {
            w [ i ] = Atb [ i ] - AtAx [ i ];

            if (iii == 0) {
                max_w_value = w [ i ];
                max_w_idx = i;
            } else if (w [ i ] > max_w_value) {
                max_w_value = w [ i ];
                max_w_idx = i;
            }

            ++iii;
        }

        // convergence check
        if (max_w_value < epsilon)
            break;
    }
}
*/

void inplace_fnnls(__global data_type const *A,
                   __global data_type const *b,
                   __global data_type const * x,
                   float const epsilon,
                   unsigned int const max_iterations) {
    // initial setup
    int npassive = 0;
    data_type AtA[NUM_TIME_SAMPLES_SQ];
    data_type Atb[NUM_TIME_SAMPLES];
    data_type s[NUM_TIME_SAMPLES];
    data_type w[NUM_TIME_SAMPLES];
    data_type final_s[NUM_TIME_SAMPLES];
    data_type permutation[2 * NUM_TIME_SAMPLES];
    transpose_multiply_mm_same_matrix(A, AtA);
    transpose_multiply_mv(A, b, Atb);

    // loop over all iterations. 
    for (int iter = 0; iter < max_iterations; ++iter) {
        int nactive = NUM_TIME_SAMPLES - npassive;

        // exit condition
        if (!nactive)
            break;

        // update the gradient vector but only for the active constraints
        data_type AtAx[NUM_TIME_SAMPLES];
        multiply_m_globalv(AtA, final_s, AtAx);
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
        swap_m_row(AtA, npassive, max_w_idx);
        swap_m_col(AtA, npassive, max_w_idx);
        swap_v(Atb, npassive, max_w_idx);
        swap_v(final_s, npassive, max_w_idx);
        swap_permm(permutation, npassive, max_w_idx);

        ++npassive;

        // inner loop
        while (npassive > 0) {
            // update the elements from the passive set
            //AtA.topLeftCorner(nPassive, nPassive).llt().solve(Atb.head(nPassive));
            data_type result_cholesky[NUM_TIME_SAMPLES];
            data_type solution[NUM_TIME_SAMPLES];
            cholesky_decomposition(AtA, result_cholesky, npassive, npassive);
            solve(result_cholesky, Atb, solution, npassive);
            data_type min_s_value = solution [ 0 ];
            for (int i=0; i<npassive; ++i) {
                s [ i ] = solution [ i ];

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
            swap_m_col(AtA, npassive, alpha_idx);
            swap_m_row(AtA, npassive, alpha_idx);
            swap_v(Atb, npassive, alpha_idx);
            swap_v(final_s, npassive, alpha_idx);
            swap_permm(permutation, npassive, alpha_idx);
        }
    }

    // permute the solution vector
}

//
// a wrapper around inplace_fnnls to arrange the data per work item
//
__kernel void inplace_fnlls_facade(__global data_type const *vA,
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
