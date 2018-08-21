#include <vector>
#include "../interface/data_types.h"

#ifndef KERNEL_WRAPPER_H
#define KERNEL_WRAPPER_H

std::vector<FixedVector> fnnls_wrapper(
    std::vector<NNLS_args> const& args,
    const double eps = 1e-11,
    const unsigned int max_iterations = 1000);

#endif