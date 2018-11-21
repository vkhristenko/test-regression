 #pragma OPENCL EXTENSION cl_intel_channels : enable

channel int c0;

__kernel void producer() {
    for (int i=0; i<10; i++) 
        write_channel_intel(c0, i);
}

__kernel void consumer(__global uint * restrict dst) {
    for (int i=0; i<5; i++) 
        dst[i] = read_channel_intel(c0);
}

// feed forward design model
channel int ffdm_c0;
channel int ffdm_c1;

__kernel void ffdm_producer(__global uint const* src, uint const iterations) {
    for (int i=0; i<iterations; i++) {
        write_channel_intel(ffdm_c0, src[2*i]);
        write_channel_intel(ffdm_c1, src[2*i+1]);
    }
}

__kernel void ffdm_consumer(__global uint* dst, uint const iterations) {
    for (int i=0; i<iterations; ++i) {
        dst[2*i] = read_channel_intel(ffdm_c0);
        dst[2*i+1] = read_channel_intel(ffdm_c1);
    }
}

// with buffer management
__kernel void bm_producer(__global uint const* restrictd src,
                          __global volatile uint* restrict shared_mem,
                          uint const iterations) {
    int base_offset;

    for (uint gid=0; gid<iterations)
}
