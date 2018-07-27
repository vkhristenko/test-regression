
#include <Eigen/Dense>


const unsigned long MATRIX_SIZE = 10;
const unsigned long VECTOR_SIZE = 10;

typedef Eigen::Matrix<double, MATRIX_SIZE, MATRIX_SIZE> FixedMatrix;
typedef Eigen::Matrix<double, VECTOR_SIZE, 1> FixedVector;

FixedVector nnls(const FixedMatrix &A, const FixedVector &b, const double eps=1e-11, const unsigned int max_iterations=10);

template <typename T, typename T2, typename T3>
inline T3 sub_matrix(const T2& full, const T& ind){
    int num_indices = ind.size();
    T3 target = T3::Zero();
    
    for (auto index: ind){
        target.col(index) = full.col(index);
    }
    return target;
}

