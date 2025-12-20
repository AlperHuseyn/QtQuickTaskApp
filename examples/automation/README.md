# QtQuickTaskApp Automation Examples

This directory contains demonstration scripts showing how to automate QtQuickTaskApp for testing.

## Quick Start

**Important:** Accessibility is **enabled by default** - no special configuration needed!

### 1. Build the Application First

```bash
cd ../..
mkdir build
cd build
cmake ..
cmake --build .
```

### 2. Run Complete End-to-End Test (Recommended)

**Full automation workflow: Login → Create Task → Remove Task → Logout → Exit**

**Platform Note:** The complete end-to-end tests (`complete_test.py` and `complete_test.robot`) 
are **Windows-only** because they use pywinauto for Qt automation. 

**For Linux users:** Use `atspi_demo.py` instead (see section 3 below).

#### Windows (pywinauto) - REAL AUTOMATION
```bash
pip install pywinauto
python complete_test.py
```

#### Robot Framework - Complete Scenario (Windows only)
```bash
pip install robotframework pywinauto
robot complete_test.robot
```

### 3. Run Individual Demo Scripts

#### Simple Demo (All Platforms)
```bash
cd examples/automation
python3 demo_automation.py
```

#### Robot Framework Demo
```bash
pip install robotframework
robot demo_test.robot
```

#### Windows (pywinauto)
```bash
pip install pywinauto
python pywinauto_demo.py
```

#### Linux (AT-SPI)
```bash
pip install pyatspi2
# or: sudo apt-get install python3-pyatspi
python atspi_demo.py
```

## What Each Script Does

### `complete_test.py` ⭐ **RECOMMENDED** (Windows only)
- **Platform:** Windows only (pywinauto requires Windows for Qt automation)
- **For Linux:** Use `atspi_demo.py` instead
- **Type:** COMPLETE END-TO-END AUTOMATION TEST
- **Workflow:**
  1. Start application
  2. Login with username
  3. Create a new task
  4. Remove the task
  5. Logout (return to login screen)
  6. Exit application
- **Use case:** Real automated testing scenario demonstrating full workflow
- **Output:** Step-by-step console output with success/failure status

### `complete_test.robot` ⭐ **RECOMMENDED** (Windows only)
- **Platform:** Windows only (uses complete_test.py internally)
- **For Linux:** Use `atspi_demo.py` instead
- **Framework:** Robot Framework wrapper around Python/pywinauto automation
- **Type:** COMPLETE END-TO-END TEST with VISIBLE UI ACTIONS
- **Workflow:** 
  1. Runs complete_test.py Python script
  2. Shows REAL UI interactions (typing, clicking, navigation)
  3. You'll see all actions happening on screen!
- **Use case:** Robot Framework orchestration of full automation test
- **Advantage:** Combines Robot Framework reporting with real pywinauto UI automation

### `demo_automation.py`
- **Platform:** Cross-platform
- **Purpose:** Simple demonstration that starts the app and lists accessible elements
- **Use case:** Understanding what elements are available for automation
- **No dependencies:** Uses only standard library

### `demo_test.robot`
- **Platform:** Cross-platform
- **Framework:** Robot Framework
- **Purpose:** Shows Robot Framework test structure
- **Use case:** Starting point for Robot Framework test development

### `pywinauto_demo.py`
- **Platform:** Windows only
- **Framework:** pywinauto
- **Purpose:** Full automation workflow demonstration
- **Use case:** Complete example of logging in, adding tasks, and clearing completed items
- **Shows:**
  - Login with username
  - Adding multiple tasks
  - Marking tasks as complete
  - Clearing completed tasks

### `atspi_demo.py`
- **Platform:** Linux only
- **Framework:** pyatspi2 (AT-SPI)
- **Purpose:** Shows accessibility tree exploration
- **Use case:** Verifying elements are accessible on Linux

## Accessible Elements

All interactive elements have unique `Accessible.name` properties:

