#set(CMAKE_BUILD_TYPE=Debug)
# add_definitions(-DUSE_SVM_API=1 -fpermissive)

# for debug purposes
message(CMAKE_MODULE_PATH = ${CMAKE_MODULE_PATH})
message(CMAKE_PREFIX_PATH = ${CMAKE_PREFIX_PATH})
message(CMAKE_SOURCE_DIR = ${CMAKE_SOURCE_DIR})
message(CMAKE_BINARY_DIR = ${CMAKE_BINARY_DIR})
message(PROJECT_SOURCE_DIR = ${PROJECT_SOURCE_DIR})
message(PROJECT_BINARY_DIR = ${PROJECT_BINARY_DIR})
message (CMAKE_CXX_COMPILER_VERSION = ${CMAKE_CXX_COMPILER_VERSION})
message (CMAKE_CXX_COMPILER_ID = ${CMAKE_CXX_COMPILER_ID})

message(OpenCL_FOUND = ${OpenCL_FOUND})
message(OpenCL_INCLUDE_DIRS = ${OpenCL_INCLUDE_DIRS})
message(OpenCL_LIBRARIES = ${OpenCL_LIBRARIES})
message(OpenCL_VERSION_STRING = ${OpenCL_VERSION_MAJOR})
message(OpenCL_VERSION_MAJOR = ${OpenCL_VERSION_MAJOR})
message(OpenCL_VERSION_MINOR = ${OpenCL_VERSION_MINOR})

message("-------------------------------------------")
include_directories(SYSTEM ${OpenCL_INCLUDE_DIRS})
include_directories(${OpenCL_INCLUDE_DIRS})

message("-------------------------------------------")
file(GLOB LIBSOURCES src/*.cpp)
file(GLOB TESTSOURCES tests/*.cpp)

# build a lib from src/ sources
add_library(multifit_ocl_lib SHARED ${LIBSOURCES})
target_link_libraries(multifit_ocl_lib ${OpenCL_LIBRARIES})

if (UNIX AND NOT APPLE)
    set (INTEL_LINK_OPTIONS "-L/data/PAC/inteldevstack/intelFPGA_pro/hld/linux64/lib -L/data/vkhriste/opencl_bsp/linux64/lib  -L/data/PAC/inteldevstack/intelFPGA_pro/hld/host/linux64/lib -Wl,--no-as-needed -lalteracl  -lintel_opae_mmd -lrt -lelf")
    message(INTEL_LINK_OPTIONS = ${INTEL_LINK_OPTIONS})
elseif()
    set(INTEL_LINK_OPTIONS)
endif()

message(INTEL_LINK_OPTIONS = ${INTEL_LINK_OPTIONS})

# build tests from tests/ 
foreach(TEST ${TESTSOURCES})
    get_filename_component(EXE ${TEST} NAME_WE)
    message("adding executable ${EXE}")
    add_executable(multifit_ocl_${EXE} ${TEST})
    target_link_libraries(multifit_ocl_${EXE} PRIVATE ${INTEL_LINK_OPTIONS}
        ${OpenCL_LIBRARIES} multifit_ocl_lib ${Boost_LIBRARIES})
endforeach(TEST)
