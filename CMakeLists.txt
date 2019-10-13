cmake_minimum_required(VERSION 3.8)
project(imgui-osg C CXX)

# Fetch and create imgui target
include(${CMAKE_CURRENT_LIST_DIR}/cmake/CreateImGuiTarget.cmake)
CreateImGuiTarget(
    LOADER Glew
    IMPLEMENTATION OpenGL3
    REPOSITORY https://github.com/ocornut/imgui.git
    TAG origin/master
)

# Prerequisites:
find_package(OpenSceneGraph REQUIRED COMPONENTS osgViewer osgGA)

add_subdirectory(src)
