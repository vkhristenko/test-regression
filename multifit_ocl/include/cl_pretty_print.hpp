#ifndef cl_pretty_print_h
#define cl_pretty_print_h

#include <string>
#include <ostream>
#include <iostream>

//#if __APPLE__
#define CL_HPP_ENABLE_EXCEPTIONS
#define CL_HPP_TARGET_OPENCL_VERSION 110
#define CL_HPP_MINIMUM_OPENCL_VERSION 110
#include "multifit_ocl/include/cl2.hpp"
//#else
//    #include "CL/cl.hpp"
//#endif

namespace clapi {

void pretty_print_all(std::vector<cl::Platform> const&, std::ostream&, std::string const&);
void pretty_print_cl_platform(cl::Platform const&, std::ostream& os = std::cout);
void pretty_print_cl_device(cl::Device const&, 
    std::ostream& os = std::cout, std::string const& indent = "\t\t");

}

#endif // cl_pretty_print_h
