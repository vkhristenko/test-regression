file (GLOB SOURCES src/*.cpp)
add_library(io SHARED ${SOURCES})
target_link_libraries(io ${ROOT_LIBRARIES})
