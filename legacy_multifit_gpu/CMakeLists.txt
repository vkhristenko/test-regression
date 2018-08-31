message("compiling legacy multifit gpu")

file(GLOB CUSOURCES src/*.cu)
add_library(legacy_multifit_gpu_device STATIC
    ${CUSOURCES})
#set_target_properties(legacy_multifit_gpu_device PROPERTIES POSITION_INDEPENDENT_CODE ON)
target_compile_options(legacy_multifit_gpu_device PRIVATE ${CUDA_FLAGS})
set_target_properties(legacy_multifit_gpu_device PROPERTIES CUDA_SEPARABLE_COMPILATION ON)


add_executable(legacy_multifit_gpu src/multifit.cpp)
target_link_libraries(legacy_multifit_gpu ${ROOT_LIBRARIES} ${CUDA_LIBRARIES} legacy_multifit_gpu_device)
