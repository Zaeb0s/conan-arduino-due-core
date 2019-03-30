cmake_minimum_required(VERSION 2.8.12)

project(PackageTest CXX)

set(CMAKE_VERBOSE_MAKEFILE ON)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

add_executable(example example.cpp)
target_link_libraries(example ${CONAN_LIBS})

_generate_object(example)
_firmware_size(example)