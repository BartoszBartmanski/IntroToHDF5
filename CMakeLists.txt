cmake_minimum_required(VERSION 2.8.12)

# define a project name
project(test_highfive)

# enforce the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(HIGHFIVE_USE_BOOST OFF)
add_subdirectory(HighFive)

add_executable(test_highfive src/test_highfive.cpp)
target_link_libraries(test_highfive HighFive)
