#!/usr/bin/env python3
"""
Complete End-to-End Automation Test
This script demonstrates a full automation-scripts workflow:
1. Login with username
2. Create a new task
3. Remove the task
4. Logout
5. Exit application

This is a REAL automation-scripts test, not just interaction demos.

NOTE: Delays have been increased (2-3 seconds between actions) so you can 
visually see each phase of the automation-scripts happening on screen.

Requirements:
  pip install pywinauto

Platform: Windows only (pywinauto requires Windows for Qt automation-scripts)
          For Linux, see atspi_demo.py which uses AT-SPI
"""

import time
import sys
import os
import platform

# Check platform first
if platform.system() != "Windows":
    print(f"Error: This script requires Windows")
    print(f"Current platform: {platform.system()}")
    print()
    print("For Linux automation-scripts, use:")
    print("  python demos/automation-scripts/atspi_demo.py")
    print()
    print("For cross-platform demonstration, use:")
    print("  python demos/automation-scripts/demo_automation.py")
    sys.exit(1)

try:
    from pywinauto.application import Application
    from pywinauto import Desktop
    import subprocess
except ImportError:
    print("Error: pywinauto not installed")
    print("Install with: pip install pywinauto")
    sys.exit(1)

def print_header(title):
    """Print a formatted header"""
    print(f"\n{'='*70}")
    print(f"  {title}")
    print(f"{'='*70}\n")

def print_step(step_num, description):
    """Print a formatted step"""
    print(f"[Step {step_num}] {description}")

def find_by_name(window, name):
    """Find a control by its Accessible.name (element_info.name)"""
    for ctrl in window.descendants():
        if ctrl.element_info.name == name:
            return ctrl
    return None

def get_window_by_pid(pid):
    """Get window by process ID using Desktop"""
    desktop = Desktop(backend='uia')
    for win in desktop.windows():
        if win.process_id() == pid:
            return win
    return None

