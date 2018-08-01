#include <Eigen/Dense>
#include <algorithm>
#include <iostream>
#include <numeric>
#include <vector>

// #include "../interface/nnls.h"
// #include "../interface/fnnls.h"
// #include "../interface/data_types.h"
#include "../interface/eigen_nnls.h"
#include "../interface/kernel_wrapper.h"
#include "io/interface/ecal_data_io.h"

using namespace std;
using namespace Eigen;

auto tests = 100;

int main(const int argc, char** const argv) {
  std::string file_name;
  if (argc >= 2)
    file_name = {argv[1]};

  ecal_data_io io{file_name};
  auto entries = io.get_n_entries(10000);
    tests = entries.size();
//   tests = 1;

  // srand(42);
  vector<double> eigen_error;
  vector<double> nnls_error;
  vector<double> fnnls_error;

  vector<NNLS_args> args;
  vector<FixedVector> nnls_results;
  vector<FixedVector> fnnls_results;

  vector<double> delta;
  int iteration = 0;
  for (auto const& p : entries) {
    FixedVector const& b = p.first;
    FixedMatrix const& A = p.second;
    // cout << "A" << endl << A << endl;
    // cout << "b" << endl << b << endl;
#ifdef VERBOSE
    cout << "iteration :" << iteration++ << endl;
    // cout << A << endl;
    // cout << b << endl;
#endif
    // exit(0);
    // FixedMatrix A = FixedMatrix::Random();
    // auto b = FixedVector::Random();

    // for (unsigned int i = 0; i < MATRIX_SIZE; i++)
    //   for (unsigned int j = 0; j < MATRIX_SIZE; j++)
    // A(i, j) = A(j, i);    FixedMatrix A = FixedMatrix::Random();

    args.push_back(NNLS_args(A, b));
    Eigen::NNLS<FixedMatrix> eigen_nnls(A);
    auto status = eigen_nnls.solve(b);
    assert(status);
    if (!status)
      return -1;
    auto x = eigen_nnls.x();

#ifdef VERBOSE
    cout << "eigen" << endl;
    cout << x << endl;
#endif

    double error;
    error = (b - A * x).squaredNorm();
    eigen_error.push_back(error);

#ifdef VERBOSE
    cout << "eigen error " << error << endl;
#endif
    // break;
  }

  nnls_results = nnls_wrapper(args);
  fnnls_results = fnnls_wrapper(args);

  for (int i = 0; i < tests; ++i) {
    double error = (args[i].b - args[i].A * nnls_results[i]).squaredNorm();
    nnls_error.push_back(error);
    error = (args[i].b - args[i].A * fnnls_results[i]).squaredNorm();
    fnnls_error.push_back(error);
  }

  double max = *std::max_element(eigen_error.begin(), eigen_error.end());
  cout << "eigen_max_error " << max << endl;
  max = *std::max_element(nnls_error.begin(), nnls_error.end());
  cout << "nnls_max_error " << max << endl;
  max = *std::max_element(fnnls_error.begin(), fnnls_error.end());
  cout << "fnnls_max_error " << max << endl;

  double avg =
      std::accumulate(eigen_error.begin(), eigen_error.end(), 0.) / tests;
  cout << "eigen_avg_error " << avg << endl;
  avg = std::accumulate(nnls_error.begin(), nnls_error.end(), 0.) / tests;
  cout << "nnls_avg_error " << avg << endl;
  avg = std::accumulate(fnnls_error.begin(), fnnls_error.end(), 0.) / tests;
  cout << "fnnls_avg_error " << avg << endl;

  avg = std::accumulate(delta.begin(), delta.end(), 0.) / tests;
  cout << "delta eigen, nnls " << avg << endl;

  return 0;
}
