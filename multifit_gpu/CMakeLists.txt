message("compiling multifit gpu")

# if (CUDA_FOUND)
file(GLOB CUSOURCES src/*.cu)
add_library(multifit_gpu_device STATIC ${CUSOURCES})
target_compile_options(multifit_gpu_device PRIVATE ${CUDA_FLAGS})

set_target_properties(multifit_gpu_device PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
# endif()

file (GLOB SOURCES src/*.cpp)
add_executable(multifit_gpu ${SOURCES})
target_link_libraries(multifit_gpu ${ROOT_LIBRARIES} ${CUDA_LIBRARIES} multifit_gpu_device nnls)
