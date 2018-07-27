if (CUDA_FOUND)
    file(GLOB CUSOURCES src/*.cu)
    set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} --expt-relaxed-constexpr")
    cuda_add_library(nnls_gpu_kernels ${CUSOURCES})
    target_link_libraries(multifit_gpu_kernels)
endif()

add_executable(nnls_gpu src/nnls.cu src/fnnls.cu src/kernel_wrapper.cu src/main.cpp)
target_link_libraries(nnls_gpu  ${CUDA_LIBRARIES} nnls_gpu_kernels)
