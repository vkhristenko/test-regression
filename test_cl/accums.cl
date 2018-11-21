channel float4 RANDOM_STREAM;

__kernel void acc_test(__global float* a, int k) {
    // simplest example of an accumulator
    // in this loop, accumulator acc is incremented by 5
    int i;
    float acc = 0.0f;
    for (i=0; i<k; i++) {
        acc+=5;
    }

    a[0] = acc;
}

__kernel void acc_test2(__global float* a, int k) {
    // extended example showing that an accumulator can be 
    // conditioanlly incremented. The key here is to describe the increment
    // as conditional, not the acc itself
    int i;
    float acc = 0.0f;
    for (i=0; i<k; ++i) 
        acc += ((i<30) ? 5 : 0);

    a[0] = acc;
}

__kernel void acc_test3(__global float* a, int k) {
    // a more complex case where the acc is fed by a dot product
    int i;
    float acc = 0.0f;
    for (int i=0; i<k; ++i) {
        float4 v = read_channel_intel(RANDOM_STREAM);
        float x1 = v.x;
        float x2 = v.y;
        float y1 = v.z;
        float y2 = v.w;

        acc += (x1*y1 + x2*y2);
    }

    a[0] = acc;
}

__kernel void loader(__global float* a, int k) {
    int i;
    float4 my_val = 0;
    for (i=0; i<k; ++i) {
        if ((i%4) == 0)
            write_channel_intel(RANDOM_STREAM, my_val);
        if ((i%4) == 0) my_val.x = a[i];
        if ((i%4) == 1) my_val.y = a[i];
        if ((i%4) == 2) my_val.z = a[i];
        if ((i%4) == 3) my_val.w = a[i];
    }
}
