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
            Layout.preferredHeight: 60
            color: "white"
            radius: theme.cornerRadius
            border.color: theme.borderColor
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: theme.defaultPadding
                spacing: theme.defaultPadding

                Text {
                    text: "Weekly Timetable"
                    font.pixelSize: theme.fontSizeLarge
                    font.bold: true
                    color: theme.primaryColor

                    Accessible.role: Accessible.StaticText
                    Accessible.name: "pageTitle"
                    Accessible.description: "Page title: Weekly Timetable"
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "Welcome, " + SettingsStore.username + "!"
                    font.pixelSize: theme.fontSizeNormal
                    color: theme.textColor

                    Accessible.role: Accessible.StaticText
                    Accessible.name: "welcomeMessage"
                    Accessible.description: "Welcome message with username"
                }
            }
        }

        // Timetable View
        TimetableView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            controller: root.controller
        }
    }
}
