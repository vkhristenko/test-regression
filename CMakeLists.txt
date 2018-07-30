<<<<<<< HEAD
cmake_minimum_required(VERSION 3.8.0)

set(CMAKE_VERBOSE_MAKEFILE OFF)

# project name
project(test-regression)

set(CMAKE_BUILD_TYPE "Debug")

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++17 -O2")

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules ${CMAKE_MODULE_PATH})

if (DEBUG)
    add_definitions(-DDEBUG)
endif()

# cuda
find_package(CUDA)
if (CUDA_FOUND)
    add_definitions(-DUSE_CUDA)
    include_directories(${CUDA_INCLUDE_DIRS} SYSTEM)
    cuda_include_directories(${CUDA_INCLUDE_DIRS})
    set(CUDA_NVCC_FLAGS_DEBUG "${CUDA_NVCC_FLAGS}")
    set (CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -Xptxas -O2,-v" )
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


find_package(OpenCL REQUIRED)
if (OpenCL_FOUND)
    if (TURNOFF_OPENCL)
    else()
        add_subdirectory(multifit_ocl)
    endif()
endif()
=======
cmake_minimum_required(VERSION 3.8.0)

set(CMAKE_VERBOSE_MAKEFILE OFF)

# project name
project(test-regression)

set(CMAKE_BUILD_TYPE "Debug")

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++17 -O2")

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules ${CMAKE_MODULE_PATH})

if (DEBUG)
    message("DEBUG MODE")
    add_definitions(-DDEBUG)
    add_definitions(-DDEBUG_FNNLS_GPU)
endif()

# cuda
find_package(CUDA)
if (CUDA_FOUND)
    add_definitions(-DUSE_CUDA)
    include_directories(${CUDA_INCLUDE_DIRS} SYSTEM)
    cuda_include_directories(${CUDA_INCLUDE_DIRS})
    set(CUDA_NVCC_FLAGS_DEBUG "${CUDA_NVCC_FLAGS}")
    set (CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -Xptxas -O2,-v" )
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


find_package(OpenCL REQUIRED)
if (OpenCL_FOUND)
    if (TURNOFF_OPENCL)
    else()
        add_subdirectory(multifit_ocl)
    endif()
endif()
>>>>>>> 1fe75fe0ee2cd62b77e16585bfac250a6fc12b87
