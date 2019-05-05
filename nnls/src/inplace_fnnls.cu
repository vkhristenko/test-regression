#include <Eigen/Dense>

#include "../interface/inplace_fnnls.h"

using namespace Eigen;


// cache optimized matrix multiplication for 10x10 matrices
#ifdef __CUDA_ARCH__
__device__ __host__ 
#endif
inline FixedMatrix transpose_multiply(const FixedMatrix &A){
  FixedMatrix result;
  #pragma unroll MATRIX_SIZE
  for(auto i = 0; i < MATRIX_SIZE; ++i){    
    for(auto j = i; j < MATRIX_SIZE; ++j){
      result.data()[j*MATRIX_SIZE + i] = 0;
      #pragma vectorise
      for(auto k = 0; k < MATRIX_SIZE; ++k)
        result.data()[j*MATRIX_SIZE + i] += A.data()[i*MATRIX_SIZE+k]*A.data()[j*MATRIX_SIZE+k];
      result.data()[i*MATRIX_SIZE + j] = result.data()[j*MATRIX_SIZE + i];
    }
    // result = result.selfadjointView<Eigen::Upper>();
  }
  return result;
}

#ifdef __CUDA_ARCH__
__device__ __host__ 
#endif
void inplace_fnnls(const FixedMatrix& A,
                                       const FixedVector& b,
                                       FixedVector& x,
                                       const double eps,
                                       const unsigned int max_iterations) {
  // Fast NNLS (fnnls) algorithm as per
  // http://users.wfu.edu/plemmons/papers/Chennnonneg.pdf
  // page 8

  // FNNLS memorizes the A^T * A and A^T * b to reduce the computation.
  // The pseudo-inverse obtained has the same numerical problems so
  // I keep the same decomposition utilized for NNLS.

  // pseudoinverse (A^T * A)^-1 * A^T
  // this pseudo-inverse has numerical issues
  // in order to avoid that I substituted the pseudoinverse with the llT 
  // this require some modification the projection (A^T * A)^P
  // decomposition

  // NNLS initialization
  auto nPassive = 0;
  
  FixedMatrix AtA = transpose_multiply(A);
  FixedVector Atb = A.transpose() *b;

  FixedVector s;
  FixedVector w;

  Eigen::PermutationMatrix<VECTOR_SIZE> permutation;
  permutation.setIdentity();

// main loop
#pragma unroll VECTOR_SIZE
  for (auto iter = 0; iter < max_iterations; ++iter) {
    const auto nActive = VECTOR_SIZE - nPassive;

#ifdef DEBUG_FNNLS_CPU
    cout << "iter " << iter << endl;
#endif
    
    // If all the positivity contraints are satisfied the correct solution has 
    // been calculated, then exit.
    if(!nActive)
      break;

    w.tail(nActive) = Atb.tail(nActive) - (AtA * x).tail(nActive);

#ifdef DEBUG_FNNLS_CPU
    cout << "w" << endl << w.tail(nActive) << endl;
#endif
    // get the index of w that gives the maximum gain
    Index w_max_idx;
    const auto max_w = w.tail(nActive).maxCoeff(&w_max_idx);

    // check for convergence
    if (max_w < eps)
      break;
#ifdef DEBUG_FNNLS_CPU
    cout << "n active " << nActive << endl;
    cout << "w max idx " << w_max_idx << endl;
  #endif

    // need to translate the index into the right part of the vector
    w_max_idx += nPassive;

    // swap AtA to avoid copy
    AtA.col(nPassive).swap(AtA.col(w_max_idx));
    AtA.row(nPassive).swap(AtA.row(w_max_idx));
    // swap Atb to match with AtA
    Eigen::numext::swap(Atb.coeffRef(nPassive), Atb.coeffRef(w_max_idx));
    Eigen::numext::swap(x.coeffRef(nPassive), x.coeffRef(w_max_idx));
    // swap the permutation matrix to reorder the solution in the end
    Eigen::numext::swap(permutation.indices()[nPassive],
                        permutation.indices()[w_max_idx]);

    ++nPassive;

#ifdef DEBUG_FNNLS_CPU
    cout << "max index " << w_max_idx << endl;
    std::cout << "n_active " << nActive << std::endl;
#endif

// inner loop
#pragma unroll VECTOR_SIZE
    while (nPassive > 0) {
      // calculating the pseudoinverse ((A^T * A)^P)^-1 via llt decomposition
      s.head(nPassive) =
          AtA.topLeftCorner(nPassive, nPassive).llt().solve(Atb.head(nPassive));

      // If all the components are positive the solution has been calculated, 
      // then exit
      if (s.head(nPassive).minCoeff() > 0.) {
        x.head(nPassive) = s.head(nPassive);
        break;
      }

#ifdef DEBUG_FNNLS_CPU
      cout << "s" << endl << s.head(nPassive) << endl;
#endif
      // Compute the ratio to move a negative component to 0 
      auto alpha = std::numeric_limits<double>::max();
      Index alpha_idx = 0;

#pragma unroll VECTOR_SIZE
      for (auto i = 0; i < nPassive; ++i) {
        if (s[i] <= 0.) {
          auto const ratio = x[i] / (x[i] - s[i]);
          if (ratio < alpha) {
            alpha = ratio;
            alpha_idx = i;
          }
        }
      }
      // If no ratio can be derived all the components are not negative, exit
      if (std::numeric_limits<double>::max() == alpha) {
        x.head(nPassive) = s.head(nPassive);
        break;
      }

#ifdef DEBUG_FNNLS_CPU

      cout << "alpha " << alpha << endl;

      cout << "x before" << endl << x << endl;

#endif
      // translate the solution toward the positive part
      x.head(nPassive) += alpha * (s.head(nPassive) - x.head(nPassive));
      // This index will became 0 is set to this value to avoid numerical problems
      x[alpha_idx] = 0;
      --nPassive;

#ifdef DEBUG_FNNLS_CPU
      cout << "x after" << endl << x << endl;
#endif
      // new components sutisfy the non negativity contraints so is moved 
      // inside the active set
      AtA.col(nPassive).swap(AtA.col(alpha_idx));
      AtA.row(nPassive).swap(AtA.row(alpha_idx));
      // swap Atb to match with AtA
      Eigen::numext::swap(Atb.coeffRef(nPassive), Atb.coeffRef(alpha_idx));
      Eigen::numext::swap(x.coeffRef(nPassive), x.coeffRef(alpha_idx));
      // swap the permutation matrix to reorder the solution in the end
      Eigen::numext::swap(permutation.indices()[nPassive],
                          permutation.indices()[alpha_idx]);
    }
  }
  // reshuffle the solution to the original order
  x = x.transpose() * permutation.transpose();  
}


