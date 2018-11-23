#pragma OPENCL EXTENSION cl_intel_channels : enable

#define SIZE 10
#define SIZE_2 100

typedef float data_type;
typedef data_type matrix[SIZE_2];
typedef data_type vector[SIZE];

__kernel 
void entry_point_input_reader(unsigned int size) {
    for (unsigned int ich=0; ich<size; ++ich) {
        __global data_type const* ptrA = As + ich*SIZE_2;
        matrix m; 
        vector v;

        for (unsigned int i=0; i<SIZE_2; i++) {
            m[i] = ptrA[i];
        }

        write_channel_intel(, m);

        /*
        for (unsigned int k=0; k<SIZE; ++k)
            for (unsigned int i=0; i<SIZE; i++)
                for (unsigned int j=i; j<SIZE; j++) {
                    write_channel_intel(, m[k*SIZE + i]);
                    write_channel_intel(, m[k*SIZE + j]);
                }
                */
    }
}

__kernel
void producer_AtA(__global data_type const* restrict As) {
    while (1) {

    }
}

__kernel
void entry_point_reader_b(__global data_type const* restrict bs, unsigned int size) {
    for (unsigned int ich=0; ich<size; ++ich) {
        __global data_type const* ptrb = bs + ich*SIZE_2;
        vector v;
        for (unsigned int i=0; i<SIZE; ++i) {
            v[i] = ptrb[i];
        }

        write_channel_intel(, v);
    }
}

__kernel
void transpose_multiply_mm() {
    while (true) {
        matrix m = read_channel_intel();
        for (unsigned int k=0; k<SIZE; ++k)
            for (unsigned int i=0; i<SIZE; i++)
                for (unsigned int j=i; j<SIZE; j++) {
                    m[i*SIZE+j] += m[k*SIZE + i] * m[k*SIZE + j];
                    m[j*SIZE+i] += m[k*SIZE + i] * m[k*SIZE + j];
            }
    }
}
