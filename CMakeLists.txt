cmake_minimum_required(VERSION 2.8.12)

# define a project name
project(example)

# enforce the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_subdirectory(HighFive)

add_executable(test_highfive test_highfive.cpp)
target_link_libraries(test_highfive HighFive)
