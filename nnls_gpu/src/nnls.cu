#include <Eigen/Dense>

#ifdef DEBUG_NNLS_GPU
#include <stdio.h>
#endif

#include "../interface/nnls.h"
#include "../interface/vector.h"

using namespace Eigen;


__device__ __host__ 
void print_fixed_matrix(const FixedMatrix& M) {
  for (unsigned int i = 0; i < MATRIX_SIZE; i++) {
    for (unsigned int j = 0; j < MATRIX_SIZE; j++) {
      printf("%d ", M(i, j));
    }
    printf("\n");
  }
}

__device__ __host__ 
void print_fixed_vector(const FixedVector& V) {
  for (unsigned int i = 0; i < MATRIX_SIZE; i++) {
    printf("%d ", V[i]);
  }
  printf("\n");
}

__device__ __host__ 
void print_device_vector(vector<unsigned int> v){
	for(auto elem: v) printf("%u ", elem);
	printf("\n");

}



__device__ __host__
FixedVector nnls(const FixedMatrix& A,
                 const FixedVector& b,
                 const double eps,
                 const unsigned int max_iterations) {

#ifdef DEBUG_NNLS_GPU
  printf("nnls launched\n");
	printf("parameters size: A(%i,%i) b(%i)\n", A.rows(), A.cols(), b.cols());
	printf("A\n");
	print_fixed_matrix(A);
	printf("b\n");
	print_fixed_vector(b);
#endif

  // Fast NNLS (fnnls) algorithm as per
  // http://users.wfu.edu/plemmons/papers/Chennnonneg.pdf
  // page 8

  // pseudoinverse (A^T * A)^-1 * A^T
  // this pseudo-inverse has numerical issues
  // in order to avoid that I substitued the pseudoinvese wiht the QR
  // decomposition

	vector<unsigned int> P;
	vector<unsigned int> R(VECTOR_SIZE);

// initial set of indexes
	#pragma unroll
  for (unsigned int i = 0; i < VECTOR_SIZE; ++i) R[i] = i;
	
  #ifdef DEBUG_NNLS_GPU
	printf("P ");
	print_device_vector(P);
	printf("R ");
	print_device_vector(R);
  #endif
  // initial solution vector
  FixedVector x = FixedVector::Zero();

  // main loop
  for (int iter = 0; iter < max_iterations; ++iter) {
    // NNLS
    // initialize the cost vector

    FixedVector w = A.transpose() * (b - (A * x));


    // initialize the value for the while guard
    // max_index will contain the index of the max coeff anf max_w is the max
    // coeff
    unsigned int max_index = R[0];
    unsigned int remove_index = 0;

    #ifdef DEBUG_NNLS_GPU
    printf("Max index %u, remove index %u\n", max_index, remove_index);
    #endif
    for (unsigned int i = 0; i < R.size(); ++i) {
			auto index = R[i];
      if (w(index) > w(max_index)) {
				max_index = index;
        remove_index = i;
      }
    }
    #ifdef DEBUG_NNLS_GPU
		printf("before the erase\n");
		printf("P ");
		print_device_vector(P);
		printf("R ");
		print_device_vector(R);
		
		printf("Max index %u, remove index %u\n", max_index, remove_index);
    #endif
		
    P.push_back(max_index);
    // R.erase(R.begin()+remove_index);
    R.erase(remove_index);

    #ifdef DEBUG_NNLS_GPU
		printf("after the erase\n");
		printf("P ");
		print_device_vector(P);
		printf("R ");
		print_device_vector(R);
		#endif
		// fflush(NULL);
    // termination condition
    if (R.empty() || w[max_index] < eps)
      break;

    FixedMatrix A_P = FixedMatrix::Zero();

    for (auto index : P)
      A_P.col(index) = A.col(index);

// FixedVector s = (A_P.transpose()*A_P).inverse() * A_P.transpose() * b;
#if DECOMPOSITION == USE_LLT
    FixedVector s = A_P.llt().matrixL().solve(b);
#elif DECOMPOSITION == USE_LDLT
    FixedVector s = A_P.ldlt().matrixL().solve(b);
#elif DECOMPOSITION == USE_HOUSEHOLDER
    FixedVector s = A_P.colPivHouseholderQr().solve(b);
#endif

    #ifdef DEBUG_NNLS_GPU
    printf("after the decomposition\n");
    #endif
    
    for (auto index : R)
    s[index] = 0;
    
    // inner loop
    while (true) {
      auto min_s = std::numeric_limits<double>::max();
      
      for (auto index : P)
      min_s = std::min(s[index], min_s);
      
			#ifdef DEBUG_FNNLS
      cout << "min_s " << min_s << endl;
			#endif
      
      if (min_s > 0)
      break;
      
      auto alpha = std::numeric_limits<double>::max();
      
      for (auto index : P) {
        if (s[index] <= 0) {
          alpha = std::min(-x[index] / (s[index] - x[index]), alpha);
        }
      }
      
      printf("alpha %d", alpha);
      // fflush(NULL);
      
      for (auto index : P)
        x[index] += alpha * (s[index] - x[index]);

      vector<unsigned int> tmp;

      for (int i = P.size() - 1; i >= 0; --i) {
        auto index = P[i];
        if (x[index] == 0) {
          R.push_back(index);
          tmp.push_back(i);
        }
      }

      // for(auto index: tmp) P.erase(P.begin()+index);
      for (auto index : tmp)
        P.erase(index);

      A_P.setZero();

      for (auto index : P)
        A_P.col(index) = A.col(index);

#if DECOMPOSITION == USE_LLT
      s = A_P.llt().matrixL().solve(b);
#elif DECOMPOSITION == USE_LDLT
      s = A_P.ldlt().matrixL().solve(b);
#elif DECOMPOSITION == USE_HOUSEHOLDER
      s = A_P.colPivHouseholderQr().solve(b);
#endif

      for (auto index : R)
        s[index] = 0;
    }

    x = s;
  }

  return x;
}

__global__ void nnls_kernel(NNLS_args* args,
                            FixedVector* x,
                            unsigned int n,
                            double eps,
                            unsigned int max_iterations) {
  // thread idx
  // printf("hello nnls\n");
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  // printf("thread index %i\n", i);
  if (i >= n)
    return;
	auto& A = args[i].A;
	// printf("inside the kernel\n");
	// print_fixed_matrix(A);
	auto& b = args[i].b;
	// print_fixed_vector(b);
  x[i] = nnls(A, b, eps, max_iterations);
}
