file (GLOB SOURCES src/*.cpp)

add_library(linalgebra STATIC ${SOURCES})
target_link_libraries(linalgebra)

file (GLOB TESTS tests/*.cpp)
foreach (TEST ${TESTS})
    get_filename_component(EXE ${TEST} NAME_WE)
    list (APPEND EXECS ${EXE})
    add_executable(${EXE} ${TEST})
    target_link_libraries(${EXE} linalgebra)
endforeach(TEST)