### Login Page
- `usernameField` - Username input
- `loginButton` - Login button
- `welcomeTitle` - Welcome text
- `loginPrompt` - Prompt text

### Main Page
- `taskInput` - New task input
- `addTaskButton` - Add task button
- `taskListView` - Task list
- `taskItem_N` - Task items (N = index)
- `taskCheckbox_N` - Task checkboxes
- `taskTitle_N` - Task titles
- `removeTaskButton_N` - Remove buttons
- `clearCompletedButton` - Clear completed button

## Troubleshooting

### Application Not Found
```
Error: Application not found at: ../../build/QtQuickTaskApp
```
**Solution:** Build the application first (see Quick Start #1)

### Elements Not Visible (Windows)
**Solution:** Use `inspect.exe` (Windows SDK) to verify accessibility tree

### Elements Not Visible (Linux) - AT-SPI Issues

If `atspi_demo.py` cannot find the application in the accessibility tree:

**Solution 1: Verify AT-SPI Setup**
```bash
# Check if AT-SPI is installed
dpkg -l | grep at-spi2-core

# Install if missing
sudo apt-get install at-spi2-core

# Restart AT-SPI bus launcher
pkill at-spi-bus-launcher
/usr/lib/at-spi2-core/at-spi-bus-launcher &
```

**Solution 2: Verify Qt Accessibility Plugin**
```bash
# Check if Qt accessibility bridge is installed
dpkg -l | grep libqt5accessibility5

# Install if missing (Debian/Ubuntu)
sudo apt-get install libqt5accessibility5 qt5-accessibility

# Set debug flag to see if plugin loads
export QT_DEBUG_PLUGINS=1
./build/QtQuickTaskApp

# Look for output mentioning "libqatspiplugin.so" or "accessibility"
```

**Solution 3: Use Accerciser for Manual Inspection**
```bash
# Install accessibility inspector tool
sudo apt-get install accerciser

# Run accerciser
accerciser &

# Then start your app
./build/QtQuickTaskApp

# In accerciser: Look for QtQuickTaskApp in the application tree
# Verify that UI elements with Accessible.name are visible
```

**Solution 4: Check Application Name Registration**
The `atspi_demo.py` script now lists all applications found in the accessibility tree.
If your app appears with a different name, the script will show it.

**Note:** Even if AT-SPI discovery fails, the application IS accessible - you can verify 
this manually with accerciser. The issue is typically with AT-SPI bus registration timing
or system configuration, not the application's accessibility implementation.

### pywinauto Import Error
```
Error: pywinauto not installed
```
**Solution:** `pip install pywinauto`

### pyatspi Import Error
```
Error: pyatspi2 not installed
```
**Solution:** `pip install pyatspi2` or `sudo apt-get install python3-pyatspi`

## Next Steps

1. **Review AUTOMATION_GUIDE.md** in the project root for detailed documentation
2. **Modify these scripts** to test your specific scenarios
3. **Integrate with CI/CD** using Robot Framework or pytest
4. **Extend with custom keywords** for reusable test components

## Example Workflow

Typical automation workflow demonstrated in `pywinauto_demo.py`:

```python
# 1. Start application (accessibility auto-enabled)
app = Application(backend='uia').start('QtQuickTaskApp.exe')

# 2. Find and interact with login elements
username_field = window.child_window(auto_id='usernameField')
username_field.set_text('TestUser')
login_button = window.child_window(auto_id='loginButton')
login_button.click()

# 3. Add tasks
task_input = window.child_window(auto_id='taskInput')
task_input.set_text('My Task')
add_button = window.child_window(auto_id='addTaskButton')
add_button.click()

# 4. Interact with task items
checkbox = window.child_window(auto_id='taskCheckbox_0')
checkbox.click()

# 5. Clear completed
clear_button = window.child_window(auto_id='clearCompletedButton')
clear_button.click()
```

## Contributing

Feel free to enhance these examples or add new ones for different automation frameworks!
