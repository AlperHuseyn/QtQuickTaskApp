import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import TaskApp 1.0

Item {
    id: root

    Accessible.role: Accessible.Pane
    Accessible.name: "mainPage"
    Accessible.description: "Task management page with timetable"

    property AppController controller: null

    // Load dialogs
    Loader {
        id: workoutDialogLoader
        active: false
        sourceComponent: workoutDialogComponent
        onLoaded: item.open()
    }

    Component {
        id: workoutDialogComponent
        Dialog {
            id: workoutDialog
            modal: true
            title: "Workout Details"
            standardButtons: Dialog.Ok | Dialog.Cancel
            parent: Overlay.overlay
            
            property int taskIndex: -1
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
                        value: workoutDialog.reps
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
                        value: workoutDialog.weight * 100
                        
                        property int decimals: 2
                        property real realValue: value / 100
                        
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
                        value: workoutDialog.sets
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
    }

    Loader {
        id: notesDialogLoader
        active: false
        sourceComponent: notesDialogComponent
        onLoaded: item.open()
    }

    Component {
        id: notesDialogComponent
        Dialog {
            id: notesDialog
            modal: true
            title: "Task Notes"
            standardButtons: Dialog.Ok | Dialog.Cancel
            parent: Overlay.overlay
            
            property int taskIndex: -1
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
                        text: notesDialog.notes
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
    }

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
            border.color: theme.borderColor
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
                        text: "Daily Timetable (7:00 AM - 9:00 PM)"
                        font.pixelSize: theme.fontSizeNormal
                        color: "#7f8c8d"

                        Accessible.role: Accessible.StaticText
                        Accessible.name: "timetableTitle"
                        Accessible.description: "Timetable title"
                    }
                }
            }
        }

        // Add Task Section
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            color: "white"
            radius: theme.cornerRadius
            border.color: theme.borderColor
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: theme.defaultPadding
                spacing: theme.defaultPadding / 2

                Row {
                    Layout.fillWidth: true
                    spacing: theme.defaultPadding

                    TextField {
                        id: taskInput
                        width: parent.width * 0.5
                        placeholderText: "Task title..."
                        font.pixelSize: theme.fontSizeNormal

                        Accessible.role: Accessible.EditableText
                        Accessible.name: "taskInput"
                        Accessible.description: "Input field for new task"

                        background: Rectangle {
                            color: theme.backgroundColor
                            radius: theme.cornerRadius
                            border.color: taskInput.activeFocus ? theme.primaryColor : theme.borderColor
                            border.width: 2

                            Behavior on border.color {
                                ColorAnimation { duration: 200 }
                            }
                        }
                    }

                    ComboBox {
                        id: hourComboBox
                        width: 150
                        model: {
                            var hours = [];
                            for (var i = 7; i <= 21; i++) {
                                var hour12 = i > 12 ? i - 12 : i;
                                var ampm = i >= 12 ? "PM" : "AM";
                                hours.push(hour12 + ":00 " + ampm + " (" + i + ")");
                            }
                            return hours;
                        }
                        
                        Accessible.role: Accessible.ComboBox
                        Accessible.name: "hourSelector"
                        Accessible.description: "Select hour for task"
                    }

                    ComboBox {
                        id: categoryComboBox
                        width: 150
                        model: ["General", "Work", "Workout", "Personal", "Meeting"]
                        
                        Accessible.role: Accessible.ComboBox
                        Accessible.name: "categorySelector"
                        Accessible.description: "Select task category"
                    }

                    Button {
                        id: addButton
                        text: "Add Task"
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
                                var hour = hourComboBox.currentIndex + 7;
                                var category = categoryComboBox.currentText;
                                controller.model.addTask(taskInput.text.trim(), hour, category)
                                taskInput.text = ""
                                controller.save()
                            }
                        }
                    }
                }
            }
        }

        // Timetable View
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"
            radius: theme.cornerRadius
            border.color: theme.borderColor
            border.width: 1

            ListView {
                id: timetableView
                anchors.fill: parent
                anchors.margins: theme.defaultPadding
                clip: true
                spacing: 2

                Accessible.role: Accessible.List
                Accessible.name: "timetableView"
                Accessible.description: "Hourly timetable view"

                model: 15 // 7 AM to 9 PM = 15 hours

                delegate: Rectangle {
                    width: timetableView.width
                    height: 60
                    color: index % 2 === 0 ? "#F8F9FA" : "#FFFFFF"
                    radius: theme.cornerRadius
                    border.color: theme.borderColor
                    border.width: 1

                    property int hourValue: 7 + index

                    Accessible.role: Accessible.ListItem
                    Accessible.name: "timetableRow_" + hourValue
                    Accessible.description: "Time slot for hour " + hourValue

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: theme.defaultPadding / 2
                        spacing: theme.defaultPadding

                        // Time label
                        Rectangle {
                            Layout.preferredWidth: 100
                            Layout.fillHeight: true
                            color: theme.primaryColor
                            radius: theme.cornerRadius

                            Text {
                                anchors.centerIn: parent
                                text: {
                                    var h = 7 + index;
                                    var hour12 = h > 12 ? h - 12 : h;
                                    var ampm = h >= 12 ? "PM" : "AM";
                                    return hour12 + ":00 " + ampm;
                                }
                                font.pixelSize: theme.fontSizeNormal
                                font.bold: true
                                color: "white"

                                Accessible.role: Accessible.StaticText
                                Accessible.name: "timeLabel_" + (7 + index)
                            }
                        }

                        // Tasks for this hour
                        Repeater {
                            model: controller ? controller.model.getTasksForHour(7 + index) : []

                            delegate: Rectangle {
                                Layout.preferredWidth: 150
                                Layout.fillHeight: true
                                radius: theme.cornerRadius
                                color: {
                                    var cat = modelData.category;
                                    if (cat === "Work") return "#3498db";
                                    if (cat === "Workout") return "#e74c3c";
                                    if (cat === "Personal") return "#9b59b6";
                                    if (cat === "Meeting") return "#f39c12";
                                    return "#95a5a6";
                                }
                                border.color: Qt.darker(color, 1.2)
                                border.width: 2

                                Accessible.role: Accessible.Button
                                Accessible.name: "taskBlock_" + modelData.title
                                Accessible.description: "Task: " + modelData.title + " (" + modelData.category + ")"

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 4
                                    spacing: 2

                                    Text {
                                        text: modelData.title
                                        font.pixelSize: theme.fontSizeSmall
                                        font.bold: true
                                        color: "white"
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                        wrapMode: Text.WordWrap
                                        maximumLineCount: 2
                                    }

                                    Text {
                                        text: modelData.category
                                        font.pixelSize: theme.fontSizeSmall - 2
                                        color: "white"
                                        opacity: 0.8
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.LeftButton
                                    
                                    onDoubleClicked: {
                                        if (modelData.category === "Workout") {
                                            workoutDialogLoader.active = false
                                            workoutDialogLoader.setSource("", {
                                                "taskIndex": modelData.index,
                                                "reps": modelData.reps,
                                                "weight": modelData.weight,
                                                "sets": modelData.sets
                                            })
                                            workoutDialogLoader.active = true
                                        } else {
                                            notesDialogLoader.active = false
                                            notesDialogLoader.setSource("", {
                                                "taskIndex": modelData.index,
                                                "notes": modelData.notes
                                            })
                                            notesDialogLoader.active = true
                                        }
                                    }
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "No tasks scheduled. Add your first task above!"
                    font.pixelSize: theme.fontSizeLarge
                    color: "gray"
                    visible: controller && controller.model && controller.model.rowCount() === 0

                    Accessible.role: Accessible.StaticText
                    Accessible.name: "emptyStateMessage"
                    Accessible.description: "No tasks yet"
                }
            }
        }

        // Legend and Actions
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
                    text: "Categories:"
                    font.pixelSize: theme.fontSizeNormal
                    font.bold: true
                    color: theme.textColor
                }

                Row {
                    spacing: theme.defaultPadding
                    
                    Repeater {
                        model: [
                            {name: "Work", color: "#3498db"},
                            {name: "Workout", color: "#e74c3c"},
                            {name: "Personal", color: "#9b59b6"},
                            {name: "Meeting", color: "#f39c12"},
                            {name: "General", color: "#95a5a6"}
                        ]
                        
                        delegate: Row {
                            spacing: 4
                            Rectangle {
                                width: 20
                                height: 20
                                radius: 4
                                color: modelData.color
                            }
                            Text {
                                text: modelData.name
                                font.pixelSize: theme.fontSizeSmall
                                color: theme.textColor
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "Double-click tasks to edit details"
                    font.pixelSize: theme.fontSizeSmall
                    color: "#7f8c8d"
                    font.italic: true
                }
            }
        }
    }
}

