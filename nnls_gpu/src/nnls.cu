#include <Eigen/Dense>
#include <Eigen/SparseQR>
#include <Eigen/Sparse>

#include <vector>

#ifdef DEBUG_FNNLS
#include <iostream>
#endif

#include "../interface/nnls.h"

using namespace std;
using namespace Eigen;


__device__ __host__ FixedVector nnls(const FixedMatrix &A, const FixedVector &b, const double eps, const unsigned int max_iterations){

 	// Fast NNLS (fnnls) algorithm as per 
	// http://users.wfu.edu/plemmons/papers/Chennnonneg.pdf
	// page 8
	

	// pseudoinverse (A^T * A)^-1 * A^T 
	// this pseudo-inverse has numerical issues
	// in order to avoid that I substitued the pseudoinvese wiht the QR decomposition
	
	// Eigen::SparseQR<Eigen::SparseMatrix<double>, Eigen::VectorXd> solver;
	Eigen::LLT<FixedMatrix> solver;
	
	thrust::device_vector<unsigned int> P;
	thrust::device_vector<unsigned int> R(VECTOR_SIZE);

	// initial set of indexes
	#pragma unroll
	for ( unsigned int i=0; i<VECTOR_SIZE; ++i) R[i] = i;

	// initial solution vector
	FixedVector x = FixedVector::Zero();


	// main loop 
	for (int iter=0; iter<max_iterations; ++iter){

		#ifdef DEBUG_FNNLS
		// cout << "iter " << iter << endl;
		#endif

		//NNLS
		// initialize the cost vector
		FixedVector w = A.transpose()*(b - (A*x));
		
		#ifdef DEBUG_FNNLS
		// cout << "w" << endl << w << endl;
		#endif

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

		#ifdef DEBUG_FNNLS
		// cout << "max index " << max_index << endl;
		#endif

		P.push_back(max_index);
		R.erase(R.begin()+remove_index);

		// termination condition
		if(R.empty() || w[max_index] < eps) break;

		#ifdef DEBUG_FNNLS
		// cout << "P " << endl;
		// for (auto elem : P) cout << elem << " ";
		// cout << endl;
		// cout << "R " << endl;
		// for (auto elem : R) cout << elem << " ";
		// cout << endl;
		#endif

		FixedMatrix A_P = FixedMatrix::Zero();


		for(auto index: P) A_P.col(index)=A.col(index);

		solver.compute(A_P);

		#ifdef DEBUG_FNNLS
		// cout << "A_P " << endl << A_P << endl; 
		#endif

		// FixedVector s = (A_P.transpose()*A_P).inverse() * A_P.transpose() * b;
		Eigen::VectorXd s =  solver.solve(b);
	
		for(auto index: R) s[index]=0;

		#ifdef DEBUG_FNNLS
		// cout << "s" << endl << s << endl;
		#endif

		// inner loop
		while(true){

			auto min_s = std::numeric_limits<double>::max();

			for (auto index: P)
				min_s = std::min(s[index],min_s);
			
			#ifdef DEBUG_FNNLS
			cout << "min_s " << min_s << endl;
			#endif

			if(min_s > 0 ) break;

			auto alpha = std::numeric_limits<double>::max();

			for (auto index: P){
				if (s[index] <= 0 ){
					alpha = -std::min(x[index]/(x[index]-s[index]), alpha);
				}
			}
			#ifdef DEBUG_FNNLS

			cout << "alpha " << alpha << endl;

			cout << "x before" << endl << x << endl;

			#endif

			for (auto index: P)
				x[index] += alpha*(s[index]-x[index]);

			#ifdef DEBUG_FNNLS
			cout << "x after" << endl << x << endl;
			#endif

			thrust::device_vector<unsigned int> tmp;

			#ifdef DEBUG_FNNLS
			// cout << "P  before" << endl;
			// for (auto elem : P) cout << elem << " ";
			// cout << endl;
			// cout << "R before" << endl;
			// for (auto elem : R) cout << elem << " ";
			// cout << endl;
			#endif


			for(int i=P.size()-1; i>=0; --i){
				auto index = P[i]; 
				if(x[index]==0){
					R.push_back(index);
					tmp.push_back(i);
				}
			}

			for(auto index: tmp) P.erase(P.begin()+index);
			
			#ifdef DEBUG_FNNLS

			// cout << "P  after" << endl;
			// for (auto elem : P) cout << elem << " ";
			// cout << endl;
			// cout << "R after" << endl;
			// for (auto elem : R) cout << elem << " ";
			// cout << endl;
			#endif

			// NNLS

			A_P.setZero();
	
			for(auto index: P) A_P.col(index)=A.col(index);
			
			solver.compute(A_P.sparseView());

			s =  solver.solve(b);

			for(auto index: R) s[index]=0;

			return x;
		}

		x = s;
	}


	return x;
}
