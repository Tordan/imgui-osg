add_executable(imgui-osg-example
    main.cpp
    OsgImGuiHandler.hpp
    OsgImGuiHandler.cpp
)

target_link_libraries(imgui-osg-example
    PRIVATE
        imgui::imgui
        ${OPENSCENEGRAPH_LIBRARIES}
)

target_include_directories(imgui-osg-example
    PRIVATE
        ${OPENSCENEGRAPH_INCLUDE_DIRS}
)