#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>

#include <boost/program_options.hpp>

#include "multifit_ocl/include/cl_pretty_print.hpp"
#include "multifit_ocl/include/utils.hpp"

#define NUM_CHANNELS 1000
#define NUM_SAMPLES 10

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

std::string get_source(std::string const& source_file_name) {   
    std::ifstream is {source_file_name.c_str()};
    if (!is.is_open()) {
        std::cout << "can not open a source file" << std::endl;
        exit(1);
    }

    return std::string{std::istreambuf_iterator<char>(is),
                       std::istreambuf_iterator<char>()};
}

int main(int argc, char **argv ) {
    //
    // use boost to parse the cli args
    //
    namespace po = boost::program_options;
    po::options_description desc{"allowed program options"};
    std::string intel {"Intel"};
    bool compile_only = true;
    bool dump_source = false;
    desc.add_options()
        ("help", "produce help msgs")
        ("device-type", po::value<std::string>(), "a device type: ['cpu' | 'gpu' | 'fpga']")
        ("manufacturer", po::value<std::string>(&intel)->default_value("Intel"), "manufacturer of the device: ['Intel', 'Nvidia']")
        ("compile-only", po::value<bool>(&compile_only)->default_value(true), "if true (default) should just compile and print the compilation log")
        ("dump-source", po::value<bool>(&dump_source)->default_value(false), "if should dump the opencl source code to standard output")
    ;
    po::variables_map vm;
    po::store(po::parse_command_line(argc, argv, desc), vm);
    if (vm.count("help") || argc<2) {
        std::cout << desc << std::endl;
        return 0;
    }

    auto device_type_name = vm["device-type"].as<std::string>();
    auto manufac_name = vm["manufacturer"].as<std::string>();

    /*
    std::vector<std::string> args;
    try {
        args = parse_args(argc, argv);
    } catch (bad_args &e) {
        std::cout << "bad cli rguments" << std::endl;
        exit(1);
    }
    */

    // predefine several conversions
    std::map<std::string, int> typename_to_type {
        {"fpga", CL_DEVICE_TYPE_ACCELERATOR},
        {"gpu", CL_DEVICE_TYPE_GPU},
        {"cpu", CL_DEVICE_TYPE_CPU}
    };
    std::map<std::string, std::vector<std::string>> typename_to_producer {
        {"fpga", {"intel"}},
        {"gpu", {"intel", "nvidia"}}
    };

    // get all platforms and print out debug info
    std::vector<cl::Platform> platforms;
    cl::Platform::get(&platforms);
    clapi::pretty_print_all(platforms, std::cout, "\t\t");
    std::cout << std::endl;
    
    // for now just use hte only platform
    auto &p = platforms[0];

    // select the right device
    auto dtype_to_use = typename_to_type[device_type_name];
    std::vector<cl::Device> devices;
    p.getDevices(dtype_to_use, &devices);
    cl::Device const* ptr_d = nullptr;
    if (devices.size() > 1) {
        for (auto const& device : devices ) {
            for (auto const& p : typename_to_producer[manufac_name]) {
                if (clapi::get_device_name(device).find(p) != std::string::npos) 
                    ptr_d = &device;
            }
        }
    } else if (devices.size() == 1){
        ptr_d = &devices[0];
    } else {
        std::cout << "no devices of type " << device_type_name << std::endl;
        exit(1);
    }
    auto &d = *ptr_d;
    
    // create a context
    cl::Context ctx {devices};

    // prepare the input data
    // TODO: need to properly initialize matrices and vectors
    // for now just resize -> default init
    std::vector<float> h_vA; h_vA.resize(NUM_SAMPLES * NUM_SAMPLES * NUM_CHANNELS);
    std::vector<float> h_vb; h_vb.resize(NUM_SAMPLES * NUM_CHANNELS);
    std::vector<float> h_vx; h_vx.resize(NUM_SAMPLES * NUM_CHANNELS);
    float const epsilon = 1e-11;
    unsigned int const max_iterations = 1000;
    /*
    for (std::size_t i=0; i<NUM_CHANNELS; ++i) {
        for (std::size_t j=0; j<NUM_SAMPLES; ++j) {
            for (std::size_t k=0; k<NUM_SAMPLES; ++k) {
                h_vA.push_back(j+k);
            }
            h_vb.push_back(k);
        }
    }*/

    // need to compile the device side or load an image
    int error = 0;
    cl::Program program;
    if (dtype_to_use == CL_DEVICE_TYPE_ACCELERATOR) {
        std::string binary_file {"vector_add.aocx"};
        auto bin = get_binary(binary_file);
        std::cout << "got a binary image of size " << bin.size() << std::endl;
#if !defined(CL_HPP_ENABLE_PROGRAM_CONSTRUCTION_FROM_ARRAY_COMPATIBILITY)
        program = cl::Program{ctx, devices, {bin}};
#else
        program = cl::Program{ctx, devices, {bin.data(), bin.size()}};
#endif
    } else {
        // for now hardcode this guy
        // should be obtained somehow, env?
        std::string path_to_source_file = "/Users/vk/software/test-regression/multifit_ocl/device";
        std::string source_file {path_to_source_file + "/" + "regression_inplace_fnnls.cl"};
        auto source = get_source(source_file);
        std::cout << "got a source file: " << source.size() << " Bytes in total"<< std::endl;
        if (dump_source) {
            std::cout << "--- source start ---" << std::endl;
            std::cout << source << std::endl;
            std::cout << "--- source end ---" << std::endl;
        }
#if !defined(CL_HPP_ENABLE_PROGRAM_CONSTRUCTION_FROM_ARRAY_COMPATIBILITY)
        program = cl::Program{ctx, source};
#else
        program = cl::Program{ctx, source};
#endif
    }

    int status;
    try {
        status = program.build(devices);
    } catch (cl::BuildError &err) {
        std::cout << "build error: " << err.what() << std::endl;
        auto log = err.getBuildLog();
        for (auto const& p : log) 
            std::cout << "log:\n"
                      << "-----------------------------------\n"
                      << p.second << "\n"
                      << "-----------------------------------\n"
                      << std::endl;
        exit(1);
    }
    if (status != CL_SUCCESS) {
        std::cout << "error building" << std::endl;
        std::cout << program.getBuildInfo<CL_PROGRAM_BUILD_LOG>(d) << std::endl;
        exit(1);
    }
    std::cout << program.getBuildInfo<CL_PROGRAM_BUILD_LOG>(d) << std::endl;
    std::cout << "a program has been built" << std::endl;

    if (compile_only) {
        std::cout << "compile only mode. set --compile-only=false to actually run" << std::endl;
        return 0;
    }

    // a queue
    std::cout << "initialize a command queue" << std::endl;
    cl::CommandQueue queue{ctx, d};

    // create a kernel functor
//    auto k_vector_add = cl::Kernel{program, "vector_add"};
    std::cout << "create a kernel wrapper" << std::endl;
    auto status_kernel = 0;
    auto k_fnnls = cl::compatibility::make_kernel<cl::Buffer, cl::Buffer, cl::Buffer, float, unsigned int>(
        program, "inplace_fnlls_facade", &status_kernel);
    if (status_kernel != CL_SUCCESS) {
        std::cout << "failed creating a 'make_kernel' wrapper " << std::endl;
        exit(1);
    }

    // link host's memory to device buffers
    std::cout << "create buffers" << std::endl;
    cl::Buffer d_vA, d_vb, d_vx;
    d_vA = cl::Buffer{ctx, CL_MEM_READ_ONLY, h_vA.size() * sizeof(float)};
    d_vb = cl::Buffer{ctx, CL_MEM_READ_ONLY, h_vb.size() * sizeof(float)};
    d_vx = cl::Buffer{ctx, CL_MEM_WRITE_ONLY, sizeof(float) * h_vb.size()};

    // explicit transfer
    queue.enqueueWriteBuffer(d_vA, CL_TRUE, 0, h_vA.size() * sizeof(float), h_vA.data());
    queue.enqueueWriteBuffer(d_vb, CL_TRUE, 0, h_vb.size() * sizeof(float), h_vb.data());

    std::cout << "launch the kernel" << std::endl;
    int const count = NUM_CHANNELS;
    auto event = k_fnnls(cl::EnqueueArgs{queue, cl::NDRange(count)},
         d_vA, d_vb, d_vx, epsilon, max_iterations);
    if (status_kernel != CL_SUCCESS) {
        std::cout << "problem with launching a kernel" << std::endl;
        exit(1);
    }
    event.wait();

    std::cout << "copy the data back to the host" << std::endl;
    cl::copy(queue, d_vx, std::begin(h_vx), std::end(h_vx));
//    queue.enqueueReadBuffer(d_c, CL_TRUE, 0, h_a.size() * sizeof(float), h_c.data());
    queue.finish();

    std::cout << "validate against the reference" << std::endl;
    bool all_good = true;
    /*
    for (int i=0; i<SIZE; ++i) {
        all_good &= (h_c[i] == i+i+i);
#ifdef DEBUG
        if (i % 1000 == 0)
            std::cout << "array[ " << i << " ] = " << h_c[i] << std::endl;
#endif
    }*/
    if (all_good)
        std::cout << "PASS TEST" << std::endl;
    else 
        std::cout << "FAILED TEST" << std::endl;

    return 0;
}