/*
#ifdef __CUDA_ARCH__
__global__
#endif
void matrixMultiplicationKernel(const double* A, double* C);
// #endif // __CUDA_ARCH__


#ifdef __CUDA_ARCH__
__global__ void matrixMultiplicationKernel(const double* A, double* C) {

  int x = blockIdx.y*blockDim.y+threadIdx.y;
  int y = blockIdx.x*blockDim.x+threadIdx.x;
  // printf("x %d y %d\n",x, y);
  // printf("%f ", C[y * MATRIX_SIZE + x] );
  C[y * MATRIX_SIZE + x] = 0.;
  // printf("%f ", C[y * MATRIX_SIZE + x] );
  // for (int i = 0; i < MATRIX_SIZE; i++) {
    // printf("B[%d][%d]= \n",y,x);
    // C[y * MATRIX_SIZE + x] += 
        // A[y * MATRIX_SIZE + i] * A[x * MATRIX_SIZE + i];
        // printf("A[%d][%d]*A[%d][%d]\n",y, i, x, i);
      // }
  // __syncthreads();
  // C->data()[ROW * MATRIX_SIZE + y] = C->data()[y * MATRIX_SIZE + ROW];
}

__device__
void matrixMultiplication(const FixedMatrix &A, FixedMatrix &result){
  // declare the number of blocks per grid and the number of threads per block
  // use 1 to 512 threads per block
  // dim3 threadsPerBlock(1, 1);
  dim3 threadsPerBlock(MATRIX_SIZE, MATRIX_SIZE);
  dim3 blocksPerGrid(1, 1);
  // for(auto i = 0; i < MATRIX_SIZE; ++i){
    // for(auto j = 0; j < MATRIX_SIZE; ++j)
      // result(i,j) = 0.;
  // }
  matrixMultiplicationKernel<<<blocksPerGrid,threadsPerBlock>>>(A.data(), result.data());
}

#endif

*/