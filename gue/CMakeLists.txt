cmake_minimum_required(VERSION 3.10.0)

project(fold)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Eigen3 REQUIRED)
include_directories(${EIGEN3_INCLUDE_DIR})

if (PYTHON)
    find_package(pybind11 CONFIG REQUIRED)
    include_directories(${pybind11_INCLUDE_DIRS})
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I/usr/local/include -DPYTHON -fPIC -O3")
    pybind11_add_module(gue gue.cpp)
endif()

if (CPP)
    add_executable(gue gue.cpp)
endif()
