#include "nnls/interface/kernel_wrapper.h"
#include "nnls/interface/fnnls.h"
#include "nnls/interface/inplace_fnnls.h"

#include <iostream>
#include <string>

using namespace std;

void assert_if_error(std::string const& name) {
  auto check = [&name](auto code) {
    if (code != cudaSuccess) {
      std::cout << cudaGetErrorString(code) << ' ';
      std::cout << "in " << name << std::endl;
      assert(false);
    }
  };

  check(cudaGetLastError());
}

std::vector<FixedVector> fnnls_wrapper(std::vector<NNLS_args> const& args,
                                       double eps,
                                       unsigned int max_iterations) {
  // host solution vector
  std::vector<FixedVector> x(args.size());

  // device pointers
  NNLS_args* d_args;
  FixedVector* d_x;

  // arguments allocation
  cudaMalloc((void**)&d_args, sizeof(NNLS_args) * args.size());
  // results allocation
  cudaMalloc((void**)&d_x, sizeof(FixedVector) * args.size());

  // arguments copy
  cudaMemcpy(d_args, args.data(), sizeof(NNLS_args) * args.size(),
             cudaMemcpyHostToDevice);

  printf("launch kernel fnnls\n");
  int nthreadsPerBlock = 256;
  int nblocks = (args.size() + nthreadsPerBlock - 1) / nthreadsPerBlock;
  fnnls_kernel<<<nblocks, nthreadsPerBlock>>>(d_args, d_x, args.size(), eps,
                                              max_iterations);
  // fnnls_kernel<<<1,1>>>(d_args, d_x, args.size(), eps, max_iterations);
  cudaDeviceSynchronize();
  assert_if_error("fnnls");
  printf("finish kernel fnnls\n");

  // copy the results back from the device
  cudaMemcpy(x.data(), d_x, sizeof(FixedVector) * args.size(),
             cudaMemcpyDeviceToHost);

  // clear and exit
  cudaFree(d_args);
  cudaFree(d_x);

  // for(const auto& result: x){
  // cout << "x" << endl;
  // cout << result.transpose() << endl;
  // break;
  // }

  return x;
}

__global__ void inplace_fnnls_kernel(NNLS_args* args,
                                   FixedVector* x,
                                      unsigned int n,
                                      double eps,
                              unsigned int max_iterations) {
   // thread idx
   // printf("hello nnls\n");
   int i = blockIdx.x * blockDim.x + threadIdx.x;
   // printf("thread index %i n %i\n", i,n);
   if (i >= n)
         return;
    // printf("thread index %i n %i\n", i,n);
     
    auto& A = args[i].A;
    auto& b = args[i].b;
     
    // printf("inside the kernel\n");
    // print_fixed_matrix(A);
    // print_fixed_vector(b);
    inplace_fnnls(A, b, x[i], eps, max_iterations);
}

__global__ void fnnls_kernel(NNLS_args* args,
                                      FixedVector* x,
                                      unsigned int n,
                                      double eps,
                                      unsigned int max_iterations) {
    // thread idx
    // printf("hello nnls\n");
   int i = blockIdx.x * blockDim.x + threadIdx.x;
   // printf("thread index %i n %i\n", i,n);
   if (i >= n)
         return;
    // printf("thread index %i n %i\n", i,n);
     
    auto& A = args[i].A;
    auto& b = args[i].b;
     
    // printf("inside the kernel\n");
    // print_fixed_matrix(A);
    // print_fixed_vector(b);
    fnnls(A, b, x[i], eps, max_iterations);
}
