#include <Eigen/Dense>
#include <Eigen/SparseQR>
#include <Eigen/Sparse>

#include "nnsl.h"
#include <iostream>
#include <vector>
#include "eigen_nnls.h"

using namespace std;
using namespace Eigen;


FixedVector nnls(const FixedMatrix &A, const FixedVector &b, const double eps, const unsigned int max_iterations){

 	// Fast NNLS (fnnls) algorithm as per 
	// http://users.wfu.edu/plemmons/papers/Chennnonneg.pdf
	// page 8
	
	Eigen::SparseQR<Eigen::SparseMatrix<double>, Eigen::VectorXd> solver;

	std::vector<unsigned int> P;
	std::vector<unsigned int> R(VECTOR_SIZE);

	// initial set of indexes
	#pragma unroll
	for ( unsigned int i=0; i<VECTOR_SIZE; ++i) R[i] = i;

	// initial solution vector
	FixedVector x = FixedVector::Zero();

	// auto AtA = A.transpose() * A;

	// main loop 
	for (int iter=0; iter<max_iterations; ++iter){

		// cout << "iter " << iter << endl;


		//NNLS
		// initialize the cost vector
		FixedVector w = A.transpose()*(b - (A*x));
		
		// FNNLS
		// FixedVector w = (A.transpose()*b) - (AtA*x);

		cout << "w" << endl << w << endl;

		// initialize the value for the while guard
		// max_index will contain the index of the max coeff anf max_w is the max coeff 
		unsigned int max_index = R[0];	
		unsigned int remove_index = 0;

		for (unsigned int i=0; i<R.size(); ++i){
			auto index = R[i];
			if(w[index] > w[max_index]){
				max_index = index;
				remove_index = i;
			}
		}


		// cout << "max index " << max_index << endl;

		P.emplace_back(max_index);
		R.erase(R.begin()+remove_index);

		// termination condition
		if(R.empty() || w[max_index] < eps) break;

		// cout << "P " << endl;
		// for (auto elem : P) cout << elem << " ";
		// cout << endl;
		// cout << "R " << endl;
		// for (auto elem : R) cout << elem << " ";
		// cout << endl;

		// NNLS

		// Eigen::SparseMatrix<double, Eigen::ColMajor> A_P(MATRIX_SIZE, MATRIX_SIZE);
		FixedMatrix A_P = FixedMatrix::Zero();

		// A_P.setZero();

		for(auto index: P) A_P.col(index)=A.col(index);
			// for (unsigned int i=0; i< MATRIX_SIZE; ++i){
			// }

		solver.compute(A_P.sparseView());

		// cout << "A_P " << endl << A_P << endl; 

		// FixedVector s = (A_P.transpose()*A_P).inverse() * A_P.transpose() * b;
		// FixedVector s =  A_P.inverse() * b;
		Eigen::VectorXd s =  solver.solve(b);
		
		// FFNLS

		// FixedMatrix A_P = FixedMatrix::Zero();

		// for(auto index: P) A_P.col(index)=AtA.col(index);

		// cout << "A_P " << endl << A_P << endl; 

		// FixedVector Ab =  A.transpose() * b;

		// for(auto index: R) Ab[index] = 0;

		// FixedVector s = A_P.inverse() * Ab;
		
		for(auto index: R) s[index]=0;

		// cout << "s" << endl << s << endl;

		// inner loop
		while(true){

			auto min_s = std::numeric_limits<double>::max();

			for (auto index: P)
				min_s = std::min(s[index],min_s);
			
			cout << "min_s " << min_s << endl;

			if(min_s > 0 ) break;

			auto alpha = std::numeric_limits<double>::max();

			for (auto index: P){
				if (s[index] <= 0 ){
					alpha = -std::min(x[index]/(x[index]-s[index]), alpha);
				}
			}

			cout << "alpha " << alpha << endl;

			cout << "x before" << endl << x << endl;

			for (auto index: P)
				x[index] += alpha*(s[index]-x[index]);

			cout << "x after" << endl << x << endl;

			std::vector<unsigned int> tmp;

			// cout << "P  before" << endl;
			// for (auto elem : P) cout << elem << " ";
			// cout << endl;
			// cout << "R before" << endl;
			// for (auto elem : R) cout << elem << " ";
			// cout << endl;


			for(int i=P.size()-1; i>=0; --i){
				auto index = P[i]; 
				if(x[index]==0){
					R.emplace_back(index);
					tmp.emplace_back(i);
				}
			}

			for(auto index: tmp) P.erase(P.begin()+index);

			// cout << "P  after" << endl;
			// for (auto elem : P) cout << elem << " ";
			// cout << endl;
			// cout << "R after" << endl;
			// for (auto elem : R) cout << elem << " ";
			// cout << endl;

			// NNLS

			A_P.setZero();
	
			for(auto index: P) A_P.col(index)=A.col(index);
			
			solver.compute(A_P.sparseView());

			// s = (A_P.transpose()*A_P).inverse() * A_P.transpose() * b;
			// s = A_P.inverse() * b;
			s =  solver.solve(b);

			// FixedMatrix A_P = FixedMatrix::Zero();

			// for(auto index: P) A_P.col(index)=AtA.col(index);

			// cout << "A_P " << endl << A_P << endl; 

			// Ab =  A.transpose() * b;

			// for(auto index: R) Ab[index] = 0;

			// s = A_P.inverse() * Ab;

			for(auto index: R) s[index]=0;

			return x;
		}

		x = s;
	}


	return x;
}


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