#pragma OPENCL EXTENSION cl_intel_channels : enable

#define SIZE 10
#define SIZE_2 100
#define SIZE_HALFM 55
#define MATRIX_UNITS 2
#define PIPELINE_START_UNITS 2

typedef float data_type;
typedef data_type matrix[SIZE_2];
typedef data_type matrix_triang[SIZE_HALFM];
typedef data_type vector[SIZE];
struct fit_state_t {
    unsigned int ch;
    unsigned int iteration;
    unsigned int npassive;
    bool         active_set[SIZE];
    data_type    result_vector[SIZE];
};

channel struct fit_state_t ch_fnnls_start[PIPELINE_START_UNITS];
channel bool ch_ctl_to_fnnls_start[PIPELINE_START_UNITS];
channel bool ch_end_pipeline_to_control_manager;

/*
__kernel 
void entry_point(unsigned int size) {
    for (unsigned int ich=0; ich<size; ++ich) {
        // x & 0x1 == x % 2
        switch(ich & 0x1) {
            case 0: 
                write_channel_intel(ch_entry_point[0], ich);
                break;
            case 1: 
                write_channel_intel(ch_entry_point[1], ich);
                break;
        }
}
*/

__attribute__((num_compute_units(1)))
__attribute__((max_global_work_dim(0)))
__kernel
void producer_matrix_units_0(__global data_type* restrict As,
                           __global data_type* restrict bs,
                           unsigned int size) {
//    unsigned int cu = get_global_id(0);
    unsigned int cu = 0;
    for (unsigned int ich=cu; ich < size; ich+=MATRIX_UNITS) {
        // load from global memory into local variables
        matrix m; 
        vector v;
        unsigned int offset_m = SIZE_2 * ich;
        for (unsigned int i=0; i<SIZE_2; i++) 
            m[i] = As[offset_m + i];
        unsigned int offset_v = SIZE * ich;
        for (unsigned int j=0; j<SIZE; ++j)
            v[j] = bs[offset_v + j];

        matrix_triang out_m;
        for (unsigned int i=0; i<SIZE; i++) 
            for (unsigned int j=0; j<i+1; j++) {
                data_type temp = 0.0f;
                for (unsigned int k=0; k<SIZE; ++k) 
                    temp += m[k*SIZE + i] * m[k*SIZE + j];
                out_m[i*SIZE + j] = temp;
            }

        vector out_v;
        for (unsigned int i=0; i<SIZE; i++) {
            data_type temp = 0.0f;
            for (unsigned int k=0; k<SIZE; ++k) {
                temp += m[k*SIZE + i] * v[k];
            }
            out_v[i] = temp;
        }

        for (unsigned int i=0; i<SIZE_HALFM; i++) 
            As[i] = out_m[i];
        for (unsigned int i=0; i<SIZE; i++)
            bs[i] = out_v[i];

        // make sure commit to memory before sending the token
        mem_fence(CLK_GLOBAL_MEM_FENCE | CLK_CHANNEL_MEM_FENCE);

        // send the token down the pipeline
        struct fit_state_t token = { .ch = ich, .iteration = 0, .npassive = SIZE };
        switch (ich & 0x1) {
            case 0:
                write_channel_intel(ch_fnnls_start[0], token);
                break;
            case 1:
                write_channel_intel(ch_fnnls_start[1], token);
                break;
        }
    }
}

