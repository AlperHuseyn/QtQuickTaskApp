import QtQuick 2.15
import QtQuick.Controls 2.15
import TaskApp 1.0

Item {
    id: root
    
    Accessible.role: Accessible.Pane
    Accessible.name: "loginPage"
    Accessible.description: "Login page for entering username"

    signal loginSuccessful()

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#667eea" }
            GradientStop { position: 1.0; color: "#764ba2" }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 30
        width: 350

        Text {
            text: "Welcome to TaskApp"
            font.pixelSize: 32
            font.bold: true
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            
            Accessible.role: Accessible.StaticText
            Accessible.name: "welcomeTitle"
            Accessible.description: "Welcome to TaskApp"
        }

        Text {
            text: "Please enter your name to continue"
            font.pixelSize: 16
            color: "white"
            opacity: 0.9
            anchors.horizontalCenter: parent.horizontalCenter
            
            Accessible.role: Accessible.StaticText
            Accessible.name: "loginPrompt"
            Accessible.description: "Please enter your name to continue"
        }

        Rectangle {
            width: parent.width
            height: 60
            radius: 8
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: usernameField
                anchors.fill: parent
                anchors.margins: 10
                placeholderText: "Enter your username"
                font.pixelSize: 18
                background: Item {}
                text: SettingsStore.username

                onAccepted: loginButton.clicked()
                
                Accessible.role: Accessible.EditableText
                Accessible.name: "usernameField"
                Accessible.description: "Username input field"
            }
        }

        Button {
            id: loginButton
            text: "Login"
            width: parent.width
            height: 50
            font.pixelSize: 18
            font.bold: true
            enabled: usernameField.text.trim().length > 0
            
            Accessible.role: Accessible.Button
            Accessible.name: "loginButton"
            Accessible.description: "Click to login with entered username"
            Accessible.onPressAction: if (enabled) clicked()

            background: Rectangle {
                radius: 8
                color: loginButton.enabled ? (loginButton.pressed ? "#5568d3" : "#667eea") : "#cccccc"

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            contentItem: Text {
                text: loginButton.text
                font: loginButton.font
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                if (usernameField.text.trim().length > 0) {
                    SettingsStore.username = usernameField.text.trim()
                    root.loginSuccessful()
                }
            }

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }
    }
}
