cmake_minimum_required(VERSION 3.8.0 FATAL_ERROR)

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CUDA_VERBOSE_BUILD ON)

# set(CMAKE_RULE_MESSAGES OFF)

# project name
project(test-regression LANGUAGES CXX)
if (NOT TURNOFF_CUDA)
    enable_language(CUDA)
endif()

if(NOT DEBUG)
    set(CMAKE_BUILD_TYPE "Release")
endif()

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++17")

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules ${CMAKE_MODULE_PATH})

if(PROFILE)
# set(VTune_DIR "/cvmfs/projects.cern.ch/intelsw/psxe/linux/x86_64/2018/vtune_amplifier_2018.3.0.558279/bin64")
    set(CMAKE_CXX_FLAGS "-O2 -g")
    set(CMAKE_CXX_COMPILER "/cvmfs/projects.cern.ch/intelsw/psxe/linux/x86_64/2018/compilers_and_libraries_2018.2.199/linux/bin/intel64/icpc") 
    set(CMAKE_C_COMPILER "/cvmfs/projects.cern.ch/intelsw/psxe/linux/x86_64/2018/compilers_and_libraries_2018.2.199/linux/bin/intel64/icc") 
    set(EIGEN_HOME "/data/user/vkhriste/eigen/eigen")
    add_definitions(-DPROFILE)
endif()


if (DEBUG)
    message("DEBUG MODE")
    add_definitions(-DDEBUG)
    set(CMAKE_BUILD_TYPE "Debug")
endif()

# cuda
if (NOT TURNOFF_CUDA)
    message("*** disabling cuda ***")
elseif()
    message("*** enabling cuda ***")
    find_package(CUDA)
    if (CUDA_FOUND)
        add_definitions(-DUSE_CUDA)
        include_directories(${CUDA_INCLUDE_DIRS})
        cuda_select_nvcc_arch_flags(ARCH_FLAGS 3.5)
        message(ARCH_FLAGS = ${ARCH_FLAGS})
        set(CMAKE_CUDA_FLAGS ${CMAKE_CUDA_FLAGS} -arch=sm_35)
        if(DEBUG)
            set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} -G -g)
        endif(DEBUG)
        # set (CUDA_FLAGS ${CUDA_NVCC_FLAGS} --expt-relaxed-constexpr -Xptxas -v)
        set (CUDA_FLAGS ${CUDA_NVCC_FLAGS} --expt-relaxed-constexpr)
        message(flags = ${ARCH_FLAGS})
    endif()
    find_package(NVVM)
endif()

# root
find_package(ROOT REQUIRED)
message(root flags ${ROOT_CXX_FLAGS})
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ROOT_CXX_FLAGS}")
include_directories("${ROOT_INCLUDE_DIRS}")

# eigen
message (EIGEN_HOME = ${EIGEN_HOME})
include_directories(${EIGEN_HOME})

message (COMPILER = ${CMAKE_CXX_COMPILER})
# always follow the source tree for inclusions ( a la cmssw)
include_directories(${PROJECT_SOURCE_DIR})

if (NOT TURNOFF_CUDA)
elseif()
    if (CUDA_FOUND)
        add_subdirectory(legacy_multifit_gpu)
        add_subdirectory(multifit_gpu)
    endif()
endif()

if (CUDA_FOUND)
    add_subdirectory(nnls)
    add_subdirectory(multifit_cpu)
endif()
add_subdirectory(gen)
add_subdirectory(legacy_multifit_cpu)
add_subdirectory(io)
# add_subdirectory(test_nnls_cpu)

if (NOT TURNOFF_OPENCL)
    find_package(OpenCL)
    if (OpenCL_FOUND)
        add_subdirectory(multifit_ocl)
    endif()
endif()

# if(TESTS)
# add_subdirectory(multifit_cpu_swap)
# add_subdirectory(multifit_gpu_swap)
# endif()
