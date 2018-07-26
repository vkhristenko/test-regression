#include <Eigen/Dense>
#include <iostream>


#include "../interface/nnls.h"
#include "../interface/fnnls.h"
#include "../interface/data_types.h"
#include "../interface/eigen_nnls.h"


using namespace std;
using namespace Eigen;

int main(){

	srand(42);
	
	auto A = FixedMatrix::Random();
	auto b = FixedVector::Random();

	Eigen::NNLS<FixedMatrix> eigen_nnls(A);
	auto status = eigen_nnls.solve(b);
	assert(status);
	if (!status) return -1;
	auto x = eigen_nnls.x();
	cout << "eigen" << endl;	
	cout << x << endl;
	cout << "mine" << endl;
	auto x2 = nnls(A,b, 1e-21, 1000);
	cout << "x" << endl << x2 << endl;
	cout << "eigen error " << (b-A*x).norm() << endl;
	cout << "my error " << (b-A*x2).norm() << endl;
	return 0;
}