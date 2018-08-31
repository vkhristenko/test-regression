message(CUDA_NVCC_FLAGS = ${CUDA_NVCC_FLAGS})
 
file (GLOB SOURCES src/*.cpp)
file (GLOB CUSOURCES src/*.cu)

add_library(nnls_device STATIC 
    ${CUSOURCES})
target_compile_options(nnls_device PRIVATE ${CUDA_FLAGS})
set_target_properties(nnls_device PROPERTIES CUDA_SEPARABLE_COMPILATION ON)

add_library(nnls STATIC ${SOURCES})
target_link_libraries(nnls nnls_device ${CUDA_LIBRARIES})

