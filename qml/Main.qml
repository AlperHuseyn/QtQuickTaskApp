import QtQuick 2.15
import QtQuick.Controls 2.15
import TaskApp 1.0

ApplicationWindow {
    id: win
    visible: true
    width: 900
    height: 700
    title: "QtQuickTaskApp" + (SettingsStore.username ? " — " + SettingsStore.username : "")
    
    Accessible.role: Accessible.Window
    Accessible.name: "QtQuickTaskApp Main Window"
    Accessible.description: "Task management application main window"

    AppController {
        id: appController
    }

    menuBar: MenuBar {
        Accessible.role: Accessible.MenuBar
        Accessible.name: "mainMenuBar"
        
        Menu {
            title: "File"
            Accessible.role: Accessible.MenuItem
            Accessible.name: "fileMenu"
            
            Action {
                text: "Logout"
                enabled: stackView.currentItem !== loginPage
                onTriggered: {
                    SettingsStore.username = ""
                    stackView.replace(loginPage)
                }
                
                Accessible.role: Accessible.MenuItem
                Accessible.name: "logoutAction"
                Accessible.description: "Logout and return to login screen"
            }
            MenuSeparator {}
            Action {
                text: "Exit"
                onTriggered: Qt.quit()
                
                Accessible.role: Accessible.MenuItem
                Accessible.name: "exitAction"
                Accessible.description: "Exit the application"
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
        
        Accessible.role: Accessible.LayeredPane
        Accessible.name: "navigationStack"
        Accessible.description: "Main navigation stack"

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
