# QtQuickTaskApp

A fully functional task management application built with Qt Quick (QML) and C++, demonstrating modern Qt application development with data persistence, multi-screen navigation, and a weekly timetable view.

## Features

### 1. Login Screen
- User-friendly login interface with username input
- Persistent username storage using `SettingsStore` (QSettings)
- Smooth transition to the main task management screen
- Modern gradient design

### 2. Task Management - List View
- **Add Tasks**: Create new tasks with a simple input field
- **Toggle Completion**: Mark tasks as complete/incomplete with checkboxes
- **Remove Tasks**: Delete individual tasks
- **Clear Completed**: Remove all completed tasks at once
- **Task Counter**: See the number of active tasks at a glance
- **Data Persistence**: All tasks are automatically saved and loaded using JSON storage

### 3. Weekly Timetable View ⭐ NEW
- **Grid-Based Layout**: Visual timetable with rows for hours (5:00 AM - 10:00 PM) and columns for days (Sunday - Saturday)
- **Color-Coded Tasks**: Tasks are color-coded by type:
  - 🟢 Workout (Green)
  - 🔵 Work (Blue)
  - 🟣 Meeting (Purple)
  - 🟠 Personal (Orange)
  - ⚪ Other (Gray)
- **Interactive Cells**: Double-click cells to add new tasks or view/edit existing ones
- **Week Navigation**: Navigate between different weeks with Previous/Next buttons
- **Task Details Dialogs**:
  - Workout Details dialog for workout tasks with notes
  - Task Notes dialog for other task types
- **Multiple Tasks per Cell**: View and manage multiple tasks scheduled for the same time slot
- **Smart Week Filtering**: Tasks are automatically filtered by the selected week
- See [TIMETABLE_GUIDE.md](TIMETABLE_GUIDE.md) for detailed usage instructions

### 4. Navigation
- **Tab-Based View Switching**: Seamlessly switch between Task List and Timetable views
- Smooth page transitions using `StackView`
- Logout functionality to return to the login screen
- Menu bar with File menu (Logout, Exit)

### 5. Modern UI Design
- Clean and polished interface
- Smooth animations and transitions
- Color-coded task states (completed tasks appear grayed out)
- Responsive layout with proper spacing

### 6. Accessibility & Test Automation
- **Full accessibility support** for screen readers and automation tools
- **Enabled by default** - no configuration needed!
- All interactive elements have `Accessible.name` and `Accessible.role` properties
- Compatible with pywinauto for automated testing
- Supports AT-SPI (Linux) and IAccessible2 (Windows) protocols
- **Automation script available**: [examples/automation/complete_test.py](demos/automation-scripts/e2e_test.py)

## Architecture

### QML Components
- **AppEntry.qml**: Application window and navigation manager using StackView
- **LoginPage.qml**: User login interface
- **MainPage.qml**: Task management interface with tab-based view switching
- **TimetableView.qml**: Weekly timetable grid view with interactive cells and dialogs

### C++ Backend
- **AppController**: Manages task persistence (load/save to JSON)
- **TaskModel**: QAbstractListModel for task data management with extended support for:
  - Day/hour-based task scheduling
  - Task types (workout, work, meeting, personal, other)
  - Task notes
  - Week-based filtering
- **SettingsStore**: Singleton for user preferences (username)

### Key Integrations
- QML/C++ integration using Q_PROPERTY and Q_INVOKABLE
- Signal-slot connections for UI interactions
- Automatic data persistence on every change
- QSettings for user preferences
- Enhanced JSON file storage for tasks with backward compatibility

### Task Data Model
Each task now supports:
- **title**: Task name/description
- **done**: Completion status
- **day**: Day of week (0-6, Sunday-Saturday, -1 for non-timetable tasks)
- **hour**: Hour of day (5-22 for 5 AM-10 PM, -1 for non-timetable tasks)
- **taskType**: Category (workout, work, meeting, personal, other)
- **notes**: Additional details or instructions
- **dateTime**: ISO 8601 timestamp for week navigation

## Building the Application

### Requirements
- Qt 5.15 or later
- CMake 3.16 or later
- C++17 compatible compiler

### Build Instructions

```bash
mkdir build
cd build
cmake ..
cmake --build .
```

### Running
```bash
./QtQuickTaskApp
```

**Note:** Accessibility is **enabled by default** for automation and screen reader support.

### Disabling Accessibility (if needed)

If you need to disable accessibility for performance reasons:

```bash
./QtQuickTaskApp --no-accessibility
```

