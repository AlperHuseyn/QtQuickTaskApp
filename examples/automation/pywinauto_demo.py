#!/usr/bin/env python3
"""
Advanced automation demo using pywinauto (Windows only)
This script demonstrates actual interaction with the QtQuickTaskApp
using the pywinauto library.

Requirements:
  pip install pywinauto

Note: This script requires Windows OS and the application to be built.
"""

import time
import sys
import os

try:
    from pywinauto.application import Application
except ImportError:
    print("Error: pywinauto not installed")
    print("Install with: pip install pywinauto")
    sys.exit(1)

def print_step(step_num, description):
    """Print a formatted step"""
    print(f"\n[Step {step_num}] {description}")

def main():
    print("="*60)
    print("  QtQuickTaskApp - pywinauto Automation Demo")
    print("="*60)
    
    # Find the application
    app_path = os.path.join(os.path.dirname(__file__), '..', '..', 'build', 'QtQuickTaskApp.exe')
    
    if not os.path.exists(app_path):
        print(f"\nError: Application not found at {app_path}")
        print("Please build the application first.")
        return 1
    
    print(f"\n✓ Application: {app_path}")
    print("✓ Accessibility: Enabled by default")
    
    try:
        print_step(1, "Starting application...")
        # Start the application - accessibility is enabled by default!
        app = Application(backend='uia').start(app_path)
        time.sleep(2)  # Wait for initialization
        
        print("✓ Application started successfully")
        
        print_step(2, "Connecting to main window...")
        main_window = app.window(title_re='.*QtQuickTaskApp.*')
        main_window.wait('ready', timeout=10)
        print("✓ Connected to window")
        
        print_step(3, "Finding username input field...")
        username_field = main_window.child_window(auto_id='usernameField', control_type='Edit')
        print(f"✓ Found: {username_field}")
        
        print_step(4, "Entering username 'DemoUser'...")
        username_field.set_text('DemoUser')
        time.sleep(0.5)
        print("✓ Username entered")
        
        print_step(5, "Finding and clicking login button...")
        login_button = main_window.child_window(auto_id='loginButton', control_type='Button')
        login_button.click()
        time.sleep(1.5)  # Wait for navigation
        print("✓ Logged in successfully")
        
        print_step(6, "Finding task input field...")
        task_input = main_window.child_window(auto_id='taskInput', control_type='Edit')
        print(f"✓ Found: {task_input}")
        
        print_step(7, "Adding first task: 'Buy groceries'...")
        task_input.set_text('Buy groceries')
        time.sleep(0.3)
        
        add_button = main_window.child_window(auto_id='addTaskButton', control_type='Button')
        add_button.click()
        time.sleep(0.5)
        print("✓ Task added")
        
        print_step(8, "Adding second task: 'Call dentist'...")
        task_input.set_text('Call dentist')
        time.sleep(0.3)
        add_button.click()
        time.sleep(0.5)
        print("✓ Task added")
        
        print_step(9, "Adding third task: 'Finish project'...")
        task_input.set_text('Finish project')
        time.sleep(0.3)
        add_button.click()
        time.sleep(0.5)
        print("✓ Task added")
        
        print_step(10, "Verifying tasks were created...")
        # Check if first task exists
        task_item = main_window.child_window(auto_id='taskItem_0')
        if task_item.exists():
            print("✓ Task items verified")
        else:
            print("⚠️  Warning: Could not verify task items")
        
        print_step(11, "Marking first task as complete...")
        checkbox = main_window.child_window(auto_id='taskCheckbox_0', control_type='CheckBox')
        checkbox.click()
        time.sleep(0.5)
        print("✓ Task marked complete")
        
        print_step(12, "Marking second task as complete...")
        checkbox = main_window.child_window(auto_id='taskCheckbox_1', control_type='CheckBox')
        checkbox.click()
        time.sleep(0.5)
        print("✓ Task marked complete")
        
        print_step(13, "Clearing completed tasks...")
        clear_button = main_window.child_window(auto_id='clearCompletedButton', control_type='Button')
        clear_button.click()
        time.sleep(0.5)
        print("✓ Completed tasks cleared")
        
        print("\n" + "="*60)
        print("  Automation Demo Completed Successfully!")
        print("="*60)
        print("\nThe application will remain open for 5 seconds...")
        print("You should see one remaining task: 'Finish project'")
        
        time.sleep(5)
        
        print("\nClosing application...")
        main_window.close()
        print("✓ Application closed")
        
        return 0
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        print(f"Error type: {type(e).__name__}")
        import traceback
        traceback.print_exc()
        return 1

if __name__ == "__main__":
    sys.exit(main())
