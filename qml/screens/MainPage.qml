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

    Rectangle {
        anchors.fill: parent
        color: theme.backgroundColor
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: theme.defaultPadding
        spacing: theme.defaultPadding

        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: "white"
            radius: theme.cornerRadius
            border.color: theme.textColor
            border.width: 1

            Row {
                anchors.fill: parent
                anchors.margins: theme.defaultPadding
                spacing: theme.defaultPadding

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: theme.defaultPadding

                    Text {
                        text: "Welcome, " + SettingsStore.username + "!"
                        font.pixelSize: theme.fontSizeLarge
                        font.bold: true
                        color: theme.textColor

                        Accessible.role: Accessible.StaticText
                        Accessible.name: "welcomeMessage"
                        Accessible.description: "Welcome message with username"
                    }

                    Text {
                        text: taskListView.count + " task(s)"
                        font.pixelSize: theme.fontSizeNormal
                        color: "#7f8c8d"

                        Accessible.role: Accessible.StaticText
                        Accessible.name: "taskCounter"
                        Accessible.description: "Number of tasks"
                    }
                }
            }
        }

        // Add Task Section
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: "white"
            radius: theme.cornerRadius
            border.color: theme.textColor
            border.width: 1

            Row {
                anchors.fill: parent
                anchors.margins: theme.defaultPadding
                spacing: theme.defaultPadding

                TextField {
                    id: taskInput
                    width: parent.width - addButton.width - parent.spacing
                    height: parent.height
                    placeholderText: "What needs to be done?"
                    font.pixelSize: theme.fontSizeNormal

                    Accessible.role: Accessible.EditableText
                    Accessible.name: "taskInput"
                    Accessible.description: "Input field for new task"

                    background: Rectangle {
                        color: theme.backgroundColor
                        radius: theme.cornerRadius
                        border.color: taskInput.activeFocus ? theme.primaryColor : theme.textColor
                        border.width: 2

                        Behavior on border.color {
                            ColorAnimation { duration: 200 }
                        }
                    }

                    onAccepted: addButton.clicked()
                }

                Button {
                    id: addButton
                    text: "Add Task"
                    height: parent.height
                    font.pixelSize: theme.fontSizeNormal
                    font.bold: true
                    enabled: taskInput.text.trim().length > 0

                    Accessible.role: Accessible.Button
                    Accessible.name: "addTaskButton"
                    Accessible.description: "Add new task"
                    Accessible.onPressAction: if (enabled) clicked()

                    background: Rectangle {
                        radius: theme.cornerRadius
                        color: addButton.enabled ? (addButton.pressed ? theme.secondaryColor : theme.primaryColor) : "gray"

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    contentItem: Text {
                        text: addButton.text
                        font: addButton.font
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 20
                        rightPadding: 20
                    }

                    onClicked: {
                        if (taskInput.text.trim().length > 0 && controller) {
                            controller.model.addTask(taskInput.text.trim())
                            taskInput.text = ""
                            controller.save()
                        }
                    }
                }
            }
        }

        // Task List
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"
            radius: theme.cornerRadius
            border.color: theme.textColor
            border.width: 1

            ListView {
                id: taskListView
                anchors.fill: parent
                anchors.margins: theme.defaultPadding
                spacing: theme.defaultPadding / 2
                clip: true

                Accessible.role: Accessible.List
                Accessible.name: "taskListView"
                Accessible.description: "List of tasks"

                model: controller ? controller.model : null

                delegate: Rectangle {
                    width: taskListView.width
                    height: 60
                    color: model.done ? theme.backgroundColor : "white"
                    radius: theme.cornerRadius
                    border.color: theme.textColor
                    border.width: 1

                    Accessible.role: Accessible.ListItem
                    Accessible.name: "taskItem_" + index
                    Accessible.description: model.title + (model.done ? " (completed)" : " (active)")

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: theme.defaultPadding / 2
                        spacing: theme.defaultPadding / 2

                        CheckBox {
                            id: checkbox
                            Layout.alignment: Qt.AlignVCenter
                            checked: model.done

                            Accessible.role: Accessible.CheckBox
                            Accessible.name: "taskCheckbox_" + index
                            Accessible.description: "Toggle completion for: " + model.title
                            Accessible.onPressAction: clicked()

                            onClicked: {
                                if (controller) {
                                    controller.model.toggleTask(index)
                                    controller.save()
                                }
                            }
                        }

                        Text {
                            text: model.title
                            font.pixelSize: theme.fontSizeNormal
                            color: model.done ? "#95a5a6" : theme.primaryColor
                            font.strikeout: model.done
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            elide: Text.ElideRight

                            Accessible.role: Accessible.StaticText
                            Accessible.name: "taskTitle_" + index
                            Accessible.description: model.title

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }

                        Button {
                            id: removeButton
                            text: "Remove"
                            Layout.alignment: Qt.AlignVCenter
                            font.pixelSize: theme.fontSizeSmall

                            Accessible.role: Accessible.Button
                            Accessible.name: "removeTaskButton_" + index
                            Accessible.description: "Remove task: " + model.title
                            Accessible.onPressAction: clicked()

                            background: Rectangle {
                                radius: theme.cornerRadius
                                color: removeButton.pressed ? "#c0392b" : "#e74c3c"

                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }
                            }

                            contentItem: Text {
                                text: removeButton.text
                                font: removeButton.font
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 15
                                rightPadding: 15
                            }

                            onClicked: {
                                if (controller) {
                                    controller.model.removeTask(index)
                                    controller.save()
                                }
                            }
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "No tasks yet. Add your first task above!"
                    font.pixelSize: theme.fontSizeLarge
                    color: "gray"
                    visible: taskListView.count === 0

                    Accessible.role: Accessible.StaticText
                    Accessible.name: "emptyStateMessage"
                    Accessible.description: "No tasks yet. Add your first task above!"
                }
            }
        }

        // Clear Completed Button
        Button {
            id: clearButton
            text: "Clear Completed Tasks"
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            font.pixelSize: theme.fontSizeLArge
            enabled: controller && controller.model && controller.model.hasCompletedTasks()

            Accessible.role: Accessible.Button
            Accessible.name: "clearCompletedButton"
            Accessible.description: "Clear all completed tasks"
            Accessible.onPressAction: if (enabled) clicked()

            // Force re-evaluation when completed tasks change
            Connections {
                target: controller ? controller.model : null
                function onCompletedTasksChanged() {
                    clearButton.enabled = Qt.binding(function() {
                        return controller && controller.model && controller.model.hasCompletedTasks()
                    })
                }
            }

            background: Rectangle {
                radius: theme.cornerRadius
                color: clearButton.enabled ? (clearButton.pressed ? "#d68910" : "#f39c12") : "#ecf0f1"

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            contentItem: Text {
                text: clearButton.text
                font: clearButton.font
                color: clearButton.enabled ? "white" : "#bdc3c7"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                if (controller) {
                    controller.model.clearCompleted()
                    controller.save()
                }
            }
        }
    }
}
