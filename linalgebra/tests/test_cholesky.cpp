#include <iostream>

#include "linalgebra/interface/cholesky.hpp"
#include "Eigen/Dense"

void print_matrix(data_type *pM, int n) {
    for (int i=0; i<n; i++) {
        for (int j=0; j<n; j++) {
            std::cout << pM[i*n + j] << "   ";
        }
        std::cout << "\n";
    }
}

int main() {
    constexpr int n = 3;
    data_type pM[n * n];
    data_type pL[n * n];
    for (int i=0; i<n*n; i++)
        pL[i] = 0;

    pM[0] = 4; pM[1] = -1; pM[2] = 2;
    pM[3] = -1; pM[4] = 6; pM[5] = 0;
    pM[6] = 2; pM[7] = 0; pM[8] = 5;

    // eiegn 
    Eigen::MatrixXd A(n, n);
    A << 4, -1, 2, -1, 6, 0, 2, 0, 5;
    std::cout << "The matrix A is " << std::endl << A << std::endl;

    using namespace Eigen;
    LLT<MatrixXd> lltOfA(A);
    MatrixXd L = lltOfA.matrixL();

    using namespace std;
    cout << "The Cholesky factor L is" << endl << L << endl;
    cout << "To check this, let us compute L * L.transpose()" << endl;
    cout << L * L.transpose() << endl;
    cout << "This should equal the matrix A" << endl;

    std::cout << "************* cholesky impl stuff ***************" << std::endl;
    print_matrix(pM, n);
    cholesky_decomp(pM, pL, n);
    std::cout << "*** matrix L ***" << std::endl;
    print_matrix(pL, n);

    return 0;
}
