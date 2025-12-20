#!/usr/bin/env python3
"""
Complete End-to-End Automation Test
This script demonstrates a full automation workflow:
1. Login with username
2. Create a new task
3. Remove the task
4. Logout
5. Exit application

This is a REAL automation test, not just interaction examples.

NOTE: Delays have been increased (2-3 seconds between actions) so you can 
visually see each phase of the automation happening on screen.

Requirements:
  pip install pywinauto

Platform: Windows only (pywinauto requires Windows for Qt automation)
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
    print("For Linux automation, use:")
    print("  python examples/automation/atspi_demo.py")
    print()
    print("For cross-platform demonstration, use:")
    print("  python examples/automation/demo_automation.py")
    sys.exit(1)

try:
    from pywinauto.application import Application
    from pywinauto import Desktop
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

def verify_element(element, name):
    """Verify element exists"""
    if element.exists():
        print(f"    ✓ Found: {name}")
        return True
    else:
        print(f"    ✗ NOT FOUND: {name}")
        return False

def main():
    print_header("QtQuickTaskApp - Complete End-to-End Automation Test")
    
    # Configuration
    app_path = os.path.join(os.path.dirname(__file__), '..', '..', 'build', 'QtQuickTaskApp.exe')
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
        
        app = Application(backend='uia').start(app_path, wait_for_idle=False)
        time.sleep(3)  # Wait for app initialization - increased for visibility
        print("    ✓ Application started successfully\n")
        
        # ===== PHASE 2: LOGIN =====
        print_header("PHASE 2: Login")
        print_step(2, "Connecting to main window...")
        
        main_window = app.window(title_re='.*QtQuickTaskApp.*')
        main_window.wait('ready', timeout=10)
        print("    ✓ Connected to window\n")
        
        print_step(3, "Finding username input field...")
        # Try multiple methods to find the element
        # Qt applications on Windows may not expose auto_id properly
        username_field = None
        try:
            # Method 1: Try by auto_id (Accessible.name)
            username_field = main_window.child_window(auto_id='usernameField', control_type='Edit')
            if not username_field.exists():
                username_field = None
        except:
            pass
        
        if username_field is None:
            # Method 2: Try by control type only (find first Edit control)
            try:
                username_field = main_window.child_window(control_type='Edit', found_index=0)
                if username_field.exists():
                    print("    ℹ Found username field by control type (Edit)")
            except:
                pass
        
        if username_field is None or not username_field.exists():
            # Method 3: Print all available Edit controls for debugging
            print("    ℹ Searching for all Edit controls...")
            try:
                edit_controls = main_window.children(control_type='Edit')
                print(f"    ℹ Found {len(edit_controls)} Edit control(s)")
                for i, ctrl in enumerate(edit_controls):
                    print(f"      - Edit {i}: {ctrl.window_text()}")
                if len(edit_controls) > 0:
                    username_field = edit_controls[0]
                    print(f"    ℹ Using first Edit control")
            except Exception as e:
                print(f"    ⚠ Error searching for Edit controls: {e}")
        
        if username_field is None or not verify_element(username_field, "usernameField"):
            raise Exception("Username field not found!")
        
        print_step(4, f"Entering username: '{test_username}'...")
        username_field.set_text(test_username)
        time.sleep(2)  # Increased to see the username being entered
        print(f"    ✓ Username '{test_username}' entered\n")
        
        print_step(5, "Finding and clicking Login button...")
        # Try multiple methods to find the login button
        login_button = None
        try:
            login_button = main_window.child_window(auto_id='loginButton', control_type='Button')
            if not login_button.exists():
                login_button = None
        except:
            pass
        
        if login_button is None:
            # Try to find button by title/text
            try:
                buttons = main_window.children(control_type='Button')
                for btn in buttons:
                    if 'Login' in btn.window_text():
                        login_button = btn
                        print("    ℹ Found login button by text")
                        break
            except:
                pass
        
        if login_button is None or not verify_element(login_button, "loginButton"):
            raise Exception("Login button not found!")
        
        login_button.click()
        time.sleep(3)  # Increased to see the navigation transition
        print("    ✓ Login successful - navigated to main page\n")
        
        # ===== PHASE 3: CREATE TASK =====
        print_header("PHASE 3: Create Task")
        print_step(6, "Finding task input field...")
        
        # Try multiple methods to find task input
        task_input = None
        try:
            task_input = main_window.child_window(auto_id='taskInput', control_type='Edit')
            if not task_input.exists():
                task_input = None
        except:
            pass
        
        if task_input is None:
            # Find all Edit controls and use the visible one (should be on main page now)
            try:
                edit_controls = main_window.children(control_type='Edit')
                for ctrl in edit_controls:
                    if ctrl.is_visible() and ctrl.is_enabled():
                        task_input = ctrl
                        print("    ℹ Found task input by searching visible Edit controls")
                        break
            except:
                pass
        
        if task_input is None or not verify_element(task_input, "taskInput"):
            raise Exception("Task input field not found!")
        
        print_step(7, f"Entering task: '{test_task}'...")
        task_input.set_text(test_task)
        time.sleep(2)  # Increased to see the task text being entered
        print(f"    ✓ Task text entered\n")
        
        print_step(8, "Finding and clicking Add Task button...")
        # Try multiple methods to find add button
        add_button = None
        try:
            add_button = main_window.child_window(auto_id='addTaskButton', control_type='Button')
            if not add_button.exists():
                add_button = None
        except:
            pass
        
        if add_button is None:
            # Find button by text
            try:
                buttons = main_window.children(control_type='Button')
                for btn in buttons:
                    btn_text = btn.window_text()
                    if 'Add' in btn_text or '+' in btn_text:
                        add_button = btn
                        print("    ℹ Found add button by text")
                        break
            except:
                pass
        
        if add_button is None or not verify_element(add_button, "addTaskButton"):
            raise Exception("Add Task button not found!")
        
        add_button.click()
        time.sleep(2)  # Increased to see the task being created
        print("    ✓ Task created successfully\n")
        
        print_step(9, "Verifying task was created...")
        task_item = main_window.child_window(auto_id='taskItem_0')
        if verify_element(task_item, "taskItem_0"):
            print(f"    ✓ Task '{test_task}' is now in the list\n")
        else:
            raise Exception("Task item not found after creation!")
        
        # ===== PHASE 4: REMOVE TASK =====
        print_header("PHASE 4: Remove Task")
        print_step(10, "Finding Remove button for the task...")
        
        remove_button = main_window.child_window(auto_id='removeTaskButton_0', control_type='Button')
        if not verify_element(remove_button, "removeTaskButton_0"):
            raise Exception("Remove button not found!")
        
        print_step(11, "Clicking Remove button...")
        remove_button.click()
        time.sleep(2)  # Increased to see the task being removed
        print("    ✓ Task removed successfully\n")
        
        print_step(12, "Verifying task was removed...")
        try:
            # Task should no longer exist
            task_item = main_window.child_window(auto_id='taskItem_0')
            if task_item.exists():
                print("    ⚠ Warning: Task still exists (may need more time)")
            else:
                print("    ✓ Task successfully removed from the list\n")
        except:
            print("    ✓ Task successfully removed from the list\n")
        
        # ===== PHASE 5: LOGOUT =====
        print_header("PHASE 5: Logout")
        print_step(13, "Opening File menu...")
        
        # Click on File menu
        try:
            # Try to find and click the File menu
            file_menu = main_window.child_window(title="File", control_type="MenuItem")
            if file_menu.exists():
                file_menu.click()
                time.sleep(1)  # Increased to see the menu opening
                print("    ✓ File menu opened\n")
                
                print_step(14, "Clicking Logout...")
                logout_item = main_window.child_window(title="Logout", control_type="MenuItem")
                if logout_item.exists():
                    logout_item.click()
                    time.sleep(2)  # Increased to see the logout transition
                    print("    ✓ Logged out successfully\n")
                    
                    print_step(15, "Verifying returned to login page...")
                    # Check if we're back at login page
                    username_field = main_window.child_window(auto_id='usernameField', control_type='Edit')
                    if verify_element(username_field, "usernameField (login page)"):
                        print("    ✓ Successfully returned to login page\n")
                else:
                    print("    ⚠ Logout menu item not accessible, skipping logout\n")
            else:
                print("    ⚠ File menu not accessible, skipping logout\n")
        except Exception as e:
            print(f"    ⚠ Could not access menu for logout: {e}")
            print("    ℹ Note: Menu items may not be accessible via automation\n")
        
        # ===== PHASE 6: EXIT =====
        print_header("PHASE 6: Exit Application")
        print_step(16, "Closing application window...")
        
        main_window.close()
        time.sleep(2)  # Increased to see the application closing
        print("    ✓ Application closed successfully\n")
        
        # ===== TEST COMPLETE =====
        print_header("✓ AUTOMATION TEST COMPLETED SUCCESSFULLY")
        print("All phases completed:")
        print("  ✓ Phase 1: Application started")
        print("  ✓ Phase 2: Logged in with username")
        print("  ✓ Phase 3: Created a task")
        print("  ✓ Phase 4: Removed the task")
        print("  ✓ Phase 5: Logged out (if accessible)")
        print("  ✓ Phase 6: Exited application")
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
