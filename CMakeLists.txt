cmake_minimum_required(VERSION 3.8.0)

set(CMAKE_VERBOSE_MAKEFILE ON)
# set(CMAKE_RULE_MESSAGES OFF)

# project name
project(test-regression)

if(NOT DEBUG)
set(CMAKE_BUILD_TYPE "Release")
endif()

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++17")

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules ${CMAKE_MODULE_PATH})

if (DEBUG)
    message("DEBUG MODE")
    add_definitions(-DDEBUG)
    set(CMAKE_BUILD_TYPE "Debug")
    # add_definitions(-DDEBUG_FNNLS_GPU)
    # add_definitions(-DDEBUG_NNLS_GPU)
    # add_definitions(-DDEBUG_NNLS_CPU)
endif()

# cuda
find_package(CUDA)
if (CUDA_FOUND)
    add_definitions(-DUSE_CUDA)
    include_directories(${CUDA_INCLUDE_DIRS} SYSTEM)
    cuda_include_directories(${CUDA_INCLUDE_DIRS})
    if(DEBUG)
        # set(CUDA_NVCC_FLAGS_DEBUG "${CUDA_NVCC_FLAGS_DEBUG} -DDEBUG_FNNLS_GPU")
        # set(CUDA_NVCC_FLAGS_DEBUG "${CUDA_NVCC_FLAGS_DEBUG} -DDEBUG_NNLS_GPU")
        set(CUDA_NVCC_FLAGS_DEBUG "${CUDA_NVCC_FLAGS_DEBUG} -G -g")
        # set(CUDA_NVCC_FLAGS_DEBUG "${CUDA_NVCC_FLAGS_DEBUG} -Xcompiler -rdynamic -lineinfo ")
    endif()
    set (CUDA_NVCC_FLAGS_RELEASE "${CUDA_NVCC_FLAGS_RELEASE} -Xptxas -O2,-v" )
endif()
find_package(NVVM)

# root
find_package(ROOT REQUIRED)
add_definitions(${ROOT_CXX_FLAGS})
include_directories("${ROOT_INCLUDE_DIRS}")

# eigen
message (EIGEN_HOME = ${EIGEN_HOME})
include_directories(${EIGEN_HOME})
if (CUDA_FOUND)
    cuda_include_directories(${EIGEN_HOME})
endif()

# thust

message(THRUST_HOME = ${THRUST_HOME})
include_directories(${THRUST_HOME})

message (COMPILER = ${CMAKE_CXX_COMPILER})
# always follow the source tree for inclusions ( a la cmssw)
include_directories(${PROJECT_SOURCE_DIR})

if (CUDA_FOUND)
    if (TURNOFF_CUDA)
    else()
        add_subdirectory(multifit_gpu)
        add_subdirectory(nnls_gpu)
    endif()
endif()
add_subdirectory(gen)
add_subdirectory(multifit_cpu)
add_subdirectory(multifit_cpu_v2)
add_subdirectory(nnls_cpu)
add_subdirectory(test_nnls_cpu)
add_subdirectory(io)

find_package(OpenCL REQUIRED)
if (OpenCL_FOUND)
    if (TURNOFF_OPENCL)
    else()
        add_subdirectory(multifit_ocl)
    endif()
endif()
