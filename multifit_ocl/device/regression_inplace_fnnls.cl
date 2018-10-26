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
#defien NUM_TIME_SAMPLES_SQ 100 
#define SIZE NUM_TIME_SAMPLES
#define SIZE_SQ NUM_TIME_SAMPLES_SQ

//
// actual fast nnls
//
void inplace_fnnls(float const *A
                   float const *b,
                   float const * x,
                   float const epsilon,
                   unsigned int const max_iterations) {
    // 
    int npassive = 0;
}

//
// a wrapper around inplace_fnnls to arrange the data per work item
//
__kernel void inplace_fnlls_facade(__global float const *vA,
                                   __global float const *vb,
                                   __global float const *vx,
                                   float const epsilon,
                                   unsigned int const max_iterations) {
    // get the global index - identifies the detector channel 
    int idx = get_global_id(0);
        
    // get the pointer to the right location for the idx
    float const *ptrA = vA + idx * SIZE_SQ;
    float const *ptrb = vb + idx * SIZE;
    float const *ptrx = vx + idx * SIZE;

    // launch the fnnls itself for the right worker item
    inplace_fnnls(ptrA, ptrb, ptrx, epsilon, max_iterations);
}
