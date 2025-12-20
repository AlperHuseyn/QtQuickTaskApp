#!/usr/bin/env python3
"""
Automation demo using AT-SPI (Linux only)
This script demonstrates how to interact with QtQuickTaskApp
using pyatspi2 on Linux.

Requirements:
  pip install pyatspi2

Note: This script requires Linux with AT-SPI support.
"""

import subprocess
import time
import sys
import os

try:
    import pyatspi
except ImportError:
    print("Error: pyatspi2 not installed")
    print("Install with: pip install pyatspi2")
    print("or: sudo apt-get install python3-pyatspi")
    sys.exit(1)

def print_step(step_num, description):
    """Print a formatted step"""
    print(f"\n[Step {step_num}] {description}")

def find_application():
    """Find the QtQuickTaskApp in the accessibility tree"""
    desktop = pyatspi.Registry.getDesktop(0)
    
    # Debug: List all applications in the accessibility tree
    print("\n   Searching accessibility tree...")
    print("   Applications found:")
    for child in desktop:
        try:
            print(f"     - {child.name} (role: {child.getRoleName()})")
            if 'QtQuickTaskApp' in child.name or 'QtQuick' in child.name or child.name == 'QtQuickTaskApp':
                return child
        except Exception as e:
            continue
    
    return None

def main():
    print("="*60)
    print("  QtQuickTaskApp - AT-SPI Automation Demo (Linux)")
    print("="*60)
    
    # Find the application
    app_path = os.path.join(os.path.dirname(__file__), '..', '..', 'build', 'QtQuickTaskApp')
    
    if not os.path.exists(app_path):
        print(f"\nError: Application not found at {app_path}")
        print("Please build the application first.")
        return 1
    
    print(f"\n✓ Application: {app_path}")
    print("✓ Accessibility: Enabled by default")
    
    try:
        print_step(1, "Starting application...")
        # Start the application - accessibility is enabled by default!
        process = subprocess.Popen([app_path])
        time.sleep(2)  # Wait for initialization
        print("✓ Application started")
        
        print_step(2, "Finding application in accessibility tree...")
        app = find_application()
        if not app:
            print("\n❌ Could not find application in accessibility tree")
            print("\n   Troubleshooting steps:")
            print("   1. Make sure AT-SPI is enabled on your system")
            print("      - Check if at-spi2-core is installed: dpkg -l | grep at-spi")
            print("      - Restart at-spi-bus-launcher if needed")
            print("   2. Qt may need a small delay to register with AT-SPI")
            print("      - The app is running, try using accessibility tools like 'accerciser'")
            print("   3. Check if Qt accessibility bridge is loaded:")
            print("      - Set QT_DEBUG_PLUGINS=1 and check for 'libqatspiplugin.so'")
            print("\n   Note: The application is still running. You can:")
            print("   - Use 'accerciser' (GUI tool) to explore the accessibility tree")
            print("   - Verify elements have Accessible.name properties")
            print("\n   Keeping application open for manual inspection (30 seconds)...")
            time.sleep(30)
            process.terminate()
            return 1
        
        print(f"✓ Found application: {app.name}")
        
        print_step(3, "Exploring accessible elements...")
        print(f"   Application has {app.childCount} child elements")
        
        # List some accessible elements
        print("\nAccessible elements found:")
        def print_tree(node, indent=0):
            try:
                role = node.getRoleName()
                name = node.name
                if name:
                    print(f"{'  '*indent}• {name} ({role})")
                for i in range(min(node.childCount, 10)):  # Limit to first 10
                    child = node.getChildAtIndex(i)
                    print_tree(child, indent + 1)
            except Exception:
                pass  # Skip inaccessible nodes
        
        print_tree(app)
        
        print("\n" + "="*60)
        print("  Basic Accessibility Tree Exploration Complete")
        print("="*60)
        
        print("\nNote: Full interaction demo would require more complex")
        print("AT-SPI navigation. This demo shows that elements are")
        print("accessible and can be found in the accessibility tree.")
        
        print("\nThe application will remain open for 5 seconds...")
        time.sleep(5)
        
        print("\nStopping application...")
        process.terminate()
        process.wait()
        print("✓ Application stopped")
        
        return 0
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        try:
            process.terminate()
        except Exception:
            pass  # Process may already be terminated
        return 1

if __name__ == "__main__":
    sys.exit(main())
