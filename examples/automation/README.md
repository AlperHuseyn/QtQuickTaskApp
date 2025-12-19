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

#### Windows (pywinauto) - REAL AUTOMATION
```bash
pip install pywinauto
python complete_test.py
```

#### Robot Framework - Complete Scenario
```bash
pip install robotframework
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

### `complete_test.py` ⭐ **RECOMMENDED**
- **Platform:** Windows (pywinauto)
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

### `complete_test.robot` ⭐ **RECOMMENDED**
- **Platform:** Cross-platform
- **Framework:** Robot Framework
- **Type:** COMPLETE END-TO-END TEST SCENARIO
- **Workflow:** Same as complete_test.py (Login → Create → Remove → Logout → Exit)
- **Use case:** Robot Framework version of complete automation test
- **Note:** Shows structure and keywords for real implementation

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

### Elements Not Visible (Linux)
**Solution:** 
1. Install accerciser: `sudo apt-get install accerciser`
2. Run accerciser to inspect the application
3. Verify AT-SPI is enabled on your system

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
