add_executable(multifit_cpu src/multifit.cpp src/PulseChiSqSNNLS.cpp)
target_link_libraries(multifit_cpu ${ROOT_LIBRARIES})
