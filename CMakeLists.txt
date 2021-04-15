cmake_minimum_required(VERSION 2.8.12)

# define a project name
project(test_highfive)

# enforce the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(HIGHFIVE_USE_BOOST OFF)
add_subdirectory(HighFive)

add_executable(highfive_test src/highfive_test.cpp)
target_link_libraries(highfive_test HighFive)
