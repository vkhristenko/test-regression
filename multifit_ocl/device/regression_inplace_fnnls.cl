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

//
// actual fast nnls
//
void inplace_fnnls(__global data_type const *A,
                   __global data_type const *b,
                   __global data_type const * x,
                   float const epsilon,
                   unsigned int const max_iterations);
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
    transpose_multiply_mm_same_matrix(A, AtA);
    transpose_multiply_mv(A, b, Atb);

    // loop over all iterations. 
    for (int iter = 0; iter < max_iterations; ++iter) {
        int nactive = NUM_TIME_SAMPLES - npassive;

        // exit condition
        if (!nactive)
            break;

        // update the gradient vector but only the 
    }
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
