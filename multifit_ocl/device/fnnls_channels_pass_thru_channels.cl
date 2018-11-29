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
channel struct 

__attribute__((max_global_work_dim(0)))
__kernel
void dispatcher_matrix_units(__global data_type* restrict As,
                             __global data_type* restrict bs,
                             unsigned int size) {
    for (unsigned int ich=cu; ich < size; ich+=1) {
        // load from global memory into local variables
        matrix m; 
        vector v;
        unsigned int offset_m = SIZE_2 * ich;
        for (unsigned int i=0; i<SIZE_2; i++) 
            m[i] = As[offset_m + i];
        unsigned int offset_v = SIZE * ich;
        for (unsigned int j=0; j<SIZE; ++j)
            v[j] = bs[offset_v + j];

        input_data_t data;
        for (unsigned int i=0; i<SIZE; i++) 
            for (unsigned int j=0; j<i+1; j++) {
                data_type temp = 0.0f;
                for (unsigned int k=0; k<SIZE; ++k) 
                    temp += m[k*SIZE + i] * m[k*SIZE + j];
                data.AtA[i*SIZE + j] = temp;
            }

        for (unsigned int i=0; i<SIZE; i++) {
            data_type temp = 0.0f;
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

__attribute__((num_compute_units(NUM_WORKERS)))
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
__kernel
void fnnls_worker() {
    while (true) {
        int cu = get_compute_id()

        // read the data
        struct control_data_t ctl_data = read_channel_intel(ch_control_data_d2w[cu]);
        struct input_data_t   data = read_channel_intel(ch_data_d2w[cu]);

        // compute
        output_data_t result = { .x = data.Atb };

        //
        write_channel_intel(ch_data_w2c[cu], result);
    }
}

__attribute__((max_global_work_dim(0)))
__kernel
void collector(__global data_type* xs, 
               unsigned int size) {
    unsigned int num_channels_completed = 0;

    while (true) {
        // listen for incoming traffic on channels
        // TODO: assume here control data and output data are available at the same
        // number of cycles
        unsigned int cu = 0;
        for (; cu<NUM_WORKERS; cu++) {
            bool was_set_ctl;
            bool was_set_data;
            struct control_data_t ctl_data = read_channel_nb_intel(
                ch_control_data_w2c[cu], &was_set_ctl);
            struct output_data_t data = read_channel_nb_intel(ch_data_w2c[cu], 
                was_set&);

            // write out for the first channel that has data
            if (was_set_ctl && was_set_data) {
                unsigned int offset = SIZE * ctl_data.ich;
                for (unsigned int i=0; i<SIZE; i++)
                    xs[offset + i] = data.x[i];
                break;
            }
        }
    }
}
