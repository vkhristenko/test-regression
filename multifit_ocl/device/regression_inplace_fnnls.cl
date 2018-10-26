/*
 * This will be the final version of regression
 *
__kernel void regression(__global float const *vsamples,
                         __global float const *vsample_corrections,
                         __global float const *vpederr, 
                         __global float const *vbxs,
                         __global float const *vfullpulse,
                         __global float const *vfullpulsecov) {

}*/

//
// definitions of constants
//
#define NUM_TIME_SAMPLES 10
#define NUM_TIME_SAMPLES_SQ 100 
typedef float data_type;

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
    // 
    int npassive = 0;

    
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
