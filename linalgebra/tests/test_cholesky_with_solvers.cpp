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

int main() {
    using data_type = float;
    using namespace Eigen;
    using namespace std;

    constexpr int n = 3;
    data_type pM[n * n];
    data_type pL[n * n];
    data_type pb[n], psolution[n];
    pb[0] = 3; pb[1] = 3; pb[2] = 4;
    for (int i=0; i<n*n; i++)
        pL[i] = 0;

    pM[0] = 4; pM[1] = -1; pM[2] = 2;
    pM[3] = -1; pM[4] = 6; pM[5] = 0;
    pM[6] = 2; pM[7] = 0; pM[8] = 5;

    Matrix3f A;
    Vector3f b;
    A << 4,1,2,  -1,6,0,  2,0,5;
    b << 3, 3, 4;
    cout << "Here is the matrix A:\n" << A << endl;
    cout << "Here is the vector b:\n" << b << endl;
    Vector3f x1 = A.colPivHouseholderQr().solve(b);
    Vector3f x2 = A.llt().solve(b);
    cout << "The solution with colPivHouseHolder is:\n" << x1 << endl;
    cout << "The solution with cholesky is: \n" << x2 << endl;
    LLT<Matrix3f> lltOfA(A);
    Matrix3f L = lltOfA.matrixL();
    cout << "The Cholesky factor L is" << endl << L << endl;
    cout << "To check this, let us compute L * L.transpose()" << endl;
    cout << L * L.transpose() << endl;
    cout << "This should equal the matrix A" << endl;

    std::cout << "************* cholesky impl stuff ***************" << std::endl;
    print_matrix(pM, n);
    cholesky_decomp(pM, pL, n, n);
    std::cout << "*** matrix L ***" << std::endl;
    print_matrix(pL, n);

    std::cout << "try to solve with cholesky" << std::endl;
    data_type ptmp[n];
    solve_forward_substitution(pL, pb, ptmp, n);
    print_vector(ptmp, n);
    solve_backward_substitution(pL, ptmp, psolution, n);
    print_vector(psolution, n);

    return 0;
}
