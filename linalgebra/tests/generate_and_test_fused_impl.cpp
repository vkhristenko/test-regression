#include <iostream>

#include "linalgebra/interface/cholesky.hpp"
#include "linalgebra/interface/substitution.hpp"
#include "Eigen/Dense"

template<typename T>
void print_matrix(T *pM, int n) {
    for (int i=0; i<n; i++) {
        for (int j=0; j<n; j++) {
            std::cout << pM[i*n + j] << "   ";
        }
        std::cout << "\n";
    }
}

template<typename T>
void print_vector(T *pv, int n) {
    for (int i=0; i<n; ++i)
        std::cout << pv[i] << "   ";
    std::cout << std::endl;
}

template<typename T, typename Vector>
void print_vectors_side_by_side(T *pv, Vector &evec, int size) {
    for (int i=0; i<size; ++i)
        std::cout << pv[i] << "  " << evec(i) << std::endl;

}

int main() {
    using namespace Eigen;

    constexpr int size = 10;

    // test with Eigen. Cholesky and solving
    MatrixXf A = MatrixXf::Random(10, 10);
    MatrixXf AtA = A.transpose() * A;
    VectorXf b = VectorXf::Random(10);
    std::cout << "A matrix is\n" << A << std::endl;
    std::cout << "b vector is\n" << b << std::endl;
    std::cout << "AtA matrix is\n" << AtA << std::endl;

    VectorXf solution = AtA.llt().solve(b);
    LLT<MatrixXf> lltOfA(AtA);
    MatrixXf L = lltOfA.matrixL();
    std::cout << "L matrix using Eigen is " << L << std::endl;
    std::cout << "eigen solution is\n" << solution << std::endl;

    // lin algebra impl
    using data_type = float;
    data_type pM[size * size];
    data_type pL[size * size];
    data_type pb[size], psolution[size];
    for (int i=0; i<size; i++) {
        pb[i] = b(i);
        for (int j=0; j<size; j++)
            pM[i * size + j] = AtA(i, j);
    }

    cholesky_decomp(pM, pL, size, size-1);
    data_type ptmp[size];
    print_matrix(pL, size);
    /*
    solve_forward_substitution(pL, pb, ptmp, size);
    solve_backward_substitution(pL, ptmp, psolution, size);
    print_vector(psolution, size);
    print_vectors_side_by_side(psolution, solution, size);
    */

    return 0;
}
