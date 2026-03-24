cmake_minimum_required(VERSION 3.22.1)
project("flutterclaw")

add_library(ptyhelper SHARED src/main/cpp/pty_helper.cpp)

find_library(log-lib log)

target_link_libraries(ptyhelper ${log-lib})
