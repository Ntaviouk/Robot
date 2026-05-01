*** Settings ***
Documentation    This is my first test case
Library          OperatingSystem
Resource         ../Resources/resources.robot

*** Test Cases ***
TEST1
    [Tags]        demo1    demo2
    Log My Specific Username And Password    ${DICTIONARY1}[username]    ${DICTIONARY2}[password]
