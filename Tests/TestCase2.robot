*** Settings ***
Resource         ../Resources/resources.robot

*** Test Cases ***
TEST2
    [Tags]        demo1    demo2
    Log My Specific Username And Password    ${DICTIONARY2}[username]    ${DICTIONARY2}[password]