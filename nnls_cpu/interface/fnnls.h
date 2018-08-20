#include "data_types.h" 



#ifndef FNNLS_H
#define FNNLS_H


void fnnls(const FixedMatrix &A, 
                  const FixedVector &b, 
                  FixedVector& x,
                  const double eps=1e-11, 
                  const unsigned int max_iterations=1000
                  );


#endif