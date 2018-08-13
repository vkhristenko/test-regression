#include "data_types.h" 


#include <iostream>

#ifndef FNNLS_H
#define FNNLS_H

// template <typename T, typename T2>
// Eigen::Matrix<typename T2::Scalar,T::RowsAtCompileTime,T::ColsAtCompileTime,T::Options> 
// sub_vector(const Eigen::DenseBase<T2>& full, const Eigen::DenseBase<T>& ind)
// {
//     using target_t = Eigen::Matrix < T2::Scalar, T::RowsAtCompileTime, T::ColsAtCompileTime, T::Options > ;
//     int num_indices = ind.innerSize();
//     target_t target(num_indices);
//     for (int i = 0; i < num_indices; i++)
//     {
//         target[i] = full[ind[i]];
//     }
//     return target;
// } 



void fnnls(const FixedMatrix &A, 
                  const FixedVector &b, 
                  FixedVector& x,
                  const double eps=1e-11, 
                  const unsigned int max_iterations=1000
                  );


#endif