Or set the environment variable to 0:
```bash
export QT_ACCESSIBILITY=0  # Linux/macOS
./QtQuickTaskApp
```

### Automated Testing

The application includes a complete end-to-end automation test script using pywinauto:

```bash
cd demos/automation-scripts
python e2e_test.py
```

The script demonstrates:
- Login flow
- Task creation and management
- Task removal
- Logout and exit
- Full Windows UI Automation integration

## Quick Automation Demo

**Complete End-to-End Test (Login → Create Task → Remove → Logout → Exit):**

```bash
# Windows: Complete automation-scripts test
pip install pywinauto
python demos/automation-scripts/e2e_test.py

# Robot Framework: Complete test scenario
pip install robotframework
robot demos/automation-scripts/complete_test.robot
```

**Individual demos:**

```bash
# Simple demo (all platforms)
python3 demos/automation-scripts/demo_automation.py

# Robot Framework test structure
robot demos/automation-scripts/demo_test.robot

# Windows: Step-by-step demo
python demos/automation-scripts/pywinauto_demo.py
```

See [examples/automation/README.md](demos/automation-scripts/README.md) for details.

## Usage Flow

1. **First Launch**: The app opens to the login screen
   - Enter your username
   - Click "Login" to proceed

2. **Task Management**: After login, you have two views available:

   **Task List View** (default):
   - Add new tasks by typing in the input field and clicking "Add Task" or pressing Enter
   - Check/uncheck tasks to toggle their completion status
   - Click "Remove" on any task to delete it
   - Click "Clear Completed Tasks" to remove all completed tasks at once
   
   **Weekly Timetable View**:
   - Click the "Timetable" tab to switch to the timetable view
   - Navigate between weeks using "◄ Prev Week" and "Next Week ►" buttons
   - Double-click on any cell to add a new task for that specific day and hour
   - Select task type (workout, work, meeting, personal, other) and add notes
   - Double-click on existing tasks to view or edit their notes
   - Tasks are color-coded by type for easy visual identification

3. **Logout**: Use the File menu to logout and return to the login screen

## Testing with Sample Data

To test the timetable view with sample data:

```bash
cd demos
python3 generate_sample_timetable_data.py

# Copy the generated file to your tasks location
# Linux: ~/.local/share/MyOrganization/QtQuickTaskApp/
# Windows: %APPDATA%\MyOrganization\QtQuickTaskApp\
# macOS: ~/Library/Application Support/MyOrganization/QtQuickTaskApp/
```

This will generate a `sample_tasks.json` file with various timetable tasks scheduled throughout the week, including workouts, meetings, and personal tasks.

## Data Storage

- **Username**: Stored in system settings (QSettings)
  - Location depends on OS (e.g., registry on Windows, config files on Linux/macOS)
- **Tasks**: Stored in JSON format at:
  - `$HOME/.local/share/MyOrganization/QtQuickTaskApp/tasks_<username>.json` (Linux)
  - `%APPDATA%\MyOrganization\QtQuickTaskApp\tasks_<username>.json` (Windows)
  - `~/Library/Application Support/MyOrganization/QtQuickTaskApp/tasks_<username>.json` (macOS)
  
### JSON Task Format

```json
{
  "tasks": [
    {
      "title": "Morning Workout",
      "done": false,
      "day": 1,
      "hour": 6,
      "taskType": "workout",
      "notes": "30 min cardio",
      "dateTime": "2025-12-29T06:00:00.000Z"
    }
  ]
}
```

## Project Structure

```
QtQuickTaskApp/
├── CMakeLists.txt                    # Build configuration
├── README.md                         # Project documentation
├── TIMETABLE_GUIDE.md               # Timetable feature guide
├── demos/
│   └── generate_sample_timetable_data.py  # Sample data generator
├── src/
│   ├── main.cpp                     # Application entry point
│   ├── controllers/
│   │   ├── appcontroller.h/cpp     # Task persistence controller
│   ├── models/
│   │   └── taskmodel.h/cpp         # Extended task data model
│   └── services/
│       └── settingsstore.h/cpp     # User settings management
└── qml/
    ├── AppTheme.qml                 # Application theme
    ├── qml.qrc                      # Qt resource file
    └── screens/
        ├── AppEntry.qml             # Main application window
        ├── LoginPage.qml            # Login screen
        ├── MainPage.qml             # Task management with tabs
        └── TimetableView.qml        # Weekly timetable view
```

## License

This is a demonstration project for learning Qt Quick application development.
