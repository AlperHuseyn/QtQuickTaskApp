#!/usr/bin/env python3
"""
Simple demonstration of QtQuickTaskApp automation
This script shows how to start the application and demonstrates
the accessible elements available for automation.

Accessibility is enabled by default - no special setup needed!
"""

import subprocess
import time
import sys
import os

def print_section(title):
    """Print a formatted section header"""
    print(f"\n{'='*60}")
    print(f"  {title}")
    print(f"{'='*60}\n")

def main():
    print_section("QtQuickTaskApp Automation Demo")
    
    # Find the application executable
    app_path = os.path.join(os.path.dirname(__file__), '..', '..', 'build', 'QtQuickTaskApp')
    
    if not os.path.exists(app_path):
        print(f"⚠️  Application not found at: {app_path}")
        print("Please build the application first:")
        print("  mkdir build && cd build && cmake .. && cmake --build .")
        return 1
    
    print(f"✓ Application found: {app_path}")
    print(f"✓ Accessibility: Enabled by default")
    print(f"✓ No special configuration needed!\n")
    
    # Start the application
    print("Starting application...")
    process = subprocess.Popen([app_path])
    
    time.sleep(2)  # Wait for app to initialize
    
    print_section("Accessible Elements - Login Page")
    print("The following elements are available for automation:")
    print("  • usernameField (EditableText) - Username input field")
    print("  • loginButton (Button) - Login button")
    print("  • welcomeTitle (StaticText) - Welcome message")
    print("  • loginPrompt (StaticText) - Login prompt text")
    
    print_section("Accessible Elements - Main Page")
    print("After login, these elements become available:")
    print("  • taskInput (EditableText) - New task input field")
    print("  • addTaskButton (Button) - Add new task")
    print("  • taskListView (List) - Task list container")
    print("  • taskItem_N (ListItem) - Individual task items (N = index)")
    print("  • taskCheckbox_N (CheckBox) - Task completion checkboxes")
    print("  • taskTitle_N (StaticText) - Task titles")
    print("  • removeTaskButton_N (Button) - Remove task buttons")
    print("  • clearCompletedButton (Button) - Clear completed tasks")
    
    print_section("Automation Workflow")
    print("Typical automation workflow:")
    print("  1. Start application (accessibility auto-enabled)")
    print("  2. Find 'usernameField' element")
    print("  3. Input text: 'TestUser'")
    print("  4. Click 'loginButton' element")
    print("  5. Wait for navigation to main page")
    print("  6. Find 'taskInput' element")
    print("  7. Input text: 'Buy groceries'")
    print("  8. Click 'addTaskButton' element")
    print("  9. Verify 'taskItem_0' element exists")
    print(" 10. Click 'taskCheckbox_0' to mark complete")
    print(" 11. Click 'clearCompletedButton' to remove")
    
    print_section("Tools for Automation")
    print("Windows:")
    print("  • pywinauto - Python automation library")
    print("  • inspect.exe - Verify accessibility tree")
    print("\nLinux:")
    print("  • pyatspi2 - Python AT-SPI bindings")
    print("  • accerciser - Accessibility inspector")
    print("\nCross-platform:")
    print("  • Robot Framework - Test automation framework")
    
    print_section("Demo Information")
    print("The application is now running with accessibility enabled.")
    print("Use your automation tool to inspect and interact with elements.")
    print("\nPress Ctrl+C to stop the application...")
    
    try:
        # Keep the script running
        process.wait()
    except KeyboardInterrupt:
        print("\n\nStopping application...")
        process.terminate()
        process.wait()
        print("✓ Application stopped")
    
    return 0

if __name__ == "__main__":
    sys.exit(main())
