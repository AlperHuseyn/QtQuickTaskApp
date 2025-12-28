import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import TaskApp 1.0

Item {
    id: root

    Accessible.role: Accessible.Pane
    Accessible.name: "timetableView"
    Accessible.description: "Weekly timetable view"

    property AppController controller: null
    property date currentWeekStart: getWeekStart(new Date())
    property int refreshCounter: 0  // Used to force refresh of task bindings

    // Force refresh of all task bindings
    function refreshTasks() {
        refreshCounter++
    }

    // Listen for model changes
    Connections {
        target: controller ? controller.model : null
        function onRowsInserted() { refreshTasks() }
        function onRowsRemoved() { refreshTasks() }
        function onDataChanged() { refreshTasks() }
        function onModelReset() { refreshTasks() }
    }

    // Get the start of the week (Sunday) for a given date
    function getWeekStart(date) {
        var d = new Date(date)
        var day = d.getDay()
        var diff = d.getDate() - day
        d.setDate(diff)
        d.setHours(0, 0, 0, 0)
        return d
    }

    // Navigate to previous week
    function previousWeek() {
        var d = new Date(currentWeekStart)
        d.setDate(d.getDate() - 7)
        currentWeekStart = d
    }

    // Navigate to next week
    function nextWeek() {
        var d = new Date(currentWeekStart)
        d.setDate(d.getDate() + 7)
        currentWeekStart = d
    }

    // Format date for display
    function formatWeekRange() {
        var start = new Date(currentWeekStart)
        var end = new Date(currentWeekStart)
        end.setDate(end.getDate() + 6)
        
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        return months[start.getMonth()] + " " + start.getDate() + " - " + 
               months[end.getMonth()] + " " + end.getDate() + ", " + start.getFullYear()
    }

    // Get color for task type
    function getTaskColor(taskType) {
        switch(taskType) {
            case "workout": return "#27ae60"  // Green
            case "work": return "#3498db"     // Blue
            case "meeting": return "#9b59b6"  // Purple
            case "personal": return "#e67e22" // Orange
            default: return "#95a5a6"         // Gray
        }
    }

    Rectangle {
        anchors.fill: parent
        color: theme.backgroundColor
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header with week navigation
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: "white"
            border.color: theme.borderColor
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: theme.defaultPadding
                spacing: theme.defaultPadding

                Button {
                    text: "◄ Prev Week"
                    Layout.preferredWidth: 120
                    font.pixelSize: theme.fontSizeNormal

                    Accessible.role: Accessible.Button
                    Accessible.name: "previousWeekButton"
                    Accessible.description: "Navigate to previous week"

                    background: Rectangle {
                        radius: theme.cornerRadius
                        color: parent.pressed ? theme.secondaryColor : theme.primaryColor
                    }

                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: previousWeek()
                }

                Text {
                    text: formatWeekRange()
                    font.pixelSize: theme.fontSizeLarge
                    font.bold: true
                    color: theme.primaryColor
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter

                    Accessible.role: Accessible.StaticText
                    Accessible.name: "weekRange"
                    Accessible.description: "Current week range"
                }

                Button {
                    text: "Next Week ►"
                    Layout.preferredWidth: 120
                    font.pixelSize: theme.fontSizeNormal

                    Accessible.role: Accessible.Button
                    Accessible.name: "nextWeekButton"
                    Accessible.description: "Navigate to next week"

                    background: Rectangle {
                        radius: theme.cornerRadius
                        color: parent.pressed ? theme.secondaryColor : theme.primaryColor
                    }

                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: nextWeek()
                }
            }
        }

        // Timetable grid
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "white"
            border.color: theme.borderColor
            border.width: 1

            ScrollView {
                id: scrollView
                anchors.fill: parent
                anchors.margins: theme.defaultPadding
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                ScrollBar.vertical.policy: ScrollBar.AsNeeded

                ColumnLayout {
                    width: Math.max(scrollView.width - 2 * theme.defaultPadding, 800)
                    spacing: 2

                    // Header row
                    RowLayout {
                        spacing: 2
                        Layout.fillWidth: true

                        // Time column header
                        Rectangle {
                            Layout.preferredWidth: 60
                            Layout.preferredHeight: 40
                            color: theme.backgroundColor
                            border.color: theme.borderColor
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "Time"
                                font.pixelSize: theme.fontSizeSmall
                                font.bold: true
                                color: theme.textColor
                            }
                        }

                        // Day headers
                        Repeater {
                            model: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
                            
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.minimumWidth: 100
                                Layout.preferredHeight: 40
                                color: theme.primaryColor
                                border.color: theme.borderColor
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    font.pixelSize: theme.fontSizeNormal
                                    font.bold: true
                                    color: "white"
                                }
                            }
                        }
                    }

                    // Time slots from 5:00 AM to 10:00 PM
                    Repeater {
                        model: 18  // Hours from 5 to 22 (5 AM to 10 PM)

                        RowLayout {
                            spacing: 2
                            Layout.fillWidth: true

                            property int hour: 5 + index

                            // Hour label
                            Rectangle {
                                Layout.preferredWidth: 60
                                Layout.preferredHeight: 60
                                color: theme.backgroundColor
                                border.color: theme.borderColor
                                border.width: 1

                                Text {
                                    anchors.centerIn: parent
                                    text: {
                                        var h = hour
                                        var ampm = h >= 12 ? "PM" : "AM"
                                        if (h > 12) h -= 12
                                        if (h === 0) h = 12
                                        return h + ":00 " + ampm
                                    }
                                    font.pixelSize: theme.fontSizeSmall
                                    font.bold: true
                                    color: theme.textColor
                                }
                            }

                            // Day cells for this hour
                            Repeater {
                                model: 7  // Days: 0=Sunday to 6=Saturday

                                Rectangle {
                                    id: cellRect
                                    Layout.fillWidth: true
                                    Layout.minimumWidth: 100
                                    Layout.preferredHeight: 60
                                    color: cellMouseArea.containsMouse ? "#f0f0f0" : "white"
                                    border.color: theme.borderColor
                                    border.width: 1

                                    property int day: index
                                    property int cellHour: hour
                                    property var tasks: {
                                        refreshCounter  // Dependency to force refresh
                                        return controller ? controller.model.getTasksForCell(day, cellHour, currentWeekStart.toISOString()) : []
                                    }

                                    Accessible.role: Accessible.Cell
                                    Accessible.name: "cell_day" + day + "_hour" + cellHour
                                    Accessible.description: tasks.length + " task(s) in this cell"

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: 2
                                        spacing: 2

                                        Repeater {
                                            model: parent.parent.tasks

                                            Rectangle {
                                                width: parent.width
                                                height: parent.parent.tasks.length === 1 ? parent.height - 4 : 18
                                                color: getTaskColor(modelData.taskType)
                                                radius: 3

                                                Text {
                                                    anchors.fill: parent
                                                    anchors.margins: 2
                                                    text: modelData.title
                                                    font.pixelSize: parent.parent.parent.parent.tasks.length === 1 ? theme.fontSizeNormal : 10
                                                    color: "white"
                                                    elide: Text.ElideRight
                                                    verticalAlignment: Text.AlignVCenter
                                                    horizontalAlignment: Text.AlignHCenter
                                                    font.bold: true
                                                    wrapMode: Text.WordWrap
                                                }
                                            }
                                            }
                                        }
                                    }

                                    MouseArea {
                                        id: cellMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        acceptedButtons: Qt.LeftButton

                                        onDoubleClicked: {
                                            if (cellRect.tasks.length > 0) {
                                                var task = cellRect.tasks[0]
                                                if (task.taskType === "workout") {
                                                    workoutDialog.taskIndex = task.index
                                                    workoutDialog.taskTitle = task.title
                                                    workoutDialog.taskNotes = task.notes
                                                    workoutDialog.open()
                                                } else {
                                                    notesDialog.taskIndex = task.index
                                                    notesDialog.taskTitle = task.title
                                                    notesDialog.taskNotes = task.notes
                                                    notesDialog.open()
                                                }
                                            } else {
                                                // Add new task
                                                addTaskDialog.targetDay = cellRect.day
                                                addTaskDialog.targetHour = cellRect.cellHour
                                                addTaskDialog.open()
                                            }
                                        }

                                        onClicked: {
                                            if (cellRect.tasks.length > 1) {
                                                // Show task list if multiple tasks
                                                taskListDialog.cellTasks = cellRect.tasks
                                                taskListDialog.open()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Dialog for adding new task
    Dialog {
        id: addTaskDialog
        title: "Add New Task"
        modal: true
        anchors.centerIn: parent
        width: 400
        height: 350

        property int targetDay: 0
        property int targetHour: 5

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Text {
                text: "Task Title:"
                font.pixelSize: theme.fontSizeNormal
            }

            TextField {
                id: newTaskTitle
                Layout.fillWidth: true
                placeholderText: "Enter task title"
                font.pixelSize: theme.fontSizeNormal
            }

            Text {
                text: "Task Type:"
                font.pixelSize: theme.fontSizeNormal
            }

            ComboBox {
                id: taskTypeCombo
                Layout.fillWidth: true
                model: ["workout", "work", "meeting", "personal", "other"]
                font.pixelSize: theme.fontSizeNormal
            }

            Text {
                text: "Notes:"
                font.pixelSize: theme.fontSizeNormal
            }

            TextArea {
                id: newTaskNotes
                Layout.fillWidth: true
                Layout.fillHeight: true
                placeholderText: "Enter notes (optional)"
                font.pixelSize: theme.fontSizeNormal
                wrapMode: TextArea.Wrap
            }
        }

        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: {
            if (newTaskTitle.text.trim().length > 0 && controller) {
                var taskDate = new Date(currentWeekStart)
                taskDate.setDate(taskDate.getDate() + targetDay)
                taskDate.setHours(targetHour, 0, 0, 0)
                
                controller.model.addTimetableTask(
                    newTaskTitle.text.trim(),
                    targetDay,
                    targetHour,
                    taskTypeCombo.currentText,
                    newTaskNotes.text,
                    taskDate.toISOString()
                )
                controller.save()
                newTaskTitle.text = ""
                newTaskNotes.text = ""
            }
        }

        onRejected: {
            newTaskTitle.text = ""
            newTaskNotes.text = ""
        }
    }

    // Dialog for workout details
    Dialog {
        id: workoutDialog
        title: "Workout Details"
        modal: true
        anchors.centerIn: parent
        width: 400
        height: 300

        property int taskIndex: -1
        property string taskTitle: ""
        property string taskNotes: ""

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Text {
                text: "Workout: " + workoutDialog.taskTitle
                font.pixelSize: theme.fontSizeLarge
                font.bold: true
                color: "#27ae60"
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.borderColor
            }

            Text {
                text: "Notes:"
                font.pixelSize: theme.fontSizeNormal
                font.bold: true
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                TextArea {
                    id: workoutNotesArea
                    text: workoutDialog.taskNotes
                    font.pixelSize: theme.fontSizeNormal
                    wrapMode: TextArea.Wrap
                    readOnly: false
                    width: parent.width
                }
            }
        }

        standardButtons: Dialog.Save | Dialog.Close
        
        footer: DialogButtonBox {
            Button {
                text: "Delete"
                DialogButtonBox.buttonRole: DialogButtonBox.DestructiveRole
                
                background: Rectangle {
                    color: parent.pressed ? "#c0392b" : "#e74c3c"
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            
            Button {
                text: "Save"
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }
            
            Button {
                text: "Cancel"
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }
        }

        onAccepted: {
            if (controller && taskIndex >= 0) {
                controller.model.updateTaskNotes(taskIndex, workoutNotesArea.text)
                controller.save()
            }
        }

        onRejected: {
            // Handle custom button clicks
            var clickedButton = arguments[0]
            if (clickedButton && clickedButton.DialogButtonBox.buttonRole === DialogButtonBox.DestructiveRole) {
                if (controller && taskIndex >= 0) {
                    controller.model.removeTask(taskIndex)
                    controller.save()
                }
            }
        }

        onOpened: {
            workoutNotesArea.text = taskNotes
        }
    }

    // Dialog for task notes
    Dialog {
        id: notesDialog
        title: "Task Notes"
        modal: true
        anchors.centerIn: parent
        width: 400
        height: 300

        property int taskIndex: -1
        property string taskTitle: ""
        property string taskNotes: ""

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Text {
                text: "Task: " + notesDialog.taskTitle
                font.pixelSize: theme.fontSizeLarge
                font.bold: true
                color: theme.primaryColor
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.borderColor
            }

            Text {
                text: "Notes:"
                font.pixelSize: theme.fontSizeNormal
                font.bold: true
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                TextArea {
                    id: taskNotesArea
                    text: notesDialog.taskNotes
                    font.pixelSize: theme.fontSizeNormal
                    wrapMode: TextArea.Wrap
                    readOnly: false
                    width: parent.width
                }
            }
        }

        standardButtons: Dialog.Save | Dialog.Close
        
        footer: DialogButtonBox {
            Button {
                text: "Delete"
                DialogButtonBox.buttonRole: DialogButtonBox.DestructiveRole
                
                background: Rectangle {
                    color: parent.pressed ? "#c0392b" : "#e74c3c"
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            
            Button {
                text: "Save"
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }
            
            Button {
                text: "Cancel"
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }
        }

        onAccepted: {
            if (controller && taskIndex >= 0) {
                controller.model.updateTaskNotes(taskIndex, taskNotesArea.text)
                controller.save()
            }
        }

        onRejected: {
            // Handle custom button clicks
            var clickedButton = arguments[0]
            if (clickedButton && clickedButton.DialogButtonBox.buttonRole === DialogButtonBox.DestructiveRole) {
                if (controller && taskIndex >= 0) {
                    controller.model.removeTask(taskIndex)
                    controller.save()
                }
            }
        }

        onOpened: {
            taskNotesArea.text = taskNotes
        }
    }

    // Dialog for showing multiple tasks in a cell
    Dialog {
        id: taskListDialog
        title: "Tasks in this time slot"
        modal: true
        anchors.centerIn: parent
        width: 350
        height: 300

        property var cellTasks: []

        ScrollView {
            anchors.fill: parent
            clip: true

            ListView {
                width: parent.width
                model: taskListDialog.cellTasks
                spacing: 5

                delegate: Rectangle {
                    width: parent.width
                    height: 50
                    color: getTaskColor(modelData.taskType)
                    radius: theme.cornerRadius

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 5

                        Text {
                            text: modelData.title
                            font.pixelSize: theme.fontSizeNormal
                            color: "white"
                            font.bold: true
                            Layout.fillWidth: true
                        }

                        Button {
                            text: "View"
                            onClicked: {
                                taskListDialog.close()
                                if (modelData.taskType === "workout") {
                                    workoutDialog.taskIndex = modelData.index
                                    workoutDialog.taskTitle = modelData.title
                                    workoutDialog.taskNotes = modelData.notes
                                    workoutDialog.open()
                                } else {
                                    notesDialog.taskIndex = modelData.index
                                    notesDialog.taskTitle = modelData.title
                                    notesDialog.taskNotes = modelData.notes
                                    notesDialog.open()
                                }
                            }
                        }
                    }
                }
            }
        }

        standardButtons: Dialog.Close
    }
}
