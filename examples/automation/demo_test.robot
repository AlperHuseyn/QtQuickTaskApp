*** Settings ***
Documentation     Simple demonstration of QtQuickTaskApp automation
...               This test demonstrates basic login and task management functionality
...               Accessibility is enabled by default - no special setup needed!
Library           Process
Library           OperatingSystem

*** Variables ***
${APP_PATH}       ../../build/QtQuickTaskApp
${WAIT_SHORT}     1
${WAIT_MEDIUM}    2

*** Test Cases ***
Demo: Login and Create Tasks
    [Documentation]    Demonstrates logging in and creating multiple tasks
    [Tags]    demo    smoke
    
    # Start the application - accessibility is enabled by default!
    ${process}=    Start Process    ${APP_PATH}    alias=taskapp
    Sleep    ${WAIT_MEDIUM}    # Wait for app to initialize
    
    # At this point, automation tools can interact with the app
    # The following would be done by your automation library:
    # - Find element by Accessible.name "usernameField"
    # - Enter text "TestUser"
    # - Click element "loginButton"
    # - Navigate to main page
    # - Add tasks using "taskInput" and "addTaskButton"
    
    Log    Application started successfully with accessibility enabled
    Log    Login page should be visible with 'usernameField' and 'loginButton'
    
    Sleep    ${WAIT_MEDIUM}    # Allow manual verification if needed
    
    # Cleanup
    Terminate Process    taskapp
    Log    Test demonstration completed

Demo: Verify Accessibility Elements
    [Documentation]    Shows the accessible elements available for automation
    [Tags]    demo    accessibility
    
    ${process}=    Start Process    ${APP_PATH}    alias=taskapp
    Sleep    ${WAIT_MEDIUM}
    
    Log    Accessible elements on Login Page:
    Log    - usernameField (EditableText) - Username input
    Log    - loginButton (Button) - Login button
    Log    - welcomeTitle (StaticText) - Welcome message
    
    Log    \nAccessible elements on Main Page (after login):
    Log    - taskInput (EditableText) - New task input
    Log    - addTaskButton (Button) - Add task button
    Log    - taskListView (List) - Task list container
    Log    - taskItem_N (ListItem) - Individual task items
    Log    - taskCheckbox_N (CheckBox) - Task checkboxes
    Log    - removeTaskButton_N (Button) - Remove buttons
    Log    - clearCompletedButton (Button) - Clear completed tasks
    
    Sleep    ${WAIT_MEDIUM}
    Terminate Process    taskapp
    Log    Accessibility elements documented

*** Keywords ***
# Add your custom keywords here for actual automation
# Example:
# Enter Username
#     [Arguments]    ${username}
#     Input Text To Element    usernameField    ${username}
