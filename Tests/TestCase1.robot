*** Settings ***
Documentation    This is my first test case
Library          OperatingSystem

*** Keywords ***
 
*** Variables ***
${MY-VARIABLE}        my test variable
${MY-VARIABLE2}       my second test variable

${GOOGLE-SEARCH-FIELD}    //input[@title="Search"]

@{LIST}               test1    test2    test3    test4

&{DICTIONARY}        useranme=dmytro    password=qwerty

*** Test Cases ***
TEST1
    [Tags]    demo1    demo2
    Log       ${MY-VARIABLE}
    Log       ${LIST}[1]
    Log       &{DICTIONARY}[username]