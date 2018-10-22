// Copyright (C) 2013-2018 Altera Corporation, San Jose, California, USA. All rights reserved.
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
// whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// 
// This agreement shall be governed in all respects by the laws of the State of California and
// by the laws of the United States of America.

///////////////////////////////////////////////////////////////////////////////////
// This host program executes a matrix multiplication kernel to perform:
//  C = A * B
// where A is a N x K matrix, B is a K x M matrix and C is a N x M matrix.
// All dimensions must be a multiple of BLOCK_SIZE, which affects the
// underlying kernel.
//
// This host program supports partitioning the problem across multiple OpenCL
// devices if available. If there are M available devices, the problem is
// divided so that each device operates on N/M rows (with
// processed by each device is . The host program
// assumes that all devices are of the same type (that is, the same binary can
// be used), but the code can be generalized to support different device types
// easily.
//
// Verification is performed against the same computation on the host CPU.
///////////////////////////////////////////////////////////////////////////////////

#define CL_HPP_ENABLE_EXCEPTIONS
#define CL_HPP_TARGET_OPENCL_VERSION 120
#define CL_HPP_MINIMUM_OPENCL_VERSION 120
#include "multifit_ocl/include/cl2.hpp"

#include <iostream>
using namespace std;

#define print_info_option(device, option, mod) \
    std::cout << mod #option " = " << device.getInfo<option>() << "\n"

#define print_pretty(expr, mod) \
    std::cout << mod #expr " = " << expr << "\n"

// Entry point.
int main(int argc, char **argv) {
	vector<cl::Platform> platforms;
	cl::Platform::get(&platforms);	

	for (auto &platform : platforms){
		cout << "Platform:" << platform.getInfo<CL_PLATFORM_NAME>() << endl;
		cout << "Profile:" << platform.getInfo<CL_PLATFORM_PROFILE>() << endl;
		cout << "Version:" << platform.getInfo<CL_PLATFORM_VERSION>() << endl;
		cout << "Extensions:" << platform.getInfo<CL_PLATFORM_EXTENSIONS>() << endl;
        std::vector<cl::Device> devices;
        platform.getDevices(CL_DEVICE_TYPE_ALL, &devices);

        // print out all devices
        std::cout << "Number of devices: " << devices.size() << std::endl;
        int idevice = 0;
        std::cout << "--------------------------" << std::endl;
        for (auto const& d : devices) {
            std::cout << "Device " << idevice << std::endl;
            print_info_option(d, CL_DEVICE_NAME, "\t\t");
            print_info_option(d, CL_DEVICE_OPENCL_C_VERSION, "\t\t");
            print_info_option(d, CL_DEVICE_MAX_COMPUTE_UNITS, "\t\t");
            print_info_option(d, CL_DEVICE_LOCAL_MEM_SIZE, "\t\t");
            print_info_option(d, CL_DEVICE_GLOBAL_MEM_SIZE, "\t\t");
            print_info_option(d, CL_DEVICE_MAX_MEM_ALLOC_SIZE, "\t\t");
            print_info_option(d, CL_DEVICE_MAX_WORK_GROUP_SIZE, "\t\t");

            //std::vector<std::size_t> work_item_sizes;
            auto work_item_sizes = d.getInfo<CL_DEVICE_MAX_WORK_ITEM_SIZES>();
            std::cout << "\t\tmax work group sizes:\n";
            for (auto const& ws : work_item_sizes)
                print_pretty(ws, "\t\t\t");
        
            std::cout << "--------------------------" << std::endl;
            ++idevice;
        }
	}

  cout << endl;
  return 0;
}
