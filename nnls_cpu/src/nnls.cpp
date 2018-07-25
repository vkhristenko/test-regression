#include <iostream>
#include <set>
#include <string>

#include "Eigen/Core"
#include "Eigen/Dense"

#define println(msg)\
    #ifdef DEBUG

constexpr int M = 10;
constexpr int L = 10;

void print_set(std::set<int> const& s, std::string const& name) {
    std::cout << name << ": {";
    for (auto const& v : s) 
        std::cout << v << ", ";
    std::cout << "}" << std::endl;
}

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
#ifdef DEBUG
    std::cout << "randomize inputs" << std::endl;
#endif
    VectorL x = VectorL::Random(L, 1) * 100;
    MatrixLM Z = MatrixLM::Random(L, M) * 100;

    //
    // aux definitions
    //
    double tolerance = 0.0000000001;
    
    // 
    // find the max coefficient from vector w for indices coming from set R
    //auto
    auto max_of_set = [](std::set<int> const& S, VectorM const& w) -> std::pair<int, ValueType> {
        int idx = *S.begin();
        ValueType mmax = w(idx,0);
        for (auto const& n : S) {
            auto val = w(n, 0);
            if (val > mmax) {
                idx = n;
                mmax = val;
            }
        }

        return {idx, mmax};
    };
    auto min_of_set = [](std::set<int> const& S, VectorM const& w) -> std::pair<int, ValueType> {
        int idx = *S.begin();
        ValueType mmin = w(idx,0);
        for (auto const& n : S) {
            auto val = w(n, 0);
            if (val < mmin) {
                idx = n;
                mmin = val;
            }
        }

        return {idx, mmin};
    };
    auto min_of_set_extended = [](std::set<int> const& S, VectorM const& w, VectorM const& d) 
        -> std::pair<int, ValueType> {
        int idx = *S.begin();
        ValueType mmin = d(idx,0)/(d(idx,0) - w(idx,0));
        for (auto const& n : S) {
            auto val = d(n, 0) / (d(n, 0) - w(n, 0));
            if (val < mmin) {
                idx = n;
                mmin = val;
            }
        }

        return {idx, mmin};
    };

    // 
    // find the max index of set R f
    //

    //
    // initialization
    //
#ifdef DEBUG
    std::cout << "initialization" << std::endl;
#endif
    std::set<int> P;
    std::set<int> R;
    std::set<int> All;
    for (int i=0; i<M; ++i)
        R.insert(i);
    All = R;
    VectorM d;
    for (int i=0; i<M; ++i)
        d.coeffRef(i) = 0;
    VectorM w = Z.transpose() * (x - Z*d);

    //
    // main loop
    //
#ifdef DEBUG
    std::cout << "main loop" << std::endl;
#endif
    int max_iterations = 100;
    int current_iteration = 0;
    while (!R.empty() and max_of_set(R, w).second>tolerance and current_iteration<max_iterations) {
        int m = max_of_set(R, w).first;
#ifdef DEBUG
        std::cout << "iteration = " << current_iteration << "  m = " << m << std::endl;
#endif

        // update the passive and active sets
        P.insert(m); 
        R.erase(m);
#ifdef DEBUG
        print_set(P, "P");
        print_set(R, "R");
#endif

        // estimators
        VectorM s_p = (Z.transpose() * Z).inverse() * Z.transpose() * x;

        //
        // inner loop
        //
        while (min_of_set(P, s_p) <= 0) {
            auto alpha = -min_of_set_extended(P, w, d);
#ifdef DEBUG
            std::cout << "alhpa = " << alpha << std::endl;
#endif

            // update ds
            d = d + alpha * (s_p - d);


        }
        
        ++current_iteration;
    }
}

int main(int argc, char **argv) {
#ifdef DEBUG
    std::cout << "start nnls" << std::endl;
#endif
    nnls();
#ifdef DEBUG
    std::cout << "finish nnls" << std::endl;
#endif

    return 0;
}
