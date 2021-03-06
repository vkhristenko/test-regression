#pragma OPENCL EXTENSION cl_intel_channels : enable

#define SIZE 10
#define SIZE_2 100
#define SIZE_HALFM 55
#define NUM_WORKERS 2
//#define MATRIX_UNITS 2
//#define PIPELINE_START_UNITS 2

typedef float data_type;
typedef data_type matrix[SIZE_2];
typedef data_type matrix_triang[SIZE_HALFM];
typedef data_type vector[SIZE];

struct control_data_t {
    unsigned int ich;
};

struct input_data_t {
    matrix_triang AtA;
    vector        Atb;
};

struct output_data_t {
    vector        x;
};

channel struct control_data_t ch_control_data_d2w[NUM_WORKERS];
channel struct control_data_t ch_control_data_w2c[NUM_WORKERS];
channel struct input_data_t   ch_data_d2w[NUM_WORKERS];
channel struct output_data_t  ch_data_w2c[NUM_WORKERS];

__attribute__((max_global_work_dim(0)))
__kernel
void dispatcher_matrix_units(__global data_type* restrict As,
                             __global data_type* restrict bs,
                             unsigned int size) {
    for (unsigned int ich=0; ich < size; ich+=1) {
        // load from global memory into local variables
        matrix m; 
        vector v;
        unsigned int offset_m = SIZE_2 * ich;
#pragma unroll 1
        for (unsigned int i=0; i<SIZE_2; i++) 
            m[i] = As[offset_m + i];
        unsigned int offset_v = SIZE * ich;
#pragma unroll 1
        for (unsigned int j=0; j<SIZE; ++j)
            v[j] = bs[offset_v + j];

        struct input_data_t data;
#pragma unroll 1
        for (unsigned int i=0; i<SIZE; i++) 
#pragma unroll 1
            for (unsigned int j=0; j<i+1; j++) {
                data_type temp = 0.0f;
#pragma unroll 1
                for (unsigned int k=0; k<SIZE; ++k) 
                    temp += m[k*SIZE + i] * m[k*SIZE + j];
                data.AtA[i*SIZE + j] = temp;
            }

#pragma unroll 1
        for (unsigned int i=0; i<SIZE; i++) {
            data_type temp = 0.0f;
#pragma unroll 1
            for (unsigned int k=0; k<SIZE; ++k) {
                temp += m[k*SIZE + i] * v[k];
            }
            data.Atb[i] = temp;
        }

        // control data
        struct control_data_t ctl_data = { .ich = ich };

        // send it to the worker
        // TODO: implement non-blocking check
        switch (ich & 0x1) {
            case 0:
                write_channel_intel(ch_control_data_d2w[0], ctl_data);
                write_channel_intel(ch_data_d2w[0], data);
            case 1:
                write_channel_intel(ch_control_data_d2w[1], ctl_data);
                write_channel_intel(ch_data_d2w[1], data);
        }
    }
}

inline void multiply_m_v_v(data_type const *restrict M,
                           data_type const *restrict v,
                           data_type *restrict result);
inline void multiply_m_v_v(data_type const *restrict M,
                           data_type const *restrict v,
                           data_type *restrict result) {
#pragma loop_coalesce 2
    for (int i=0; i<SIZE; ++i) {
        result[i] = 0;
#pragma unroll 1
        for (int k=0; k<=i; ++k)
            result[i] += M_LINEAR_ACCESS(M, i, k) * v[k];
    }
}

inline void permutation_identity(int *permutation);
inline void permutation_identity(int *permutation) {
#pragma unroll 1
    for (int i=0; i<SIZE; ++i)
        permutation[i] = i;
}

//
// Swap Functions
//
inline void swap_permm(data_type *permutation, int idx1, int idx2);
inline void swap_row_column(data_type *pM,
                     int i, int j, int full_size, int view_size);
inline void swap_element(data_type *pv, int i, int j);
inline void swap_perm_element(int *pv, int i, int j);

inline void swap_element(data_type *pv,
                  int i, int j) {
    data_type tmp = pv[i];
    pv[i] = pv[j];
    pv[j] = tmp;
}

inline void swap_perm_element(int *pv,
                       int i, int j) {
    int tmp = pv[i];
    pv[i] = pv[j];
    pv[j] = tmp;
}

