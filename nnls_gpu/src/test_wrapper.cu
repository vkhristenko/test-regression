#include "../interface/test_wrapper.h"
#include "../interface/test.h"


#include <iostream>
#include <string>
#include <cassert>

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

void test_wrapper(){
  test<<<40,256>>>();
  assert_if_error("");
}