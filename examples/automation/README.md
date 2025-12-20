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
# For Qt5:
dpkg -l | grep qt5

# For Qt6:
dpkg -l | grep qt6

# Install Qt5 accessibility bridge (Debian/Ubuntu)
# Note: Package names vary by distribution and Qt version
sudo apt-get install qtbase5-dev libqt5gui5

# The AT-SPI plugin is usually included in Qt base packages
# If you built Qt from source, ensure plugins were built

# Verify plugin exists
find /usr/lib -name "libqatspiplugin.so" 2>/dev/null
find /usr/lib/x86_64-linux-gnu/qt5/plugins -name "*atspi*" 2>/dev/null

# Set debug flag to see if plugin loads
export QT_DEBUG_PLUGINS=1
./build/QtQuickTaskApp 2>&1 | grep -i atspi

# Look for lines like:
#   "QFactoryLoader::QFactoryLoader() checking directory path..."
#   "loaded library libqatspiplugin.so"
```

**Solution 2b: Qt May Need Explicit Platform Plugin Path**
```bash
# If plugin exists but doesn't load, set plugin path explicitly
export QT_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/qt5/plugins:$QT_PLUGIN_PATH
export QT_QPA_PLATFORMTHEME=gtk3

# Or for custom Qt builds:
export QT_PLUGIN_PATH=/path/to/your/qt/plugins:$QT_PLUGIN_PATH

# Then run the app
./build/QtQuickTaskApp
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

### Common Issue: "Could not find application in accessibility tree" on Ubuntu/Linux

This is the most common issue with AT-SPI on Linux. **Root cause:** Ubuntu's standard Qt5 packages often don't include the `libqatspiplugin.so` accessibility plugin.

**Step 1: Verify the plugin file exists**
```bash
# Search for Qt AT-SPI plugin
find /usr/lib -name "libqatspiplugin.so" 2>/dev/null
find /usr/lib/x86_64-linux-gnu -name "*atspi*" 2>/dev/null

# Check your Qt plugin directory
qmake -query QT_INSTALL_PLUGINS  # Shows where Qt looks for plugins
ls -la $(qmake -query QT_INSTALL_PLUGINS)/platformaccessibility/

# If the directory doesn't exist or is empty:
# → Ubuntu's Qt5 doesn't include the accessibility plugin by default
# → AT-SPI automation won't work without this plugin
```

**Step 2: Enable plugin debugging**
```bash
export QT_DEBUG_PLUGINS=1
./build/QtQuickTaskApp 2>&1 | grep -i "atspi\|accessibility"

# Look for messages like:
#   "loaded library 'libqatspiplugin.so'"  ← Plugin loads successfully
#   "Cannot load library"                  ← Plugin failed to load
#   No mentions of atspi                   ← Plugin not found
```

**Step 3: Use accerciser (Visual Verification)**
```bash
# You already have accerciser installed - this is the BEST diagnostic tool
accerciser &

# In a new terminal:
./build/QtQuickTaskApp

# In accerciser window:
#   → If QtQuickTaskApp appears: AT-SPI is working! The pyatspi script has a timing issue.
#   → If it doesn't appear: Qt accessibility plugin isn't loading properly.
```

**Step 4: If plugin doesn't exist (Ubuntu's Qt5 limitation)**

**The Reality:** Ubuntu's standard Qt5 packages (`qtbase5-dev`, `libqt5gui5`) often **do not include** the `platformaccessibility` plugin directory or `libqatspiplugin.so` file.

**Options if plugin is missing:**

```bash
# Option A: Try Qt6 (may have better accessibility support)
sudo apt-get install qt6-base-dev
# Then rebuild your app with Qt6

# Option B: Use the cross-platform demo instead
# This shows accessible properties without requiring AT-SPI
python demo_automation.py

# Option C: Build Qt5 from source with accessibility enabled
# (Advanced - requires compiling Qt from source with -feature-accessibility)

# Option D: Use Windows for full pywinauto automation
# Windows Qt distributions include accessibility support by default
```

**Important:** The application HAS proper `Accessible.name` and `Accessible.role` properties - this is verified in the code. The limitation is that Ubuntu's Qt5 packages don't provide the bridge to expose these to AT-SPI.

**Step 5: Alternative - Check if this is a pyatspi timing issue**
```bash
# Sometimes the app registers but pyatspi misses it
# The atspi_demo.py now waits 30 seconds for manual inspection
python atspi_demo.py

# While it's waiting, open accerciser to see if the app is there
# If yes in accerciser but no in pyatspi → timing/bus issue, not app issue
```

**Understanding the Issue:**
- The Qt app **does** enable accessibility in code (see main.cpp - `QAccessible::setActive(true)`)
- The app **does** have proper `Accessible.name` and `Accessible.role` on all elements
- **BUT** Qt needs the `libqatspiplugin.so` plugin to bridge Qt → AT-SPI on Linux
- This plugin is **missing** from standard Ubuntu Qt5 installations
- Without this plugin, Qt apps can't register with the AT-SPI accessibility bus
- **The accessibility properties work on Windows** (where the plugin exists)

**Verification Strategy:**
1. ✅ Code has accessibility enabled: Check main.cpp
2. ✅ Elements have Accessible properties: Review QML files
3. ❌ Qt has AT-SPI bridge plugin: Missing on Ubuntu Qt5 by default
4. Result: Accessibility works in Windows, but not exposed to AT-SPI on Linux without plugin

**For your Ubuntu setup:** Use `demo_automation.py` to verify accessible properties exist, but understand that full AT-SPI automation requires a Qt build with the accessibility plugin included.

**Quick Check - Does Qt Have AT-SPI Support?**
```bash
# Check what Qt was built with
qmake -query  # or qmake-qt5 -query
# Look for QT_INSTALL_PLUGINS path

ls -la $(qmake -query QT_INSTALL_PLUGINS)/platformaccessibility/
# Should show libqatspiplugin.so
```

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
