import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import TaskApp 1.0

Dialog {
    id: root
    modal: true
    title: "Workout Details"
    standardButtons: Dialog.Ok | Dialog.Cancel
    
    property int taskIndex: -1
    property var controller: null
    property int reps: 0
    property double weight: 0.0
    property int sets: 0
    
    Accessible.role: Accessible.Dialog
    Accessible.name: "workoutDetailsDialog"
    Accessible.description: "Dialog for editing workout details"
    
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    
    width: 400
    height: 300
    
    ColumnLayout {
        anchors.fill: parent
        spacing: theme.defaultPadding
        
        Label {
            text: "Enter workout details:"
            font.pixelSize: theme.fontSizeLarge
            font.bold: true
            color: theme.textColor
        }
        
        GridLayout {
            columns: 2
            columnSpacing: theme.defaultPadding
            rowSpacing: theme.defaultPadding / 2
            Layout.fillWidth: true
            
            Label {
                text: "Repetitions:"
                font.pixelSize: theme.fontSizeNormal
                color: theme.textColor
            }
            
            SpinBox {
                id: repsInput
                from: 0
                to: 999
                value: root.reps
                Layout.fillWidth: true
                
                Accessible.role: Accessible.SpinBox
                Accessible.name: "repsInput"
                Accessible.description: "Number of repetitions"
            }
            
            Label {
                text: "Weight (kg):"
                font.pixelSize: theme.fontSizeNormal
                color: theme.textColor
            }
            
            SpinBox {
                id: weightInput
                from: 0
                to: 99900
                stepSize: 50
                value: root.weight * 100
                
                property int decimals: 2
                property real realValue: value / 100
                
                validator: DoubleValidator {
                    bottom: Math.min(weightInput.from, weightInput.to)
                    top: Math.max(weightInput.from, weightInput.to)
                }
                
                textFromValue: function(value, locale) {
                    return Number(value / 100).toLocaleString(locale, 'f', decimals)
                }
                
                valueFromText: function(text, locale) {
                    return Number.fromLocaleString(locale, text) * 100
                }
                
                Layout.fillWidth: true
                
                Accessible.role: Accessible.SpinBox
                Accessible.name: "weightInput"
                Accessible.description: "Weight in kilograms"
            }
            
            Label {
                text: "Sets:"
                font.pixelSize: theme.fontSizeNormal
                color: theme.textColor
            }
            
            SpinBox {
                id: setsInput
                from: 0
                to: 999
                value: root.sets
                Layout.fillWidth: true
                
                Accessible.role: Accessible.SpinBox
                Accessible.name: "setsInput"
                Accessible.description: "Number of sets"
            }
        }
        
        Item {
            Layout.fillHeight: true
        }
    }
    
    onAccepted: {
        if (controller && taskIndex >= 0) {
            controller.model.updateWorkoutDetails(taskIndex, repsInput.value, weightInput.realValue, setsInput.value)
            controller.save()
        }
    }
}
