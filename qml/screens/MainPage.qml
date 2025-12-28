import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import TaskApp 1.0

Item {
    id: root

    Accessible.role: Accessible.Pane
    Accessible.name: "mainPage"
    Accessible.description: "Task management page"

    property AppController controller: null

    // Timetable View fills entire window
    TimetableView {
        anchors.fill: parent
        controller: root.controller
    }
}
