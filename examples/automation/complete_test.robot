*** Settings ***
Documentation     Complete End-to-End Automation Test with REAL UI Interaction
...               This test demonstrates actual automated workflow with visible UI actions:
...               1. Login with username (you'll see text being typed)
...               2. Create a new task (you'll see task being added)
...               3. Remove the task (you'll see task being removed)
...               4. Logout (you'll see return to login screen)
...               5. Exit application
...
...               This uses Python's pywinauto library via Robot Framework's Process and Python execution.
...
...               Requirements:
...                 pip install pywinauto robotframework
...
...               NOTE: Wait times increased (3-5 seconds) so you can visually
...               observe each phase of the automation on screen.
Library           OperatingSystem
Library           Process

*** Variables ***
${SCRIPT_DIR}     ${CURDIR}
${TEST_SCRIPT}    ${SCRIPT_DIR}/complete_test.py
${SEPARATOR}      ======================================================================

*** Test Cases ***
Complete Automation Workflow Using Python Script
    [Documentation]    Runs the complete automation test using pywinauto
    ...                This will show REAL UI interactions (typing, clicking, navigation)
    ...                Watch the application window for visible actions!
    [Tags]    e2e    automation    complete
    
    Log To Console    \n${SEPARATOR}
    Log To Console    ${SPACE}${SPACE}${SPACE}QtQuickTaskApp - Complete End-to-End Automation Test
    Log To Console    ${SEPARATOR}
    Log To Console    \n${SPACE}${SPACE}${SPACE}This test will show VISIBLE UI actions:
    Log To Console    ${SPACE}${SPACE}${SPACE}• Watch the application window open
    Log To Console    ${SPACE}${SPACE}${SPACE}• See username being typed
    Log To Console    ${SPACE}${SPACE}${SPACE}• See Login button being clicked
    Log To Console    ${SPACE}${SPACE}${SPACE}• See page transition to main screen
    Log To Console    ${SPACE}${SPACE}${SPACE}• See task being created and removed
    Log To Console    ${SPACE}${SPACE}${SPACE}• See logout and return to login screen
    Log To Console    \n${SPACE}${SPACE}${SPACE}Keep your eyes on the application window!\n
    
    # Verify the Python script exists
    File Should Exist    ${TEST_SCRIPT}    
    ...    msg=Python automation script not found at ${TEST_SCRIPT}
    
    # Run the Python automation script which has REAL UI interaction
    Log To Console    Starting automation with pywinauto...\n
    ${result}=    Run Process    python    ${TEST_SCRIPT}
    ...    shell=True
    ...    stdout=${TEMPDIR}/robot_output.txt
    ...    stderr=STDOUT
    
    # Log the output from the Python script
    Log To Console    ${result.stdout}
    
    # Check if the test passed
    Should Be Equal As Integers    ${result.rc}    0
    ...    msg=Automation test failed. Check output above for details.
    
    Log To Console    \n${SEPARATOR}
    Log To Console    ${SPACE}${SPACE}${SPACE}✓ COMPLETE TEST PASSED
    Log To Console    ${SPACE}${SPACE}${SPACE}All UI actions were performed successfully!
    Log To Console    ${SEPARATOR}\n

*** Keywords ***
# No additional keywords needed - the Python script handles everything