// same precondition: index_j > index_i
#define SWAP_LOOP(start, finish, matrix, index_i, index_j) \
    for (int elem=start; elem<finish; ++elem) { \
        data_type tmp = M_LINEAR_ACCESS(matrix, index_i, elem); \
        M_LINEAR_ACCESS(matrix, index_i, elem) = \
            M_LINEAR_ACCESS(matrix, index_j, elem); \
        M_LINEAR_ACCESS(matrix, index_j, elem) = tmp; \
        M_LINEAR_ACCESS(matrix, elem, index_i) = \
            M_LINEAR_ACCESS(matrix, elem, index_j); \
        M_LINEAR_ACCESS(matrix, elem, index_j) = tmp; \
    }

// precondition: j > i
inline void swap_row_column(data_type *pM,
                     int i, int j, int full_size, int view_size) {
    // diagnoal
    data_type tmptmp = M_LINEAR_ACCESS(pM, i, i);
    M_LINEAR_ACCESS(pM, i, i) = M_LINEAR_ACCESS(pM, j, j);
    M_LINEAR_ACCESS(pM, j, j) = tmptmp;

#pragma ivdep
    for (int elem=0; elem<NUM_TIME_SAMPLES; ++elem) {
        if (elem==i || elem==j)
            continue;

        data_type tmp = M_LINEAR_ACCESS(pM, i, elem);
        M_LINEAR_ACCESS(pM, i, elem) =
            M_LINEAR_ACCESS(pM, j, elem);
        M_LINEAR_ACCESS(pM, j, elem) = tmp;
        M_LINEAR_ACCESS(pM, elem, i) =
            M_LINEAR_ACCESS(pM, elem, j);
        M_LINEAR_ACCESS(pM, elem, j) = tmp;
    }
}

//
// Cholesky Decomposition + Forward/Backward Substituion Solvers
//
inline void cholesky_decomp(data_type const* restrict pM,
                            data_type * restrict pL,
                     int full_size, int view_size);
inline void fused_cholesky_forward_substitution_solver_rcadd(
        data_type const * restrict pM,
        data_type *restrict pL,
        data_type const * restrict pb,
        data_type *restrict py,
        int full_size, int view_size);
inline void fused_cholesky_forward_substitution_solver_inbetween_removal(
        data_type const * restrict pM,
        data_type *restrict pL,
        data_type const * restrict pb,
        data_type *restrict py,
        int position, int full_size, int view_size);

