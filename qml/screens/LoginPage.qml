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
            GradientStop { position: 0.0; color: theme.primaryColor }  // Reuse primary color
            GradientStop { position: 1.0; color: theme.secondaryColor }  // Reuse secondary color
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: theme.defaultPadding * 2  // Reuse default padding
        width: 350

        Text {
            text: "Welcome to TaskApp"
            font.pixelSize: theme.fontSizeLarge  // Theme-based font size
            font.bold: true
            color: theme.textColor  // Theme-based text color
            anchors.horizontalCenter: parent.horizontalCenter

            Accessible.role: Accessible.StaticText
            Accessible.name: "welcomeTitle"
            Accessible.description: "Welcome to TaskApp"
        }

        Text {
            text: "Please enter your name to continue"
            font.pixelSize: theme.fontSizeNormal  // Theme-based font size
            color: theme.textColor
            opacity: 0.9
            anchors.horizontalCenter: parent.horizontalCenter

            Accessible.role: Accessible.StaticText
            Accessible.name: "loginPrompt"
            Accessible.description: "Please enter your name to continue"
        }

        Rectangle {
            width: parent.width
            height: 60
            radius: theme.cornerRadius  // Reuse defined corner radius
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: usernameField
                // Assign an objectName so that automation tools (e.g. pywinauto)
                // can reliably locate this control via the AutomationId property.
                objectName: "usernameField"
                anchors.fill: parent
                anchors.margins: theme.defaultPadding
                placeholderText: "Enter your username"
                font.pixelSize: theme.fontSizeNormal  // Theme-based font size
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
            // Assign an objectName so that automation tools (e.g. pywinauto)
            // can reliably locate this control via the AutomationId property.
            objectName: "loginButton"
            text: "Login"
            width: parent.width
            height: 50
            font.pixelSize: theme.fontSizeNormal  // Theme-based font size
            font.bold: true
            enabled: usernameField.text.trim().length > 0

            Accessible.role: Accessible.Button
            Accessible.name: "loginButton"
            Accessible.description: "Click to login with entered username"
            Accessible.onPressAction: if (enabled) clicked()

            background: Rectangle {
                radius: theme.cornerRadius
                color: loginButton.enabled
                    ? (loginButton.pressed ? theme.secondaryColor : theme.primaryColor)
                    : "#cccccc"  // Disabled button color

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