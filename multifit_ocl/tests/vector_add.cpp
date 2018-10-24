#include <iostream>

#include "multifit_ocl/include/cl_pretty_print.hpp"

#define SIZE 1000 * 1000

std::vector<unsigned char> get_binary(std::string const& binary_file_name) {
    auto *fp = fopen(binary_file_name.c_str(), "rb");
    fseek(fp, 0, SEEK_END);
    std::size_t size = ftell(fp);
    std::vector<unsigned char> buffer; buffer.resize(size);
    rewind(fp);
    fread(buffer.data(), size, 1, fp);
    fclose(fp);

    return buffer;
}

int main(int argc, char **argv ) {
    // get all platforms and print out debug info
    std::vector<cl::Platform> platforms;
    cl::Platform::get(&platforms);
    clapi::pretty_print_all(platforms, std::cout, "\t\t");
    std::cout << std::endl;
    
    // for now just use hte only platform
    auto &p = platforms[0];

    // for now just use the 0 device for type 8 (should be the accelerator one)
    std::vector<cl::Device> devices;
    p.getDevices(8, &devices);
    auto &d = devices[0];
    
    // create a context
    cl::Context ctx {devices};

    // prepare the input data
    std::vector<float> h_a; h_a.reserve(SIZE);
    std::vector<float> h_b; h_b.reserve(SIZE);
    std::vector<float> h_c; h_c.resize(SIZE);
    for (std::size_t i=0; i<SIZE; ++i) {
        h_a.push_back(i);
        h_b.push_back(i+i);
    }

    // need to load an image
    int error = 0;
    std::string binary_file {"vector_add.aocx"};
    auto bin = get_binary(binary_file);
    std::cout << "got a binary image of size " << bin.size() << std::endl;
#if !defined(CL_HPP_ENABLE_PROGRAM_CONSTRUCTION_FROM_ARRAY_COMPATIBILITY)
    cl::Program program{ctx, devices, {bin}};
#else
    cl::Program program{ctx, devices, {bin.data(), bin.size()}};
#endif
    auto status = program.build(devices);
    if (status != CL_SUCCESS) {
        std::cout << "error building" << std::endl;
        std::cout << program.getBuildInfo<CL_PROGRAM_BUILD_LOG>(d) << std::endl;
        exit(1);
    }
    std::cout << program.getBuildInfo<CL_PROGRAM_BUILD_LOG>(d) << std::endl;
    std::cout << "a program has been built for devices" << std::endl;

    // a queue
    std::cout << "initialize a command queue" << std::endl;
    cl::CommandQueue queue{ctx, d};

    // create a kernel functor
//    auto k_vector_add = cl::Kernel{program, "vector_add"};
    std::cout << "create a kernel wrapper" << std::endl;
    auto status_kernel = 0;
    auto k_vector_add = cl::compatibility::make_kernel<cl::Buffer, cl::Buffer, cl::Buffer>(program, "vector_add", 
        &status_kernel);
    if (status_kernel != CL_SUCCESS) {
        std::cout << "failed creating a 'make_kernel' wrapper " << std::endl;
        exit(1);
    }

    // link host's memory to device buffers
    std::cout << "create buffers" << std::endl;
    cl::Buffer d_a, d_b, d_c;
    d_a = cl::Buffer{ctx, CL_MEM_READ_ONLY, h_a.size() * sizeof(float)};
    d_b = cl::Buffer{ctx, CL_MEM_READ_ONLY, h_b.size() * sizeof(float)};
    d_c = cl::Buffer{ctx, CL_MEM_WRITE_ONLY, sizeof(float) * SIZE};

    queue.enqueueWriteBuffer(d_a, CL_TRUE, 0, h_a.size() * sizeof(float), h_a.data());
    queue.enqueueWriteBuffer(d_b, CL_TRUE, 0, h_b.size() * sizeof(float), h_b.data());

    std::cout << "launch the kernel" << std::endl;
    int const count = SIZE;
    auto event = k_vector_add(cl::EnqueueArgs{queue, cl::NDRange(count)},
         d_a, d_b, d_c);
    if (status_kernel != CL_SUCCESS) {
        std::cout << "problem with launching a kernel" << std::endl;
        exit(1);
    }
    event.wait();

    std::cout << "copy the data back to the host" << std::endl;
    cl::copy(queue, d_c, std::begin(h_c), std::end(h_c));
//    queue.enqueueReadBuffer(d_c, CL_TRUE, 0, h_a.size() * sizeof(float), h_c.data());
    queue.finish();

    std::cout << "validate against the reference" << std::endl;
    bool all_good = true;
    for (int i=0; i<SIZE; ++i) {
        all_good &= (h_c[i] == i+i+i);
    }
    if (all_good)
        std::cout << "PASS TEST" << std::endl;
    else 
        std::cout << "FAILED TEST" << std::endl;

    return 0;
}
