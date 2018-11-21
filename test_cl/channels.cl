channel int c0;

__kernel void producer() {
    for (int i=0; i<10; i++) 
        write_channel_intel(c0, i);
}

__kernel void consumer(__global uint * restrict dst) {
    dst[i] = read_channel_intel(c0);
}
