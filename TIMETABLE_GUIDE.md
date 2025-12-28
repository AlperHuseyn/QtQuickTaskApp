# Weekly Timetable View - User Guide

## Overview

The QtQuickTaskApp now includes a fully functional weekly timetable view that allows you to manage tasks based on specific days and hours throughout the week.

## Features

### 1. Grid-Based Layout
- **Rows**: Hours from 5:00 AM to 10:00 PM (18 time slots)
- **Columns**: Days of the week from Sunday to Saturday (7 days)
- Each cell represents a specific time slot on a specific day

### 2. Task Types and Color Coding

Tasks are color-coded based on their type:
- **Workout** (Green): `#27ae60`
- **Work** (Blue): `#3498db`
- **Meeting** (Purple): `#9b59b6`
- **Personal** (Orange): `#e67e22`
- **Other** (Gray): `#95a5a6`

### 3. Adding Tasks to the Timetable

1. **Navigate to Timetable View**: Click the "Timetable" tab button in the header
2. **Double-click on a cell**: This opens the "Add New Task" dialog
3. **Fill in task details**:
   - Task Title: Name of the task
   - Task Type: Select from workout, work, meeting, personal, or other
   - Notes: Optional notes about the task
4. **Click OK**: Task is added to the selected time slot

### 4. Viewing and Editing Task Details

#### For Workout Tasks:
- Double-click on a workout task (green) to open the "Workout Details" dialog
- View or edit workout notes
- Click "Save" to update the notes

#### For Other Task Types:
- Double-click on any non-workout task to open the "Task Notes" dialog
- View or edit task notes
- Click "Save" to update the notes

### 5. Multiple Tasks in One Cell

If a cell contains multiple tasks:
- Single-click to view a list of all tasks in that time slot
- Click "View" on any task to open its details dialog

### 6. Week Navigation

- **Previous Week**: Click "◄ Prev Week" button to view tasks from the previous week
- **Next Week**: Click "Next Week ►" button to view tasks for the next week
- **Current Week Display**: Shows the date range (e.g., "Dec 22 - Dec 28, 2025")

### 7. Task Persistence

All timetable tasks are automatically saved to JSON storage when:
- A new task is added
- Task notes are updated
- The application is closed

Tasks will be restored when you log back in.

### 8. Switching Between Views

- **Task List View**: Click "Task List" tab to see the traditional task list
- **Timetable View**: Click "Timetable" tab to see the weekly timetable

Both views share the same underlying data model, so tasks are synchronized.

## JSON Storage Format

Tasks are stored with the following fields:

```json
{
  "tasks": [
    {
      "title": "Morning Workout",
      "done": false,
      "day": 1,
      "hour": 6,
      "taskType": "workout",
      "notes": "30 min cardio + weights",
      "dateTime": "2025-12-22T06:00:00.000Z"
    },
    {
      "title": "Team Meeting",
      "done": false,
      "day": 2,
      "hour": 14,
      "taskType": "meeting",
      "notes": "Discuss Q4 planning",
      "dateTime": "2025-12-23T14:00:00.000Z"
    }
  ]
}
```

## Backward Compatibility

The application maintains backward compatibility with old task format:
- Old tasks (without day/hour/type) will appear in the Task List view
- They will have day=-1 and hour=-1 to indicate they're not timetable tasks
- New timetable tasks can coexist with old simple tasks

## Technical Implementation

### Backend (C++)

**TaskModel Extensions:**
- `addTimetableTask()`: Add task with day, hour, type, notes, and dateTime
- `getTasksForCell()`: Retrieve all tasks for a specific day/hour in a given week
- `updateTaskNotes()`: Update notes for an existing task
- `getTaskCount()`: Get count of tasks in a specific cell

**AppController:**
- Extended JSON serialization to include new fields
- Backward-compatible loading of old task format

### Frontend (QML)

**TimetableView.qml:**
- Grid layout with 8 columns (time + 7 days) and 19 rows (header + 18 hours)
- Week navigation state management
- Interactive dialogs for task creation and editing
- Double-click handlers for cell interaction
- Color-coded task display

**MainPage.qml:**
- Tab-based view switching
- Maintains both list and timetable views
- Shared controller for data consistency

## Accessibility

All interactive elements include accessibility properties:
- Accessible names for screen readers
- Accessible descriptions for context
- Proper roles (Button, Dialog, Cell, etc.)

## Example Usage Scenarios

### Scenario 1: Weekly Workout Schedule
1. Switch to Timetable view
2. Double-click on Monday 6:00 AM
3. Add "Morning Run" as a workout task
4. Add notes: "5K run in the park"
5. Repeat for other days/times

### Scenario 2: Work Meeting Schedule
1. Double-click on Tuesday 2:00 PM
2. Add "Project Review" as a meeting task
3. Add notes: "Review sprint progress with team"
4. The task appears in blue in the grid

### Scenario 3: Reviewing Past Weeks
1. Click "◄ Prev Week" to view last week's schedule
2. Double-click on any completed task to view notes
3. Navigate back to current week with "Next Week ►"

## Notes

- Tasks are tied to specific weeks through their dateTime field
- Week starts on Sunday (day=0) and ends on Saturday (day=6)
- Time slots are in 1-hour increments from 5 AM to 10 PM
- Multiple tasks can be scheduled in the same time slot
- Task colors help quickly identify task types at a glance
