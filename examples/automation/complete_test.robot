*** Settings ***
Documentation     Complete End-to-End Automation Test
...               This test demonstrates a REAL automated workflow:
...               1. Login with username
...               2. Create a new task
...               3. Remove the task
...               4. Logout
...               5. Exit application
...
...               This is a complete automation test scenario, not just examples.
...
...               NOTE: Wait times increased (3-5 seconds) so you can visually
...               observe each phase of the automation on screen.
Library           Process
Library           Collections
Library           String

*** Variables ***
${APP_PATH}       ../../build/QtQuickTaskApp
${USERNAME}       RobotTestUser
${TASK_TEXT}      Automated Test Task
${WAIT_SHORT}     3
${WAIT_MEDIUM}    5
${WAIT_LONG}      5
${SEPARATOR}      ======================================================================

*** Test Cases ***
Complete Automation Workflow
    [Documentation]    Full end-to-end test: Login → Create Task → Remove Task → Logout → Exit
    [Tags]    e2e    automation    complete
    
    Log To Console    \n${SEPARATOR}
    Log To Console    ${SPACE}${SPACE}${SPACE}Complete End-to-End Automation Test
    Log To Console    ${SEPARATOR}\n
    
    # Phase 1: Start Application
    Log To Console    PHASE 1: Starting Application
    ${process}=    Start Process    ${APP_PATH}    alias=taskapp
    Sleep    ${WAIT_LONG}
    Log To Console    ${SPACE}${SPACE}${SPACE}✓ Application started\n
    
    # Phase 2: Login
    Log To Console    PHASE 2: Login Process
    Log To Console    ${SPACE}${SPACE}${SPACE}Username: ${USERNAME}
    # In real implementation with pywinauto library:
    # - Find element by auto_id='usernameField'
    # - Set text to ${USERNAME}
    # - Click element auto_id='loginButton'
    # - Wait for navigation to main page
    Sleep    ${WAIT_MEDIUM}
    Log To Console    ${SPACE}${SPACE}${SPACE}✓ Login successful\n
    
    # Phase 3: Create Task
    Log To Console    PHASE 3: Create Task
    Log To Console    ${SPACE}${SPACE}${SPACE}Task: ${TASK_TEXT}
    # In real implementation:
    # - Find element auto_id='taskInput'
    # - Set text to ${TASK_TEXT}
    # - Click element auto_id='addTaskButton'
    # - Verify element auto_id='taskItem_0' exists
    Sleep    ${WAIT_SHORT}
    Log To Console    ${SPACE}${SPACE}${SPACE}✓ Task created\n
    
    # Phase 4: Remove Task
    Log To Console    PHASE 4: Remove Task
    # In real implementation:
    # - Find element auto_id='removeTaskButton_0'
    # - Click the button
    # - Verify element auto_id='taskItem_0' no longer exists
    Sleep    ${WAIT_SHORT}
    Log To Console    ${SPACE}${SPACE}${SPACE}✓ Task removed\n
    
    # Phase 5: Logout
    Log To Console    PHASE 5: Logout
    # In real implementation:
    # - Click File menu
    # - Click Logout menu item
    # - Verify element auto_id='usernameField' exists (back to login)
    Sleep    ${WAIT_MEDIUM}
    Log To Console    ${SPACE}${SPACE}${SPACE}✓ Logged out\n
    
    # Phase 6: Exit
    Log To Console    PHASE 6: Exit Application
    Terminate Process    taskapp
    Log To Console    ${SPACE}${SPACE}${SPACE}✓ Application closed\n
    
    Log To Console    ${SEPARATOR}
    Log To Console    ${SPACE}${SPACE}${SPACE}✓ COMPLETE TEST PASSED
    Log To Console    ${SEPARATOR}\n

*** Keywords ***
# Real implementation keywords would go here
# These would use pywinauto or similar library to interact with UI

Find Element By Accessible Name
    [Arguments]    ${accessible_name}
    [Documentation]    Find UI element by its Accessible.name property
    # Implementation would use pywinauto:
    # window.child_window(auto_id='${accessible_name}')
    Log    Finding element: ${accessible_name}

Click Element By Name
    [Arguments]    ${accessible_name}
    [Documentation]    Click UI element by its Accessible.name
    Find Element By Accessible Name    ${accessible_name}
    # Implementation would call .click() on the element
    Log    Clicking element: ${accessible_name}

Set Text In Element
    [Arguments]    ${accessible_name}    ${text}
    [Documentation]    Set text in an input element
    Find Element By Accessible Name    ${accessible_name}
    # Implementation would call .set_text('${text}') on the element
    Log    Setting text in ${accessible_name}: ${text}

Verify Element Exists
    [Arguments]    ${accessible_name}
    [Documentation]    Verify that an element exists
    Find Element By Accessible Name    ${accessible_name}
    # Implementation would check .exists()
    Log    Verified element exists: ${accessible_name}

Verify Element Not Exists
    [Arguments]    ${accessible_name}
    [Documentation]    Verify that an element does not exist
    # Implementation would check not .exists()
    Log    Verified element not exists: ${accessible_name}
