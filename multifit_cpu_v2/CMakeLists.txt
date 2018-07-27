add_executable(multifit_cpu_v2 src/multifit.cpp src/PulseChiSqSNNLS.cpp)
target_link_libraries(multifit_cpu_v2 ${ROOT_LIBRARIES})
