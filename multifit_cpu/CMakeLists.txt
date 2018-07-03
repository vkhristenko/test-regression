add_executable(multifit src/multifit.cpp src/PulseChiSqSNNLS.cpp)
target_link_libraries(multifit ${ROOT_LIBRARIES})

# cuda
find_package(CUDA)
add_definitions(-DUSE_CUDA)
include_directories(${CUDA_INCLUDE_DIRS} SYSTEM)
cuda_include_directories(${CUDA_INCLUDE_DIRS})
find_package(NVVM)

if (CUDA_FOUND)
    message(CUDA_FOUND)
    cuda_include_directories(${EIGEN_HOME})
    set(CMAKE_CXX_COMPILER "nvcc")
endif()
