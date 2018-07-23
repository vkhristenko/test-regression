#include <iostream>
#include <set>

#include "Eigen/Core"
#include "Eigen/Dense"

constexpr int M = 10;
constexpr int L = 10;

void nnls() {
    // 
    // type aliasing
    //
    using ValueType = double;
    using VectorM = Eigen::Matrix<ValueType, M, 1>;
    using MatrixLM = Eigen::Matrix<ValueType, L, M>;
    using VectorL = Eigen::Matrix<ValueType, L, 1>;

    //
    // randomize inputs
    //
    VectorL x = VectorL::Random(L, 1) * 100;
    MatrixLM Z = MatrixLM::Random(L, M) * 100;

    //
    // aux definitions
    //
    double tolerance = 0.0000000001;
    
    // 
    // find the max coefficient from vector w for indices coming from set R
    //
    auto max_of_set = [](auto const& R, auto const& w) -> std::pair<int, ValueType> {
        ValueType mmax = w[0, 0];
        int idx = 0;
        for (auto const& n : R) {
            auto val = w[n];
            if (val > mmax) {
                idx = n;
                mmax = val;
            }
        }

        return {idx, mmax};
    }

    // 
    // find the max index of set R f
    //

    //
    // initialization
    //
    std::set<int> P;
    std::set<int> R;
    for (int i=1; i<=M; ++i)
        R.insert(i);
    VectorM d;
    for (int i=1; i<=M; ++i)
        d << 0;
    VectorM w = Z.transpose() * (x - Z*d);

    //
    // main loop
    //
    while (!R.empty() and max_of_set(R, w).second>tolerance) {
        int m = 
    }
}

int main(int argc, char **argv) {
    return 0;
}
