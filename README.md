# QtQuickTaskApp

A fully functional task management application built with Qt Quick (QML) and C++, demonstrating modern Qt application development with data persistence and multi-screen navigation.

## Features

### 1. Login Screen
- User-friendly login interface with username input
- Persistent username storage using `SettingsStore` (QSettings)
- Smooth transition to the main task management screen
- Modern gradient design

### 2. Task Management
- **Add Tasks**: Create new tasks with a simple input field
- **Toggle Completion**: Mark tasks as complete/incomplete with checkboxes
- **Remove Tasks**: Delete individual tasks
- **Clear Completed**: Remove all completed tasks at once
- **Task Counter**: See the number of active tasks at a glance
- **Data Persistence**: All tasks are automatically saved and loaded using JSON storage

### 3. Navigation
- Smooth page transitions using `StackView`
- Logout functionality to return to the login screen
- Menu bar with File menu (Logout, Exit)

### 4. Modern UI Design
- Clean and polished interface
- Smooth animations and transitions
- Color-coded task states (completed tasks appear grayed out)
- Responsive layout with proper spacing

### 5. Accessibility & Test Automation
- **Full accessibility support** for screen readers and automation tools
- **Enabled by default** - no configuration needed!
- All interactive elements have `Accessible.name` and `Accessible.role` properties
- Compatible with pywinauto for automated testing
- Supports AT-SPI (Linux) and IAccessible2 (Windows) protocols
- **Automation script available**: [examples/automation/complete_test.py](examples/automation/complete_test.py)

## Architecture

### QML Components
- **Main.qml**: Application window and navigation manager using StackView
- **LoginPage.qml**: User login interface
- **MainPage.qml**: Task management interface

### C++ Backend
- **AppController**: Manages task persistence (load/save to JSON)
- **TaskModel**: QAbstractListModel for task data management
- **SettingsStore**: Singleton for user preferences (username)

### Key Integrations
- QML/C++ integration using Q_PROPERTY and Q_INVOKABLE
- Signal-slot connections for UI interactions
- Automatic data persistence on every change
- QSettings for user preferences
- JSON file storage for tasks

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
cd examples/automation
python complete_test.py
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
# Windows: Complete automation test
pip install pywinauto
python examples/automation/complete_test.py

# Robot Framework: Complete test scenario
pip install robotframework
robot examples/automation/complete_test.robot
```

**Individual demos:**

```bash
# Simple demo (all platforms)
python3 examples/automation/demo_automation.py

# Robot Framework test structure
robot examples/automation/demo_test.robot

# Windows: Step-by-step demo
python examples/automation/pywinauto_demo.py
```

See [examples/automation/README.md](examples/automation/README.md) for details.

## Usage Flow

1. **First Launch**: The app opens to the login screen
   - Enter your username
   - Click "Login" to proceed

2. **Task Management**: After login, you can:
   - Add new tasks by typing in the input field and clicking "Add Task" or pressing Enter
   - Check/uncheck tasks to toggle their completion status
   - Click "Remove" on any task to delete it
   - Click "Clear Completed Tasks" to remove all completed tasks at once

3. **Logout**: Use the File menu to logout and return to the login screen

## Data Storage

- **Username**: Stored in system settings (QSettings)
  - Location depends on OS (e.g., registry on Windows, config files on Linux/macOS)
- **Tasks**: Stored in JSON format at:
  - `$HOME/.local/share/MyOrganization/QtQuickTaskApp/tasks.json` (Linux)
  - `%APPDATA%\MyOrganization\QtQuickTaskApp\tasks.json` (Windows)
  - `~/Library/Application Support/MyOrganization/QtQuickTaskApp/tasks.json` (macOS)

## Project Structure

```
QtQuickTaskApp/
├── CMakeLists.txt          # Build configuration
├── src/
│   ├── main.cpp           # Application entry point
│   ├── appcontroller.h/cpp # Task persistence controller
│   ├── taskmodel.h/cpp    # Task data model
│   └── settingsstore.h/cpp # User settings management
└── qml/
    ├── Main.qml           # Main application window
    ├── LoginPage.qml      # Login screen
    ├── MainPage.qml       # Task management screen
    └── qml.qrc            # Qt resource file
```

## License

This is a demonstration project for learning Qt Quick application development.
