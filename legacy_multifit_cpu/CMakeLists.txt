add_executable(legacy_multifit_cpu src/multifit.cpp src/PulseChiSqSNNLS.cpp)
target_link_libraries(legacy_multifit_cpu ${ROOT_LIBRARIES})
