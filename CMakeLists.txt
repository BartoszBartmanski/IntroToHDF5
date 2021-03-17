cmake_minimum_required(VERSION 2.8.12)

# define a project name
project(example)

# enforce the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# find HDF5
find_package(HDF5 COMPONENTS CXX REQUIRED)
include_directories(${HDF5_INCLUDE_DIRS})

add_executable(write_data write_data.cpp)
target_link_libraries(write_data ${HDF5_LIBS} ${HDF5_LIBRARIES})
