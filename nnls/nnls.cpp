#include <Eigen/Dense>
#include "nnsl.h"
#include <iostream>
#include <vector>
#include <map>
#include "eigen_nnls.h"

using namespace std;
using namespace Eigen;

 
 
FixedVector nnls(const FixedMatrix &A, const FixedVector &b, const double eps, const unsigned int max_iterations){

 	// Fast NNLS (fnnls) algorithm as per 
	// http://users.wfu.edu/plemmons/papers/Chennnonneg.pdf
	// page 8
	
	// declarations of all needed parameters
	// FixedMatrix A = _covdecomp.matrixL().solve(_pulsemat);


	// std::cout << A << std::endl;
	// std::cout << b << std::endl;

	// TODO: this should be a parameter not a magic number 


	// initial solution vector
	FixedVector x = FixedVector::Zero();

	std::vector<unsigned int> P;
	std::map<unsigned int, double> R;

	// store the matrix to avoid to recompute it every times
	FixedMatrix AtA = A.transpose()*A;


	// initialization
	// cost vector
	
	// NNLS
	// FixedVector w = A.transpose()*(b - (A*x));
	
	// FNNLS
	FixedVector w = ( A.transpose()*b ) - (AtA*x);

	// initial set of indexes
	for ( unsigned int i=0; i<VECTOR_SIZE; ++i)
		R[i] = w[i];

	// initialize the value for the while guard
	// j will contain the index of the max coeff anf max_w is the max coeff 
	unsigned int max_index = 0;
	auto max_w = w[max_index];


  
	// main loop 
	for (int iter=0; iter<max_iterations; ++iter){
			
		// theres no eigen helper function for this. Thats why is calculated manually
		for (auto const &coeff: R){
			if(coeff.second>max_w){
				max_w = coeff.second;
				max_index = coeff.first;
			}  
		}

		if(R.empty() || max_w<=eps) break;


		// Include the index max_index in P and remove it from R
		P.emplace_back(max_index);
		R.erase(max_index);
		
		// construct the submatrix A^P
		// FixedMatrix AtA_P = FixedMatrix::Zero(P.size(),_bxs.rows());
		// Eigen::MatrixXd AtA_P(_bxs.rows(), P.size());

		// construct the submatrix AtA^P
		FixedMatrix AtA_P = sub_matrix<std::vector<unsigned int>, FixedMatrix, FixedMatrix>(AtA, P);
		
		// tempory solution vector
		FixedVector s = FixedVector::Zero();

		// vector obtained by A*b
		FixedVector Ab = A.transpose()*b;
		for (const auto &index: R){
			Ab[index.first] = 0;
		}

		FixedVector s_p = AtA_P.inverse()*Ab;

		for (auto index: P){
			s[index] = s_p[index];
		}
		
		while (s_p.minCoeff() <= 0){
		
			// real computation
			double alpha = std::numeric_limits<double>::max();
			for(auto index: P){
				if (s[index]  < 0)
				alpha = std::min(x[index]/(x[index]-s[index]), alpha);
			}

			x += alpha*(s-x);
		
			for (auto it=P.begin(); it != P.end();){
				auto index = *it;
				if(x[index]==0){
					R[index] = w[index];
					P.erase(it);
				} else it++;
			}

			s.setZero();
			Ab = A.transpose()*b;
			for (const auto &index: R){
				Ab[index.first] = 0;
			}

			AtA_P = sub_matrix<std::vector<unsigned int>,FixedMatrix,FixedMatrix>(AtA, P);
			s_p = AtA_P.inverse() * Ab;

			for (auto index: P){
				s[index] = s_p[index];
			}
		}
		
		x = s;
		
		// std::cout << x << std::endl;

		w = ( A.transpose()*b ) - (AtA*x);
	}

	return x;
}


int main(){

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
	auto x2 = nnls(A,b);
	cout << x2 << endl;
	return 0;
}