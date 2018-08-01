#include <Eigen/Dense>

#if DECOMPOSITION==USE_SPARSE_QR
#include <Eigen/SparseQR>
#include <Eigen/Sparse>
#endif

// #include <vector>

#include "../interface/fnnls.h"
#include "../interface/vector.h"

#ifdef DEBUG_FNNLS_GPU
#include <stdio.h>
#endif

using namespace Eigen;


__host__ __device__
void print_fixed_matrix(const FixedMatrix &M) {
    printf("ciao");
    for(unsigned int i = 0; i < MATRIX_SIZE; i++){
        for(unsigned int j = 0; j < MATRIX_SIZE; j++){                   
            printf("%d ", M(i,j));
        }
        printf("\n");
    }
}

__host__ __device__
void print_fixed_vector(const FixedVector &V) {
    printf("ciao");
    for(unsigned int i = 0; i < MATRIX_SIZE; i++){
        printf("%d ", V[i]);
    }
        printf("\n");
}


__device__ __host__ FixedVector fnnls(const FixedMatrix &A, const FixedVector &b, const double eps, const unsigned int max_iterations){

	#ifdef DEBUG_FNNLS_GPU
	printf("debug fnnls");
	print_fixed_matrix(A);
	print_fixed_vector(b);
	#else
    printf("hello world\n");
    #endif
	
 	// Fast NNLS (fnnls) algorithm as per 
	// http://users.wfu.edu/plemmons/papers/Chennnonneg.pdf
	// page 8
	
	// FNNLS memorizes the A^T * A and A^T * b to reduce the computation.
	// The pseudo-inverse obtined has the same numerical problems so
	// I keep the same decomposition utilized for NNLS.

	
	// pseudoinverse (A^T * A)^-1 * A^T 
	// this pseudo-inverse has numerical issues
	// in order to avoid that I substitued the pseudoinvese wiht the QR decomposition
	
	#if DECOMPOSITION==USE_SPARSE_QR
	Eigen::SparseQR<Eigen::SparseMatrix<double>, Eigen::VectorXd> solver;
	#elif DECOMPOSITION==USE_LLT
	Eigen::LLT<FixedMatrix> solver;
	#elif DECOMPOSITION==USE_HOUSEHOLDER
	Eigen::HouseholderQR<FixedMatrix> solver;
	#endif
	
	vector<unsigned int> P;
	vector<unsigned int> R(VECTOR_SIZE);

	// initial set of indexes
	#pragma unroll
	for ( unsigned int i=0; i<VECTOR_SIZE; ++i) R[i] = i;

	// initial solution vector
	FixedVector x = FixedVector::Zero();

	auto AtA = A.transpose() * A;
	auto Atb = A.transpose() * b;

	// main loop 
	for (int iter=0; iter<max_iterations; ++iter){

	
		// FNNLS
		FixedVector w = Atb - (AtA*x);
		

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


		P.push_back(max_index);
		// R.erase(R.begin()+remove_index);
		R.erase(remove_index);

		// termination condition
		if(R.empty() || w[max_index] < eps) break;


		FixedMatrix A_P = FixedMatrix::Zero();

		for(auto index: P) A_P.col(index)=A.col(index);

		#if DECOMPOSITION==USE_SPARSE_QR
		solver.compute(A_P.sparseView());
		#else
		solver.compute(A_P);
		#endif

		Eigen::VectorXd s =  solver.solve(b);
		
		// inner loop
		while(true){

			auto min_s = std::numeric_limits<double>::max();

			for (auto index: P)
				min_s = std::min(s[index],min_s);
			

			if(min_s > 0 ) break;

			auto alpha = std::numeric_limits<double>::max();

			for (auto index: P){
				if (s[index] <= 0 ){
					alpha = -std::min(x[index]/(x[index]-s[index]), alpha);
				}
			}

			for (auto index: P)
				x[index] += alpha*(s[index]-x[index]);

			vector<unsigned int> tmp;

			for(int i=P.size()-1; i>=0; --i){
				auto index = P[i]; 
				if(x[index]==0){
					R.push_back(index);
					tmp.push_back(i);
				}
			}

			// for(auto index: tmp) P.erase(P.begin()+index);
			for(auto index: tmp) P.erase(index);
			
			A_P.setZero();
	
			for(auto index: P) A_P.col(index)=A.col(index);
			
			#if DECOMPOSITION==USE_SPARSE_QR
			solver.compute(A_P.sparseView());
			#else
			solver.compute(A_P);
			#endif
			
			s =  solver.solve(b);

			for(auto index: R) s[index]=0;

			return x;
		}

		x = s;
	}

	#ifdef DEBUG_FNNLS_GPU
	print_fixed_vector(x);
	#endif

	return x;
}

__global__ void fnnls_kernel(NNLS_args *args, FixedVector* x, unsigned int n, double eps, unsigned int max_iterations){
	// thread idx
    printf("hello fnnls\n");
	int i = blockIdx.x*blockDim.x + threadIdx.x;
	printf("thread index %i\n", i);
	if (i>=n) return;
	auto &A = args[i].A;
	auto &b = args[i].b;
	x[i] = fnnls(A, b, eps, max_iterations);

}
