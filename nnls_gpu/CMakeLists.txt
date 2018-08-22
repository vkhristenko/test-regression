if (CUDA_FOUND)
    file(GLOB CUSOURCES src/*.cu)
    # set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} --expt-relaxed-constexpr")
    cuda_add_library(nnls_gpu_kernels ${CUSOURCES})
    target_link_libraries(multifit_gpu_kernels)
endif()

add_library(nnls_gpu STATIC ${CUSOURCES})
target_link_libraries(nnls_gpu ${CUDA_LIBRARIES} io nnls_cpu nnls_gpu_kernels)
