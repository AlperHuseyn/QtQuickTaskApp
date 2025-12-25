import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import TaskApp 1.0

Dialog {
    id: root
    modal: true
    title: "Task Notes"
    standardButtons: Dialog.Ok | Dialog.Cancel
    
    property int taskIndex: -1
    property var controller: null
    property string notes: ""
    
    Accessible.role: Accessible.Dialog
    Accessible.name: "taskNotesDialog"
    Accessible.description: "Dialog for editing task notes"
    
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    
    width: 500
    height: 400
    
    ColumnLayout {
        anchors.fill: parent
        spacing: theme.defaultPadding
        
        Label {
            text: "Task Notes:"
            font.pixelSize: theme.fontSizeLarge
            font.bold: true
            color: theme.textColor
        }
        
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            TextArea {
                id: notesInput
                text: root.notes
                placeholderText: "Enter notes for this task..."
                wrapMode: TextArea.Wrap
                font.pixelSize: theme.fontSizeNormal
                
                Accessible.role: Accessible.EditableText
                Accessible.name: "notesInput"
                Accessible.description: "Text area for task notes"
                
                background: Rectangle {
                    color: theme.backgroundColor
                    radius: theme.cornerRadius
                    border.color: notesInput.activeFocus ? theme.primaryColor : theme.borderColor
                    border.width: 2
                    
                    Behavior on border.color {
                        ColorAnimation { duration: 200 }
                    }
                }
            }
        }
    }
    
    onAccepted: {
        if (controller && taskIndex >= 0) {
            controller.model.updateTaskNotes(taskIndex, notesInput.text)
            controller.save()
        }
    }
}
