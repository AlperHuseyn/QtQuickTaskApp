# Test Automation Guide for QtQuickTaskApp

This document explains how to automate testing of QtQuickTaskApp using Robot Framework and pywinauto.

## Prerequisites

### 1. Enable Qt Accessibility

Before running the application, you **must** enable Qt's accessibility framework:

#### Linux:
```bash
export QT_ACCESSIBILITY=1
./QtQuickTaskApp
```

#### Windows:
```cmd
set QT_ACCESSIBILITY=1
QtQuickTaskApp.exe
```

Or set it programmatically in your test setup.

### 2. Install Required Tools

```bash
# Install Robot Framework
pip install robotframework

# Install pywinauto for Windows automation
pip install pywinauto

# For Linux, use AT-SPI/pyatspi2
pip install pyatspi2

# Optional: Install Robot Framework library for pywinauto
pip install robotframework-pywinautoLibrary
```

## Accessibility Properties

All interactive elements in the application now have `Accessible.name` and `Accessible.role` properties:

### LoginPage Elements:
- `loginPage` - Main login page container
- `welcomeTitle` - "Welcome to TaskApp" text
- `loginPrompt` - "Please enter your name to continue" text
- `usernameField` - Username input field
- `loginButton` - Login button

### MainPage Elements:
- `mainPage` - Main task management page container
- `welcomeMessage` - "Welcome, [username]!" text
- `taskCounter` - Task count display
- `taskInput` - New task input field
- `addTaskButton` - Add task button
- `taskListView` - Task list container
- `taskItem_[N]` - Individual task items (N = index)
- `taskCheckbox_[N]` - Checkbox for task N
- `taskTitle_[N]` - Title text for task N
- `removeTaskButton_[N]` - Remove button for task N
- `clearCompletedButton` - Clear completed tasks button
- `emptyStateMessage` - "No tasks yet" message

### Menu Elements:
- `mainMenuBar` - Main menu bar
- `fileMenu` - File menu
- `logoutAction` - Logout action
- `exitAction` - Exit action

## Verifying Accessibility

### Windows:
Use **Inspect.exe** (comes with Windows SDK):
```cmd
inspect.exe
```

### Linux:
Use **Accerciser**:
```bash
sudo apt-get install accerciser
accerciser
```

Run your application with `QT_ACCESSIBILITY=1` and use these tools to verify that all elements are visible in the accessibility tree with their assigned names.

## Example Robot Framework Test

```robot
*** Settings ***
Library    OperatingSystem
Library    Process

*** Variables ***
${APP_PATH}    /path/to/QtQuickTaskApp

*** Test Cases ***
Login And Add Task
    [Documentation]    Test login flow and adding a task
    Set Environment Variable    QT_ACCESSIBILITY    1
    Start Process    ${APP_PATH}    alias=app
    Sleep    2s    # Wait for app to start
    
    # Login
    Input Text To Element    usernameField    TestUser
    Click Element    loginButton
    Sleep    1s    # Wait for navigation
    
    # Add Task
    Input Text To Element    taskInput    Buy groceries
    Click Element    addTaskButton
    Sleep    0.5s
    
    # Verify task was added
    Element Should Be Visible    taskItem_0
    Element Text Should Be    taskTitle_0    Buy groceries
    
    # Cleanup
    Terminate Process    app

Toggle Task Completion
    [Documentation]    Test toggling task completion status
    # ... (setup code)
    
    Click Element    taskCheckbox_0
    Sleep    0.5s
    
    # Verify task is marked as completed
    # (Implementation depends on your automation library)

Clear Completed Tasks
    [Documentation]    Test clearing completed tasks
    # ... (setup code)
    
    Click Element    taskCheckbox_0
    Sleep    0.5s
    Click Element    clearCompletedButton
    Sleep    0.5s
    
    # Verify task is removed
    Element Should Not Exist    taskItem_0
```

## Example pywinauto Script (Windows)

```python
import os
import time
from pywinauto.application import Application

# Enable accessibility
os.environ['QT_ACCESSIBILITY'] = '1'

# Start the application
app = Application(backend='uia').start('QtQuickTaskApp.exe')
main_window = app.window(title_re='.*QtQuickTaskApp.*')

# Wait for window to be ready
main_window.wait('ready', timeout=10)

# Login
username_field = main_window.child_window(auto_id='usernameField', control_type='Edit')
username_field.set_text('TestUser')

login_button = main_window.child_window(auto_id='loginButton', control_type='Button')
login_button.click()

time.sleep(1)  # Wait for navigation

# Add a task
task_input = main_window.child_window(auto_id='taskInput', control_type='Edit')
task_input.set_text('Buy groceries')

add_button = main_window.child_window(auto_id='addTaskButton', control_type='Button')
add_button.click()

time.sleep(0.5)

# Verify task was added
task_item = main_window.child_window(auto_id='taskItem_0')
assert task_item.exists(), "Task was not added"

# Toggle task completion
checkbox = main_window.child_window(auto_id='taskCheckbox_0', control_type='CheckBox')
checkbox.click()

time.sleep(0.5)

# Clear completed tasks
clear_button = main_window.child_window(auto_id='clearCompletedButton', control_type='Button')
clear_button.click()

print("Test completed successfully!")
```

## Linux AT-SPI Example

```python
import os
import time
import subprocess

# Enable accessibility
os.environ['QT_ACCESSIBILITY'] = '1'

# Start application
process = subprocess.Popen(['./QtQuickTaskApp'])
time.sleep(2)

# Use pyatspi2 to interact with elements
import pyatspi

# Find the application
desktop = pyatspi.Registry.getDesktop(0)
app = None
for child in desktop:
    if 'QtQuickTaskApp' in child.name:
        app = child
        break

if app:
    # Find username field by accessible name
    username_field = app.queryInterface(pyatspi.ATSPI_ACCESSIBLE).getChildAtIndex(0)
    # ... (interact with elements using AT-SPI)
```

## Tips for Successful Automation

1. **Always set QT_ACCESSIBILITY=1** before starting the app
2. **Use unique Accessible.name values** - already implemented in this app
3. **Add delays** after actions for UI updates
4. **Use Inspect.exe/Accerciser** to verify element visibility
5. **Consider dynamic elements** - task items use index-based naming (taskItem_0, taskItem_1, etc.)
6. **Test on target platform** - accessibility differs between Windows/Linux/macOS

## Troubleshooting

### Elements Not Visible
- Verify `QT_ACCESSIBILITY=1` is set
- Check Qt version supports accessibility (Qt 5.15+)
- Use inspection tools to verify accessibility tree

### Cannot Find Element by Name
- Check exact Accessible.name in QML files
- Verify element is currently visible (not hidden or in different screen)
- Check element hierarchy in inspection tools

### Timing Issues
- Add appropriate delays after navigation/actions
- Use wait conditions instead of fixed sleeps
- Qt animations may require waiting for completion

## Additional Resources

- [Qt Accessibility Documentation](https://doc.qt.io/qt-5/accessible.html)
- [Robot Framework User Guide](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html)
- [pywinauto Documentation](https://pywinauto.readthedocs.io/)
- [AT-SPI Documentation](https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/)
