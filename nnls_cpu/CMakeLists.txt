file (GLOB SOURCES src/*.cpp)
add_library(nnls_cpu STATIC ${SOURCES})
# target_link_libraries(io ${ROOT_LIBRARIES})
# target_link_libraries(nnls_cpu)
