# Test Automation Guide for QtQuickTaskApp

This document explains how to automate testing of QtQuickTaskApp using Robot Framework and pywinauto.

## Important: Accessibility is Enabled by Default

**QtQuickTaskApp now has accessibility enabled by default**, making it immediately ready for automation testing with Robot Framework, pywinauto, and screen readers. No special configuration is required!

If you need to disable accessibility for any reason, use:
```bash
./QtQuickTaskApp --no-accessibility
```

## Prerequisites

### 1. Qt Accessibility (Already Enabled!)

The application automatically enables Qt's accessibility framework on startup. You can simply start the application normally:

```bash
./QtQuickTaskApp
```

**Optional:** You can still explicitly control accessibility using these methods:

#### Disable Accessibility
```bash
./QtQuickTaskApp --no-accessibility
```

#### Force Enable via Environment Variable (if overriding system settings)
```bash
# Linux/macOS
export QT_ACCESSIBILITY=1
./QtQuickTaskApp

# Windows
set QT_ACCESSIBILITY=1
QtQuickTaskApp.exe
```

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

Run your application and use these tools to verify that all elements are visible in the accessibility tree with their assigned names.

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
    # No special flags needed - accessibility is enabled by default!
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

**Note:** Accessibility is enabled by default, so you can simply start the application normally!

```python
import time
from pywinauto.application import Application

# Start the application - accessibility is enabled by default!
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

**Note:** Accessibility is enabled by default!

```python
import time
import subprocess

# Start application - accessibility is enabled by default!
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

### Complete Test Example with pytest

```python
import time
import subprocess
import pytest

@pytest.fixture
def app_process():
    """Fixture to start and stop the application"""
    # Accessibility is enabled by default!
    process = subprocess.Popen(['./QtQuickTaskApp'])
    
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

## Accessibility Configuration

### Default Behavior
**Accessibility is now enabled by default!** Simply start the application normally:

```bash
./QtQuickTaskApp
```

```python
# Python/subprocess
subprocess.Popen(['./QtQuickTaskApp'])

# Robot Framework
Start Process    ${APP_PATH}
```

### Disabling Accessibility (if needed)
If you need to disable accessibility for performance testing or other reasons:

```bash
./QtQuickTaskApp --no-accessibility
```

### Advanced: Manual Control via Environment Variable
You can still override the default behavior using environment variables:

```python
# Force enable (though already enabled by default)
env = os.environ.copy()
env['QT_ACCESSIBILITY'] = '1'
subprocess.Popen(['./QtQuickTaskApp'], env=env)

# Force disable
env = os.environ.copy()
env['QT_ACCESSIBILITY'] = '0'
subprocess.Popen(['./QtQuickTaskApp'], env=env)
```

## Tips for Successful Automation

1. **No special setup needed** - accessibility is enabled by default!
2. **Use unique Accessible.name values** - already implemented in this app
3. **Add delays** after actions for UI updates
4. **Use Inspect.exe/Accerciser** to verify element visibility
5. **Consider dynamic elements** - task items use index-based naming (taskItem_0, taskItem_1, etc.)
6. **Test on target platform** - accessibility differs between Windows/Linux/macOS

## Troubleshooting

### Elements Not Visible
- Accessibility should be enabled by default - verify the app started normally
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
