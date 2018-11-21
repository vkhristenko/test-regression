__kernel void producer(write_only pipe uint __attribute__((blocking)) c0) {
    for (uint i=0; i<10; ++i)
        write_pipe(c0, &i);
}

__kernel void consumer(__global uint* restrict dst,
                       read_only pipe uint __attribute__((blocking))
                       __attribute__((depth(10))) c0) {
    for (int i=0; i<5; ++i) {
        read_pipe(c0, &dst[i]);
    }
}
