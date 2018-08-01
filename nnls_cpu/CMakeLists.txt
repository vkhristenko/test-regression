add_executable(nnls_cpu src/nnls.cpp src/fnnls.cpp src/main.cpp)
target_link_libraries(nnls_cpu io ${ROOT_LIBRARIES})

add_executable(test_io src/test_io.cpp)
target_link_libraries(test_io io ${ROOT_LIBRARIES})
