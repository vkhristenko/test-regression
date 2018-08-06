#include "../interface/vector.h"
#include "../interface/test.h"

__global__ void test(){
  for(int i = 0; i<100; ++i){
    int j = 0;
    while(j++ < 100){
      vector<unsigned int> tmp;
      
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
      tmp.push_back(1);
    }
  }
}