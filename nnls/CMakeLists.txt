#if (CUDA_FOUND)
#    file(GLOB CUSOURCES src/*.cu)
#    set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} --expt-relaxed-constexpr")
#    # set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -x cu")
#    # set(nnls_kernels STATIC)
#    cuda_add_library(nnls_kernels ${CUSOURCES})
#    target_link_libraries(nnls_kernels)
#endif()

# set(VTune_DIR "/cvmfs/projects.cern.ch/intelsw/psxe/linux/x86_64/2018/vtune_amplifier_2018.3.0.558279/bin64")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2 -g")
# set(CMAKE_NVCC_FLAGS "${CMAKE_NVCC_FLAGS} -O2 -g")
 
file (GLOB SOURCES src/*.cpp)
file (GLOB CUSOURCES src/*.cu)

add_library(nnls_device STATIC 
    ${CUSOURCES})
target_compile_options(nnls_device PRIVATE ${CUDA_FLAGS})
set_target_properties(nnls_device PROPERTIES CUDA_SEPARABLE_COMPILATION ON)

add_library(nnls STATIC ${SOURCES})
#set_property(TARGET nnls 
#                 PROPERTY CUDA_SEPARABLE_COMPILATION ON)
#set_property(TARGET nnls PROPERTY CUDA_SEPARABLE_COMPILATION ON)
target_link_libraries(nnls nnls_device ${CUDA_LIBRARIES})

#target_link_libraries(nnls ${CUDA_LIBRARIES})    

#add_library(nnls STATIC ${SOURCES} ${CUSOURCES})
#target_link_libraries(nnls ${CUDA_LIBRARIES} nnls_kernels)    
