#include "../interface/kernel_wrapper.h"
#include "../interface/fnnls.h"
// #include "../interface/kernels.h"

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
