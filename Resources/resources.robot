*** Settings ***
Library          OperatingSystem

*** Variables ***
${MY-VARIABLE}        my test variable
${MY-VARIABLE2}       my second test variable

${GOOGLE-SEARCH-FIELD}    //input[@title="Search"]

@{LIST}               test1    test2    test3    test4

&{DICTIONARY1}        username=dmytro    password=qwerty
&{DICTIONARY2}       username=antonia    password=qwerty1234

*** Keywords ***
Log My Username
    [Arguments]    ${USERNAME}
    Log            ${USERNAME}

Log My Password
    [Arguments]    ${PASSWORD}
    Log            ${PASSWORD}

Log My Specific Username And Password
    [Arguments]        ${USERNAME}    ${PASSWORD}
    Log My Username    ${USERNAME}
    Log My Password    ${PASSWORD}