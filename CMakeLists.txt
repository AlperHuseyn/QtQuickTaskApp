cmake_minimum_required(VERSION 3.16)

project(QtQuickTaskApp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 REQUIRED COMPONENTS Core Gui Qml Quick)

set(SOURCES
        src/main.cpp
        src/controllers/appcontroller.cpp
        src/controllers/appcontroller.h
        src/models/taskmodel.cpp
        src/models/taskmodel.h
        src/services/settingsstore.cpp
        src/services/settingsstore.h
        qml/qml.qrc
)

add_executable(QtQuickTaskApp ${SOURCES})

target_link_libraries(QtQuickTaskApp PRIVATE
        Qt5::Core
        Qt5::Gui
        Qt5::Qml
        Qt5::Quick
)

set_target_properties(QtQuickTaskApp PROPERTIES
        AUTOMOC ON
        AUTORCC ON
        AUTOUIC ON
)
