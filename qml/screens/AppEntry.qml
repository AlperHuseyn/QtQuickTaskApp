import QtQuick 2.15
import QtQuick.Controls 2.15
import TaskApp 1.0

ApplicationWindow {
    id: win
    visible: true
    width: 900
    height: 700
    title: "QtQuickTaskApp" + (SettingsStore.username ? " — " + SettingsStore.username : "")

    Loader {
        id: themeLoader
        source: "qrc:/AppTheme.qml"
        active: true
        asynchronous: false
    }

    property var theme: themeLoader.item


    AppController {
        id: appController
        currentUser: SettingsStore.username
    }

    onClosing: {
        // Clear username on exit to ensure login screen shows next time
        SettingsStore.username = ""
    }

    menuBar: MenuBar {
        Menu {
            title: "File"

            Action {
                text: "Logout"
                enabled: stackView.currentItem !== loginPage
                onTriggered: {
                    SettingsStore.username = ""
                    stackView.replace(loginPage)
                }
            }
            MenuSeparator {}
            Action {
                text: "Exit"
                onTriggered: {
                    SettingsStore.username = ""
                    Qt.quit()
                }
            }
        }
    }

    Component {
        id: loginPage
        LoginPage {
            onLoginSuccessful: {
                stackView.replace(mainPage, StackView.Transition)
            }
        }
    }

    Component {
        id: mainPage
        MainPage {
            controller: appController
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: SettingsStore.username ? mainPage : loginPage

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 300
            }
        }

        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
            }
        }

        replaceEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 300
            }
        }

        replaceExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
            }
        }
    }
}
