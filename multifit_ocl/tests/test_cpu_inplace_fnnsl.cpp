#include <iostream>
#include <vector>
#include "../include/inplace_fnnls.h"
    
using data_type = float;
using my_matrix = matrix_t<data_type>;
using my_vector = vector_t<data_type>;

std::vector<my_matrix> generate_As(unsigned int n) {
    std::vector<my_matrix> result(n);
    for (int i=0; i<n; ++i)
        result[i] = my_matrix::Random();

    return result;
}

std::vector<my_vector> generate_bs(unsigned int n) {
    std::vector<my_vector> result(n);
    for (int i=0; i<n; i++) {
        result[i] = my_vector::Random();
    }

    return result;
}

int main() {
    std::cout << "hello world"  << std::endl;

    // generate random matrices
    int n = 1000;
    auto As = generate_As(n);
    auto bs = generate_bs(n);

    for (int i=0; i<n; ++i) {
        auto const& A = As[i];
        auto const& b = bs[i];
        my_vector x = my_vector::Zero();
        cpu_inplace_fnnls<data_type>(A, b, x);

        if (i%100 == 0)
            std::cout << "vector x = \n" << x << std::endl;
    }

    return 0;
}
