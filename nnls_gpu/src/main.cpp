#include <Eigen/Dense>
#include <iostream>
#include <vector>
#include <numeric>
#include <algorithm>


// #include "../interface/nnls.h"
// #include "../interface/fnnls.h"
// #include "../interface/data_types.h"
#include "../interface/eigen_nnls.h"
#include "../interface/kernel_wrapper.h"


using namespace std;
using namespace Eigen;

auto const tests = 16384;

int main(){
	
	srand(42);
	vector<double> eigen_error;
	vector<double> nnls_error;
	vector<double> fnnls_error;

	for (int i = 0; i < 100; ++ i ){
		auto A = FixedMatrix::Random();
		auto b = FixedVector::Random();

		Eigen::NNLS<FixedMatrix> eigen_nnls(A);
		auto status = eigen_nnls.solve(b);
		assert(status);
		if (!status) return -1;
		auto x = eigen_nnls.x();
		auto x2 = nnls(A,b, 1e-21, 1000);
		auto x3 = fnnls(A,b, 1e-21, 1000);
		
		#ifdef VERBOSE
		cout << "eigen" << endl;	
		cout << x << endl;
		cout << "nnls" << endl;
		cout << x2 << endl;
		cout << "fnnls" << endl;
		cout << x3 << endl;
		#endif
		
		double error;
		error =  (b-A*x).squaredNorm(); 
		eigen_error.push_back(error);

		#ifdef VERBOSE
		cout << "eigen error " << error << endl;
		#endif
		
		error = (b-A*x2).squaredNorm();
		nnls_error.push_back(error);

		#ifdef VERBOSE
		cout << "nnls error " << error << endl;
		#endif
		
		error = (b-A*x3).squaredNorm();
		fnnls_error.push_back(error);

		#ifdef VERBOSE
		cout << "fnnls error " << error << endl;
		#endif
	}
	double max =  *std::max_element(eigen_error.begin(), eigen_error.end());
	cout << "eigen_max_error " << max << endl;
	max = *std::max_element(nnls_error.begin(), nnls_error.end()) ;
	cout << "nnls_max_error " << max << endl;
	max = *std::max_element(fnnls_error.begin(), fnnls_error.end());
	cout << "fnnls_max_error " << max << endl;
	
	double avg = std::accumulate(eigen_error.begin(), eigen_error.end(), 0.)/tests;
	cout << "eigen_avg_error " << avg << endl;
	avg = std::accumulate(nnls_error.begin(), nnls_error.end(), 0.)/tests;
	cout << "nnls_avg_error " << avg << endl;
	avg = std::accumulate(fnnls_error.begin(), fnnls_error.end(), 0.)/tests;
	cout << "fnnls_avg_error " << avg << endl;
	
	return 0;
}