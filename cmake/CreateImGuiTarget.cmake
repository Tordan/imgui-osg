# Downloads sources and creates cmake target for Dear ImGui
#
# Dear ImGui is not a cmake project (yet?) so we have to manually
# add it's sources and compile it within our project.
#
# Arguments:
#   REPOSITORY     - git repository to download sources from
#   TAG            - git tag or branch, e.g. origin/master
#   LOADER         - OpenGL extension loader, possible values: glew
#   IMPLEMENTATION - ImGui implementation, check imgui examples dir
#
# Result:
#   Creates target imgui::imgui with all required dependecies. Just
# link it to target and you are good to go!

include(CMakeFindDependencyMacro)
include(FetchContent)
function(CreateImGuiTarget)
    # Define the supported set of keywords
    set(prefix imgui)
    set(noValues)
    set(singleValues LOADER IMPLEMENTATION REPOSITORY TAG)
    set(multiValues)

    # Process the arguments passed in
    include(CMakeParseArguments)
    cmake_parse_arguments(${prefix}
        "${noValues}"
        "${singleValues}"
        "${multiValues}"
        ${ARGN}
    )

    message(STATUS "ImGui LOADER = " ${imgui_LOADER})
    message(STATUS "ImGui IMPLEMENTATION = " ${imgui_IMPLEMENTATION})
    message(STATUS "ImGui REPOSITORY = " ${imgui_REPOSITORY})
    message(STATUS "ImGui TAG = " ${imgui_TAG})

    if(NOT imgui_REPOSITORY OR NOT imgui_TAG)
        message(FATAL_ERROR "Please, specify imgui repository and tag")
    endif()

    string(TOLOWER "${imgui_LOADER}" imgui_LOADER_lower )
    string(TOLOWER "${imgui_IMPLEMENTATION}" imgui_IMPLEMENTATION_lower )

    FetchContent_Declare(imgui
        GIT_REPOSITORY "${imgui_REPOSITORY}"
        GIT_TAG "${imgui_TAG}"
        GIT_SHALLOW YES
    )

    FetchContent_GetProperties(imgui)

    if(NOT imgui_POPULATED)
        FetchContent_Populate(imgui)
    endif()

    # Core ImGui stuff:
    add_library(imgui INTERFACE)
    add_library(imgui::imgui ALIAS imgui)
    target_sources(imgui INTERFACE
        ${imgui_SOURCE_DIR}/imgui.cpp
        ${imgui_SOURCE_DIR}/imgui_demo.cpp
        ${imgui_SOURCE_DIR}/imgui_draw.cpp
        ${imgui_SOURCE_DIR}/imgui_widgets.cpp
    )
    target_include_directories(imgui INTERFACE
        ${imgui_SOURCE_DIR}
        ${imgui_SOURCE_DIR}/examples
    )

    # OpenGL loader
    if(imgui_LOADER_lower STREQUAL "glew")
        find_dependency(GLEW)
        target_link_libraries(imgui
            INTERFACE
                GLEW::GLEW
        )
        target_compile_definitions(imgui
            INTERFACE
                IMGUI_IMPL_OPENGL_LOADER_GLEW
        )
    # TODO: add some other loaders...
    # elseif(imgui_LOADER_lower STREQUAL "gl3w")
    #     target_compile_definitions(imgui
    #         INTERFACE
    #             IMGUI_IMPL_OPENGL_LOADER_GL3W
    #     )
    else()
        message(FATAL_ERROR "Unknown ImGui loader ${imgui_LOADER}")
    endif()

    # Implementation
    if(imgui_IMPLEMENTATION_lower STREQUAL "opengl3")
        find_dependency(OpenGL)
        target_link_libraries(imgui
            INTERFACE
                OpenGL::GL
        )
        target_sources(imgui
            INTERFACE
                ${imgui_SOURCE_DIR}/examples/imgui_impl_opengl3.h
                ${imgui_SOURCE_DIR}/examples/imgui_impl_opengl3.cpp
        )
    # TODO: add other implementations...
    else()
        message(FATAL_ERROR "Unknown ImGui implementation ${imgui_IMPLEMENTATION}")
    endif()
endfunction()