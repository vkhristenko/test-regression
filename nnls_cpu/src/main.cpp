#include <Eigen/Dense>
#include <algorithm>
#include <iostream>
#include <numeric>
#include <vector>

#include "../interface/data_types.h"
#include "../interface/eigen_nnls.h"
#include "../interface/fnnls.h"
#include "../interface/nnls.h"
#include "io/interface/ecal_data_io.h"

using namespace std;
using namespace Eigen;

auto tests = 100;

// #define VERBOSE

int main(const int argc, char** const argv) {
  //   reading input from file
  std::string file_name;
  if (argc >= 2)
    file_name = {argv[1]};

  ecal_data_io io{file_name};
  auto entries = io.get_n_entries(10000);
  tests = entries.size();

  //   srand(42);
  vector<double> eigen_error;
  vector<double> nnls_error;
  vector<double> fnnls_error;
  vector<double> delta;
  int iteration = 0;
  for (auto const& p : entries) {
    auto const& b = p.first;
    auto const& A = p.second;

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
    // A(i, j) = A(j, i);

    Eigen::NNLS<FixedMatrix> eigen_nnls(A);
    auto status = eigen_nnls.solve(b);
    assert(status);
    if (!status)
      return -1;
    auto x = eigen_nnls.x();
    auto x2 = nnls(A, b, 1e-21, 1000);
    // exit(0);
    auto x3 = fnnls(A, b, 1e-21, 1000);
    delta.push_back((x - x2).norm());

#ifdef VERBOSE
    cout << "eigen" << endl;
    cout << x << endl;
    cout << "nnls" << endl;
    cout << x2 << endl;
    cout << "fnnls" << endl;
    cout << x3 << endl;
#endif
    // sleep(2);

    double error;
    error = (b - A * x).squaredNorm();
    eigen_error.push_back(error);

#ifdef VERBOSE
    cout << "eigen error " << error << endl;
#endif

    error = (b - A * x2).squaredNorm();
    nnls_error.push_back(error);

#ifdef VERBOSE
    cout << "nnls error " << error << endl;
#endif

    error = (b - A * x3).squaredNorm();
    fnnls_error.push_back(error);

#ifdef VERBOSE
    cout << "fnnls error " << error << endl;
#endif
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
