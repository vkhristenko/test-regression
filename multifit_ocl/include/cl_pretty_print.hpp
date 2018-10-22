#ifndef cl_pretty_print_h
#define cl_pretty_print_h

#include <string>
#include <ostream>
#include <iostream>

#define CL_HPP_ENABLE_EXCEPTIONS
#define CL_HPP_TARGET_OPENCL_VERSION 120
#define CL_HPP_MINIMUM_OPENCL_VERSION 120
#include "multifit_ocl/include/cl2.hpp"

namespace clapi {

void pretty_print_all(std::vector<cl::Platform> const&, std::ostream&, std::string const&);
void pretty_print_cl_platform(cl::Platform const&, std::ostream& os = std::cout);
void pretty_print_cl_device(cl::Device const&, 
    std::ostream& os = std::cout, std::string const& indent = "\t\t");

}

#endif // cl_pretty_print_h
