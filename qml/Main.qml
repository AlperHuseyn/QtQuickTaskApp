import QtQuick 2.15
import QtQuick.Controls 2.15
import TaskApp 1.0

ApplicationWindow {
    id: win
    visible: true
    width: 800
    height: 600
    title: "QtQuickTaskApp — " + SettingsStore.username

    menuBar: MenuBar {
        Menu {
            title: "File"
            Action {
                text: "Exit"
                onTriggered: Qt.quit()
            }
        }
    }

    Item {
        anchors.fill: parent

        Accessible.name: "Main Application Window"
        Accessible.role: Accessible.Window

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: SettingsStore.username
                    ? "Welcome, " + SettingsStore.username + "!"
                    : "Welcome!"
                font.pixelSize: 24
            }

            TextField {
                placeholderText: "Enter your username"
                text: SettingsStore.username
                width: 300

                onTextChanged: {
                    SettingsStore.username = text
                }
            }

            Button {
                text: "Save Username"
                onClicked: console.log("Saved username:", SettingsStore.username)
            }
        }
    }
}
