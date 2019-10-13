# ImGui-OSG
This application shows how to use OpenSceneGraph and Dear ImGui together.
![demo](demo.png)

## Prerequisites
This example requires:
 - OpenSceneGraph
 - GLEW
 - OpenGL

*Note: OpenSceneGraph manages OpenGL extensions in it's own way and the easiest way to make it work with opengl3 implementation provided by ImGui is to use GLEW.*

You may install them using vcpkg on Windows or apt on Ubuntu.

## How to build
```
mkdir build && cd build
cmake ..
cmake --build .
```