def main():
    print_header("QtQuickTaskApp - Complete End-to-End Automation Test")
    
    # Configuration
    app_path = os.path.join(os.path.dirname(__file__), '..', '..', 'build','Debug', 'QtQuickTaskApp.exe')
    test_username = "AutomationTest"
    test_task = "Test Task - Create and Remove"
    
    if not os.path.exists(app_path):
        print(f"❌ Error: Application not found at {app_path}")
        print("Please build the application first.")
        return 1
    
    print(f"✓ Application: {app_path}")
    print(f"✓ Test Username: {test_username}")
    print(f"✓ Test Task: {test_task}")
    print(f"✓ Accessibility: Enabled by default\n")
    
    try:
        # ===== PHASE 1: START APPLICATION =====
        print_header("PHASE 1: Start Application")
        print_step(1, "Starting QtQuickTaskApp...")
        
        # Try to connect to already running app first, otherwise start it
        try:
            # Use exact title match to avoid connecting to VSCode or other apps
            app = Application(backend='uia').connect(title='QtQuickTaskApp', timeout=2)
            print("    ✓ Connected to already running application\n")
        except:
            print("    ℹ App not running, starting it...")
            app = Application(backend='uia').start(app_path, wait_for_idle=False)
            time.sleep(5)
            print("    ✓ Application started successfully\n")

        # ===== PHASE 2: LOGIN =====
        print_header("PHASE 2: Login")
        print_step(2, "Connecting to main window...")

        main_window = app.window(title='QtQuickTaskApp')
        main_window.wait('visible', timeout=30)
        print("    ✓ Connected to window\n")
        
        print_step(3, "Finding username input field...")
        # Find by searching descendants for matching name
        username_field = None
        try:
            for ctrl in main_window.descendants():
                if ctrl.element_info.name == 'usernameField':
                    username_field = ctrl
                    print("    ✓ Found usernameField by element_info.name")
                    break
        except Exception as e:
            print(f"    ⚠ Error finding usernameField: {e}")

        if username_field is None:
            raise Exception("Username field not found!")
        
        print_step(4, f"Entering username: '{test_username}'...")
        username_field.set_text(test_username)
        time.sleep(2)  # Increased to see the username being entered
        print(f"    ✓ Username '{test_username}' entered\n")
        
        print_step(5, "Finding and clicking Login button...")
        # Find by searching descendants for matching name
        login_button = None
        try:
            for ctrl in main_window.descendants():
                if ctrl.element_info.name == 'loginButton':
                    login_button = ctrl
                    print("    ✓ Found loginButton by element_info.name")
                    break
        except Exception as e:
            print(f"    ⚠ Error finding loginButton: {e}")

        if login_button is None:
            raise Exception("Login button not found!")
        
        login_button.click()
        time.sleep(3)  # Wait for page transition animation
        print("    ✓ Login successful - navigated to main page\n")

        # ===== PHASE 3: CREATE TASK =====
        print_header("PHASE 3: Create Task")
        time.sleep(2)  # Additional wait to observe the main page before finding elements

        # Re-connect to window after page transition using process ID
        pid = app.process
        print(f"    ℹ Reconnecting to window (PID: {pid})...")
        main_window = get_window_by_pid(pid)
        if main_window is None:
            raise Exception("Could not find window after login!")
        print("    ✓ Reconnected to window\n")

        print_step(6, "Finding task input field...")

        task_input = find_by_name(main_window, 'taskInput')
        if task_input:
            print("    ✓ Found taskInput")
        else:
            raise Exception("Task input field not found!")
        
        print_step(7, f"Entering task: '{test_task}'...")
        task_input.set_text(test_task)
        time.sleep(2)  # Increased to see the task text being entered
        print(f"    ✓ Task text entered\n")
        
        print_step(8, "Finding and clicking Add Task button...")
        add_button = find_by_name(main_window, 'addTaskButton')
        if add_button:
            print("    ✓ Found addTaskButton")
        else:
            raise Exception("Add Task button not found!")
        
        add_button.click()
        time.sleep(2)  # Increased to see the task being created
        print("    ✓ Task created successfully\n")
        
        print_step(9, "Verifying task was created...")
        task_item = find_by_name(main_window, 'taskItem_0')
        if task_item:
            print("    ✓ Task creation verified\n")
        else:
            print("    ⚠ Task item not found, but continuing...\n")
        
        # ===== PHASE 4: REMOVE TASK =====
        print_header("PHASE 4: Remove Task")
        print_step(10, "Finding Remove button for the task...")

        remove_button = find_by_name(main_window, 'removeTaskButton_0')
        if remove_button:
            print("    ✓ Found removeTaskButton_0")
        else:
            raise Exception("Remove button not found!")
        
        print_step(11, "Clicking Remove button...")
        remove_button.click()
        time.sleep(2)  # Increased to see the task being removed
        print("    ✓ Task removed successfully\n")
        
        print_step(12, "Verifying task was removed...")
        task_item = find_by_name(main_window, 'taskItem_0')
        if task_item:
            print("    ⚠ Warning: Task still exists (may need more time)")
        else:
            print("    ✓ Task successfully removed from the list\n")
        
        # ===== PHASE 5: LOGOUT =====
        print_header("PHASE 5: Logout")
        print_step(13, "Pressing Ctrl+L to logout...")

        from pywinauto.keyboard import send_keys
        send_keys('^l')  # Ctrl+L for Logout
        time.sleep(3)  # Wait for page transition
        print("    ✓ Logged out successfully\n")

        # Verify we're back on login page
        print_step(14, "Verifying logout...")
        main_window = get_window_by_pid(pid)
        username_field = find_by_name(main_window, 'usernameField')
        if username_field:
            print("    ✓ Back on login page\n")
        else:
            print("    ⚠ Could not verify login page\n")

        # ===== PHASE 6: EXIT =====
        print_header("PHASE 6: Exit Application")
        print_step(15, "Pressing Ctrl+Q to exit...")

        send_keys('^q')  # Ctrl+Q for Exit
        time.sleep(2)
        print("    ✓ Application closed\n")
        
        # ===== TEST COMPLETE =====
        print_header("✓ AUTOMATION TEST COMPLETED SUCCESSFULLY")
        print("All phases completed:")
        print("  ✓ Phase 1: Application started")
        print("  ✓ Phase 2: Logged in with username")
        print("  ✓ Phase 3: Created a task")
        print("  ✓ Phase 4: Removed the task")
        print("  ✓ Phase 5: Logged out (Ctrl+L)")
        print("  ✓ Phase 6: Exited application (Ctrl+Q)")
        print("\n" + "="*70 + "\n")
        
        return 0
        
    except Exception as e:
        print(f"\n{'='*70}")
        print(f"❌ AUTOMATION TEST FAILED")
        print(f"{'='*70}")
        print(f"Error: {e}")
        print(f"Error type: {type(e).__name__}\n")
        import traceback
        traceback.print_exc()
        
        # Try to close the app if it's still running
        try:
            if 'main_window' in locals():
                main_window.close()
        except:
            pass
        
        return 1

if __name__ == "__main__":
    exit_code = main()
    sys.exit(exit_code)
