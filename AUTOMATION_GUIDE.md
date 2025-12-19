# Test Automation Guide for QtQuickTaskApp

This document explains how to automate testing of QtQuickTaskApp using Robot Framework and pywinauto.

## Prerequisites

### 1. Enable Qt Accessibility

Qt's accessibility framework must be enabled for automation to work. There are three ways to do this:

#### Option A: Command-Line Flag (Recommended for automation)
```bash
./QtQuickTaskApp --accessibility
# or
./QtQuickTaskApp -a
```

#### Option B: Environment Variable
```bash
# Linux/macOS
export QT_ACCESSIBILITY=1
./QtQuickTaskApp

# Windows
set QT_ACCESSIBILITY=1
QtQuickTaskApp.exe
```

#### Option C: Programmatically in Test Setup
Set the environment variable before starting the application process (see examples below).

**Note:** The accessibility flag must be set **before** the application starts, not after.

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
Login And Add Task - Method 1 (Using Command-Line Flag)
    [Documentation]    Test login flow and adding a task
    Start Process    ${APP_PATH}    --accessibility    alias=app
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

Login And Add Task - Method 2 (Using Environment Variable)
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

### Method 1: Using Command-Line Flag (Recommended)

```python
import time
from pywinauto.application import Application

# Start the application with accessibility flag
app = Application(backend='uia').start('QtQuickTaskApp.exe --accessibility')
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

### Method 2: Using Environment Variable

```python
import os
import time
import subprocess
from pywinauto.application import Application

# Set environment variable before starting the app
env = os.environ.copy()
env['QT_ACCESSIBILITY'] = '1'

# Start the application with modified environment
process = subprocess.Popen(['QtQuickTaskApp.exe'], env=env)
time.sleep(2)  # Wait for app to start

# Connect to the running application
app = Application(backend='uia').connect(title_re='.*QtQuickTaskApp.*')
main_window = app.window(title_re='.*QtQuickTaskApp.*')

# Wait for window to be ready
main_window.wait('ready', timeout=10)

# ... rest of the test code
```

### Method 3: Using pywinauto's start() with env parameter

```python
import os
import time
from pywinauto.application import Application

# Prepare environment with QT_ACCESSIBILITY
env = os.environ.copy()
env['QT_ACCESSIBILITY'] = '1'

# Start application with custom environment
# Note: This may not work with all pywinauto versions
import subprocess
process = subprocess.Popen(
    ['QtQuickTaskApp.exe'],
    env=env,
    creationflags=subprocess.CREATE_NEW_CONSOLE
)
time.sleep(2)

# Connect to the application
app = Application(backend='uia').connect(title_re='.*QtQuickTaskApp.*')
main_window = app.window(title_re='.*QtQuickTaskApp.*')
```

## Linux AT-SPI Example

### Method 1: Using Command-Line Flag (Recommended)

```python
import time
import subprocess

# Start application with accessibility flag
process = subprocess.Popen(['./QtQuickTaskApp', '--accessibility'])
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

### Method 2: Using Environment Variable

```python
import os
import time
import subprocess

# Set environment variable and start app
env = os.environ.copy()
env['QT_ACCESSIBILITY'] = '1'

process = subprocess.Popen(['./QtQuickTaskApp'], env=env)
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
    # ... (interact with elements using AT-SPI)
```

### Complete Test Example with pytest

```python
import os
import time
import subprocess
import pytest

@pytest.fixture
def app_process():
    """Fixture to start and stop the application with accessibility enabled"""
    # Method 1: Using command-line flag
    process = subprocess.Popen(['./QtQuickTaskApp', '--accessibility'])
    
    # Or Method 2: Using environment variable
    # env = os.environ.copy()
    # env['QT_ACCESSIBILITY'] = '1'
    # process = subprocess.Popen(['./QtQuickTaskApp'], env=env)
    
    time.sleep(2)  # Wait for app to start
    yield process
    process.terminate()
    process.wait()

def test_login_and_add_task(app_process):
    """Test login and task creation"""
    import pyatspi
    
    # Find application
    desktop = pyatspi.Registry.getDesktop(0)
    app = None
    for child in desktop:
        if 'QtQuickTaskApp' in child.name:
            app = child
            break
    
    assert app is not None, "Application not found"
    
    # Test interactions
    # ... (implement test logic)

```

## Programmatic Setup Summary

For test automation frameworks, there are **two recommended ways** to enable accessibility programmatically:

### ✅ Recommended: Use Command-Line Flag
```bash
./QtQuickTaskApp --accessibility
# or
./QtQuickTaskApp -a
```

**Advantages:**
- Clean and explicit
- No environment variable manipulation needed
- Works consistently across all platforms
- Easier to debug

**Examples:**
```python
# Python/subprocess
subprocess.Popen(['./QtQuickTaskApp', '--accessibility'])

# Robot Framework
Start Process    ${APP_PATH}    --accessibility
```

### ✅ Alternative: Set Environment Variable Before Process Start
```python
# Python
env = os.environ.copy()
env['QT_ACCESSIBILITY'] = '1'
subprocess.Popen(['./QtQuickTaskApp'], env=env)
```

**Advantages:**
- Works with older versions of the app
- Standard Qt approach

**Note:** Setting `os.environ['QT_ACCESSIBILITY'] = '1'` in the test script **will not work** if you then call `Application.start()` because the variable must be set in the child process's environment, not the parent test process.

## Tips for Successful Automation

1. **Choose the right method**: Use `--accessibility` flag (recommended) or set environment variable before process start
2. **Do NOT set environment after app starts** - it's too late, accessibility must be enabled at startup
2. **Do NOT set environment after app starts** - it's too late, accessibility must be enabled at startup
3. **Use unique Accessible.name values** - already implemented in this app
4. **Add delays** after actions for UI updates
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
