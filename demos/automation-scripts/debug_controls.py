"""Debug script to list all UI controls in the Qt app"""
from pywinauto import Application
from pywinauto import Desktop

# Find the window using Desktop instead
desktop = Desktop(backend='uia')
windows = desktop.windows(title='QtQuickTaskApp')

if not windows:
    print("QtQuickTaskApp window not found!")
else:
    win = windows[0]
    print(f"=== Window: {win.window_text()} ===\n")
    print("=== All controls in window ===\n")
    for i, ctrl in enumerate(win.descendants()):
        info = ctrl.element_info
        print(f"{i}: name='{info.name}' control_type='{info.control_type}'")
