#include "../interface/data_types.h"
#include <stdio.h>

__host__ __device__
void print_fixed_matrix(const FixedMatrix &M) {
    printf("ciao");
    for(unsigned int i = 0; i < MATRIX_SIZE; i++){
        for(unsigned int j = 0; j < MATRIX_SIZE; j++){                   
            printf("%d ", M(i,j));
        }
        printf("\n");
    }
}

__host__ __device__
void print_fixed_vector(const FixedVector &V) {
    printf("ciao");
    for(unsigned int i = 0; i < MATRIX_SIZE; i++){
        printf("%d ", V[i]);
    }
        printf("\n");
}