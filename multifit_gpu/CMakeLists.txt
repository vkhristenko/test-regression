add_executable(multifit_gpu src/multifit.cpp src/PulseChiSqSNNLS.cpp)
target_link_libraries(multifit_gpu nnls_cpu ${ROOT_LIBRARIES})
