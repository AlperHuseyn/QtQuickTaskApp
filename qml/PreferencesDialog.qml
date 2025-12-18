import QtQuick 1.1

Rectangle {
    id: mainWindow
    width: 800
    height: 600
    color: "#F0F0F0"

    Text {
        text: "Qt Quick 1 - Task Manager"
        font.pixelSize: 22
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
    }

    Rectangle {
        id: addTaskSection
        width: parent.width - 40
        height: 100
        color: "#FFFFFF"
        border.color: "#CCCCCC"
        radius: 6
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 60

        Text {
            text: "Add New Task"
            font.pixelSize: 16
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: addButton
            width: 120
            height: 40
            color: "#4CAF50"
            radius: 4
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: "Add Task"
                color: "#FFFFFF"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: console.log("Task added!") // Connect this to C++ later
            }
        }
    }

    ListView {
        id: taskList
        width: parent.width - 40
        height: parent.height - addTaskSection.height - 80
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: addTaskSection.bottom
        anchors.topMargin: 20

        model: 10 // Replace with a TaskModel later

        delegate: Rectangle {
            width: parent.width
            height: 50
            color: index % 2 == 0 ? "#FFFFFF" : "#F9F9F9"
            border.color: "#D9D9D9"

            Text {
                text: "Task " + (index + 1) // Replace with dynamic task titles later
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
            }

            Rectangle {
                width: 80
                height: 30
                color: "#E53935"
                radius: 4
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 10

                Text {
                    text: "Remove"
                    color: "#FFFFFF"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("Task removed!") // Connect this to C++ later
                }
            }
        }
    }
}