__attribute__((num_compute_units(1)))
__attribute__((max_global_work_dim(0)))
__kernel
void producer_matrix_units_1(__global data_type* restrict As,
                             __global data_type* restrict bs,
                             unsigned int size) {
//    unsigned int cu = get_global_id(0);
    unsigned int cu = 1;
    for (unsigned int ich=cu; ich < size; ich+=MATRIX_UNITS) {
        // load from global memory into local variables
        matrix m; 
        vector v;
        unsigned int offset_m = SIZE_2 * ich;
        for (unsigned int i=0; i<SIZE_2; i++) 
            m[i] = As[offset_m + i];
        unsigned int offset_v = SIZE * ich;
        for (unsigned int j=0; j<SIZE; ++j)
            v[j] = bs[offset_v + j];

        matrix_triang out_m;
        for (unsigned int i=0; i<SIZE; i++) 
            for (unsigned int j=0; j<i+1; j++) {
                data_type temp = 0.0f;
                for (unsigned int k=0; k<SIZE; ++k) 
                    temp += m[k*SIZE + i] * m[k*SIZE + j];
                out_m[i*SIZE + j] = temp;
            }

        vector out_v;
        for (unsigned int i=0; i<SIZE; i++) {
            data_type temp = 0.0f;
            for (unsigned int k=0; k<SIZE; ++k) {
                temp += m[k*SIZE + i] * v[k];
            }
            out_v[i] = temp;
        }

        for (unsigned int i=0; i<SIZE_HALFM; i++) 
            As[i] = out_m[i];
        for (unsigned int i=0; i<SIZE; i++)
            bs[i] = out_v[i];

        // make sure commit to memory before sending the token
        mem_fence(CLK_GLOBAL_MEM_FENCE | CLK_CHANNEL_MEM_FENCE);

        // send the token down the pipeline
        struct fit_state_t token = { .ch = ich, .iteration = 0, .npassive = SIZE };
        switch (ich & 0x1) {
            case 0:
                write_channel_intel(ch_fnnls_start[0], token);
                break;
            /*case 1:
                write_channel_intel(ch_fnnls_start[1], token);
                break;
                */
        }
    }
}

__attribute__((num_compute_units(1)))
//__attribute__((num_compute_units(PIPELINE_START_UNITS)))
//__attribute__((reqd_work_group_size(PIPELINE_START_UNITS, 1, 1)))
__attribute__((max_global_work_dim(0)))
__kernel
void fnnls_start(__global data_type* restrict vAtA,
                 __global data_type* restrict vAtb) {
//    unsigned int cu = get_global_id(0);
    unsigned int cu = 0;
    while (true) {
        struct fit_state_t token;
        bool request;
        switch (cu) {
            case 0:
            {
                bool was_ctl_request;
                bool ctl = read_channel_nb_intel(ch_ctl_to_fnnls_start[0], 
                    &was_ctl_request);
                if (was_ctl_request && ctl)
                    return;
                token = read_channel_nb_intel(ch_fnnls_start[0], &request);
                break;
            }
            /*
            case 1:
            {
                bool was_ctl_request;
                bool ctl = read_channel_nb_intel(ch_ctl_to_fnnls_start[1],
                    &was_ctl_request);
                if (was_ctl_request && ctl)
                    return;
                token = read_channel_nb_intel(ch_fnnls_start[1], &request);
                break;
            }*/
        }

        // if there was a request to process
        if (request) {
            data_type a = 3.0f;
            data_type b = 5.0f;
            data_type c = a + b;
        }
    }
}

__attribute__((autorun))
__attribute__((num_compute_units(1)))
__attribute__((max_global_work_dim(0)))
__kernel 
void end_pipeline() {
    write_channel_intel(ch_end_pipeline_to_control_manager, true);
}

__attribute__((autorun))
__attribute__((max_global_work_dim(0)))
__attribute__((num_compute_units(1)))
__kernel
void control_manager() {
    while (true) {
        // when processing of a single channel is finished, control manager
        // receives a simple bool token from the end of pipeline
        // to indicate that a processing of all channels has finished
        bool ctl = read_channel_intel(ch_end_pipeline_to_control_manager);

        // pipeline has stopped
        if (ctl) {
            // send out finished signals 
            bool success_fnnls_start_0 = false;
            do {
                success_fnnls_start_0 = write_channel_nb_intel(
                    ch_ctl_to_fnnls_start[0], true);
            } while(!success_fnnls_start_0);
            /*
            bool success_fnnls_start_1 = false; 
            do {
                success_fnnls_start_1 = write_channel_nb_intel(
                    ch_ctl_to_fnnls_start[1], true);
            } while (!success_fnnls_start_1);
            */
        }
    }
}
