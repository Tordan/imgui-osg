#include <iostream>

#include <osgViewer/Viewer>
#include <osgViewer/config/SingleWindow>

#include <imgui.h>
#include <imgui_impl_opengl3.h>

#include "OsgImGuiHandler.hpp"

class ImGuiInitOperation : public osg::Operation
{
public:
    ImGuiInitOperation()
        : osg::Operation("ImGuiInitOperation", false)
    {
    }

    void operator()(osg::Object* object) override
    {
        osg::GraphicsContext* context = dynamic_cast<osg::GraphicsContext*>(object);
        if (!context)
            return;

        if (!ImGui_ImplOpenGL3_Init())
        {
            std::cout << "ImGui_ImplOpenGL3_Init() failed\n";
        }
    }
};

class ImGuiDemo : public OsgImGuiHandler
{
protected:
    void drawUi() override
    {
        // ImGui code goes here...
        ImGui::ShowDemoWindow();
    }
};

int main(int argc, char** argv)
{
    osgViewer::Viewer viewer;
    viewer.apply(new osgViewer::SingleWindow(100, 100, 640, 480));
    viewer.setRealizeOperation(new ImGuiInitOperation);
    viewer.addEventHandler(new ImGuiDemo);

    return viewer.run();
}