inline void cholesky_decomp(data_type const* restrict pM,
                            data_type *restrict pL,
                     int full_size, int view_size) {
    for (int i=0; i<view_size; ++i) {

        // first compute elements to the left of the diagoanl
        data_type sumsq = 0.0f;
        for (int j=0; j<i; ++j) {

            data_type sumsq2 = 0.0f;
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
inline void fused_cholesky_forward_substitution_solver_rcadd(
        data_type const *pM,
        data_type *restrict pL,
        data_type const *pb,
        data_type *restrict py,
        int full_size, int view_size) {
    /*
     * cholesky decomposition using partial computation
     * only compute values in the row that was just added
     */
    data_type sum = 0.0f;
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
//    __local data_type y_last = total / diag_value;
    py[row] = total / diag_value;
}

inline void fused_cholesky_forward_substitution_solver_inbetween_removal(
        data_type const *pM,
        data_type *restrict pL,
        data_type const *pb,
        data_type *restrict py,
        int position, int full_size, int view_size) {
    // only for elements with >= position
    for (int i=position; i<view_size; ++i) {

        // first compute elements to the left of the diagoanl
        data_type sumsq = 0.0f;
        data_type total = pb[i];
        for (int j=0; j<i; ++j) {

            data_type sumsq2 = 0.0f;
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

inline void solve_forward_substitution(data_type const *pM,
                                data_type const* pb,
                                data_type *restrict psolution,
                                int full_size, int view_size);
inline void solve_forward_substitution(data_type const *pM,
                                       data_type const* pb,
                                       data_type *restrict psolution,
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
inline void solve_backward_substitution(data_type const * restrict pM,
                                        data_type const * restrict pb,
                                        data_type *restrict psolution,
                                 int full_size, int view_size);
inline void solve_backward_substitution(data_type const * restrict pM,
                                        data_type const * restrict pb,
                                        data_type *restrict psolution,
                                 int full_size, int view_size) {
    // very last element is trivial
    psolution[view_size-1] = pb[view_size-1] /
        M_LINEAR_ACCESS(pM, view_size-1, view_size-1);

    // for the rest
    for (int i=view_size-2; i>=0; --i) {
//        data_type total = pb[i];
        data_type total = 0.0f;
        for (int j=i+1; j<view_size; ++j) {
            total += M_LINEAR_ACCESS(pM, j, i) * psolution[j];
        }

        psolution[i] = (pb[i] - total) / M_LINEAR_ACCESS(pM, i, i);
    }
}


__attribute__((num_compute_units(NUM_WORKERS)))
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel
void fnnls_worker() {
    while (true) {
        int cu = get_compute_id(0);

        // read the data
        struct control_data_t ctl_data = read_channel_intel(ch_control_data_d2w[cu]);
        struct input_data_t   data = read_channel_intel(ch_data_d2w[cu]);

        //
        // run nnls
        //
        // initial setup
        int npassive = 0;
        permutation_identity(permutation);
        data_type s[SIZE];
        data_type w[SIZE];
        data_type final_s[SIZE];
        int permutation[SIZE];
        matrix_triang pL;
        data_type py[SIZE];

#pragma unroll 1
        for (int i=0; i<NUM_TIME_SAMPLES; ++i)
            final_s[i] = 0;

#ifdef NNLS_DEBUG
        printf("permutaion = \n");
        print_permutation(permutation, NUM_TIME_SAMPLES);
        printf("AtA = \n");
        print_matrix(AtA, NUM_TIME_SAMPLES);
        printf("Atb = \n");
        print_vector(Atb, NUM_TIME_SAMPLES);
#endif

        // loop over all iterations. 
#pragma unroll 1
        for (unsigned int iter = 0; iter < max_iterations; ++iter) {
            int nactive = NUM_TIME_SAMPLES - npassive;
#ifdef NNLS_DEBUG
            printf("*************\n");
            printf("iteration = %d\n", iter);
            printf("nactive = %d\n", nactive);
                printf("final_s = \n");
                print_vector(final_s, NUM_TIME_SAMPLES);
#endif

            // exit condition
            if (!nactive)
                break;

            // update the gradient vector but only for the active constraints
            data_type AtAx[NUM_TIME_SAMPLES];
            multiply_m_v_v(AtA, final_s, AtAx);
#ifdef NNLS_DEBUG
                printf("AtAx = \n");
                print_vector(AtAx, NUM_TIME_SAMPLES);
#endif
            data_type max_w_value = FLT_MIN; int max_w_idx;
            int iii = 0;
#pragma unroll 1
            for (int i=npassive; i<NUM_TIME_SAMPLES; ++i) {
                w [ i ] = Atb [ i ] - AtAx [ i ];

                if (iii == 0 || w [ i ] > max_w_value) {
                    max_w_value = w [ i ];
                    max_w_idx = i;
                }
                ++iii;
            }

#ifdef NNLS_DEBUG
            printf("w = \n");
            print_vector(w, NUM_TIME_SAMPLES);
            printf("max_w_value = %f\n", max_w_value);
            printf("max_w_idx = %d\n", max_w_idx);
#endif

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

#ifdef NNLS_DEBUG
                printf("after swap AtA = \n");
                print_matrix(AtA, NUM_TIME_SAMPLES);
                printf("after swap Atb = \n");
                print_vector(Atb, NUM_TIME_SAMPLES);
                printf("after swap final_s = \n");
                print_vector(final_s, NUM_TIME_SAMPLES);
                printf("after swap permutation = \n");
                print_permutation(permutation, NUM_TIME_SAMPLES);
#endif

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
                    s[0] = y_0_0 / l_0_0;
                    position_removed = -1;
#ifdef NNLS_DEBUG
                        printf("npassive == 1 branch\n");
#endif
                } else {
                    if (inner_iteration == 0) {
                    fused_cholesky_forward_substitution_solver_rcadd(
                        AtA, pL, Atb, py, NUM_TIME_SAMPLES, npassive);
                    //solve_backward_substitution(pL, py, s, NUM_TIME_SAMPLES, npassive);
#ifdef NNLS_DEBUG
                        printf("npassive != 1 else inner_iteration == 0 branch\n");
#endif
                    } else {
                    fused_cholesky_forward_substitution_solver_inbetween_removal(
                        AtA, pL, Atb, py, position_removed, NUM_TIME_SAMPLES, npassive);
                    //solve_backward_substitution(pL, py, s, NUM_TIME_SAMPLES, npassive);
#ifdef NNLS_DEBUG
                        printf("npassive != 1 else inner_iteration!=0 else branch\n");
#endif
                    }
                    solve_backward_substitution(pL, py, s, NUM_TIME_SAMPLES, npassive);
                }

#ifdef NNLS_DEBUG
                    printf("***** inner iteration %d *****\n", inner_iteration);
                    printf("L = \n");
                    print_matrix(pL, NUM_TIME_SAMPLES);
                    printf("s = \n");
                    print_vector(s, NUM_TIME_SAMPLES);
                    printf("py = \n");
                    print_vector(py, NUM_TIME_SAMPLES);
#endif

                // update the elements from the passive set
                data_type min_s_value = s [ 0 ];
#pragma unroll 1
                for (int i=1; i<npassive; ++i) {
                    if (s [ i ] < min_s_value)
                        min_s_value = s [ i ];
                }

#ifdef NNLS_DEBUG
                    printf("min_s_value = %f\n", min_s_value);
                    printf("npassive = %d\n", npassive);
#endif

                // if elements of the passive set are all positive
                // set the solution vector and break from the inner loop
                if (min_s_value > 0.0f) {
#ifdef NNLS_DEBUG
                    printf("min_s_value = %f and branching here\n", min_s_value);
#endif
#pragma unroll 1
                    for (int i=0; i<npassive; ++i)
                        final_s [ i ] = s [ i ];
                    break;
                }

#ifdef NNLS_DEBUG
                if (iter%100 == 0) {
                    printf("final_s = \n");
                    print_vector(final_s, NUM_TIME_SAMPLES);
                }
#endif

                // 
                data_type alpha = FLT_MAX;
                int alpha_idx = 0;
#pragma unroll 1
                for (int i=0; i<npassive; ++i) {
                    if (s [ i ] <= 0.0f) {
                        data_type const ratio = final_s [ i ] /
                            ( final_s [ i ] - s [ i ] );
                        if (ratio < alpha) {
                            alpha = ratio;
                            alpha_idx = i;
                        }
                    }
                }

                if (alpha == FLT_MAX) {
#pragma unroll 1
                    for (int i=0; i<npassive; ++i)
                        final_s [ i ] = s [ i ];
                    break;
                }

                // update solution using alpha
#pragma unroll 1
                for (int i=0; i<npassive; ++i) {
                    final_s [ i ] += alpha * (s [ i ] - final_s [ i ]);
                }
                final_s [ alpha_idx] = 0;
                --npassive;

                // run swaps
                swap_row_column(AtA, alpha_idx, npassive,
                    NUM_TIME_SAMPLES, NUM_TIME_SAMPLES);
                swap_element(Atb, npassive, alpha_idx);
                swap_element(final_s, npassive, alpha_idx);
                swap_perm_element(permutation, npassive, alpha_idx);
                inner_iteration++;
                position_removed = alpha_idx;

#ifdef NNLS_DEBUG
                printf("final_s = \n");
                print_vector(final_s, NUM_TIME_SAMPLES);
#endif
            }
        }

#ifdef NNLS_DEBUG
        printf("final_s = \n");
        print_vector(final_s, NUM_TIME_SAMPLES);
        printf("permutation = \n");
        print_permutation(permutation, NUM_TIME_SAMPLES);
#endif

        // permute the solution vector back to have x[i] sit at the original position
        struct output_data_t result;
#pragma unroll 1
        for (int i=0; i<SIZE; ++i) {
            result.x [ permutation[i] ] = final_s [i];
        }
            
        // send to collector
        write_channel_intel(ch_data_w2c[cu], result);
        write_channel_intel(ch_control_data_w2c[cu], ctl_data);
    }
}

#define CHECK_CHANNEL(cu)\
    {\
        bool was_set_ctl;\
        bool was_set_data;\
        struct control_data_t ctl_data = read_channel_nb_intel(\
            ch_control_data_w2c[cu], &was_set_ctl);\
        struct output_data_t data = read_channel_nb_intel(\
            ch_data_w2c[cu], &was_set_data);\
        \
        if (was_set_ctl && was_set_data) {\
            unsigned int offset = SIZE * ctl_data.ich;\
            for (unsigned int i=0; i<SIZE; ++i)\
                xs[offset + i] = data.x[i];\
            num_channels_completed++;\
        }\
    }

__attribute__((max_global_work_dim(0)))
__kernel
void collector(__global data_type* xs, 
               unsigned int size) {
    unsigned int num_channels_completed = 0;

    while (true) {
        CHECK_CHANNEL(0)
        CHECK_CHANNEL(1)

        if (num_channels_completed == size)
            break;
    }
}
