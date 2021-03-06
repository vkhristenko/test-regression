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

/*

// with buffer management
channel int bm_c;
channel uint req;
__kernel void bm_producer(__global uint const* restrict src,
                          __global volatile uint* restrict shared_mem,
                          uint const iterations) {
    int base_offset;

    for (uint gid=0; gid<iterations; gid++) {
        // assume each block of memory is 256 words
        uint lid = 0x0ff & gid;

        if (lid == 0) {
            base_offset = read_channel_intel(req);
        }

        shared_mem[base_offset + lid] = src[gid];

        // make sure all memory operations are committed before sending 
        // token to the consumer
        mem_fence(CLK_GLOBAL_MEM_FENCE | CLK_CHANNEL_MEM_FENCE);

        if (lid == 255) {
            write_channel_intel(bm_c, base_offset);
        }
    }
}

// use depth attribute
channel int d_c __attribute__((depth(10)));
#define N 10

__kernel void d_producer(__global int* in_data) {
    for (int i=0; i<N; i++) {
        if (in_data[i])
            write_channel_intel(d_c, in_data[i]);
    }
}

__kernel void d_consumer(__global int* restrict check_data,
                         __global int* restrict out_data) {
    int last_val = 0;

    for (int i=0; i<N; ++i) {
        if (check_data[i])
            last_val = read_channel_intel(d_c);

        out_data[i] = last_val;
    }
}
*/

// order channel read/write operations
channel uint o_c0 __attribute__((depth(0)));
channel uint o_c1 __attribute__((depth(0)));

__kernel void o_producer(__global uint const* src, 
                       uint const iterations) {
    for (int i=0; i<iterations; ++i) {
        write_channel_intel(o_c0, src[2*i]);
        mem_fence(CLK_CHANNEL_MEM_FENCE);
        write_channel_intel(o_c1, src[2*i + 1]);
    }
}

__kernel void o_consumer(__global uint* dst,
                         uint const iterations) {
    for (int i=0; i<iterations; ++i) {
        dst[2 * i + 1] = read_channel_intel(o_c0);
        mem_fence(CLK_CHANNEL_MEM_FENCE);
        dst[2*i] = read_channel_intel(o_c1);
    }
}
