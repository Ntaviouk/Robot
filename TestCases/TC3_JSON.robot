*** Settings ***
Library        JSONLibrary
Library        os
Library        Collections

*** Test Cases ***
TestCase1:
                                           #${CURDIR}/../data.json
    ${json_obj}=      Load Json From File    ${EXECDIR}/data.json

   #${name_value}=    Set Variable            ${json_obj}[firstName]
    ${name_value}=    Get Value From Json     ${json_obj}    $.firstName

    #Should Be Equal As Strings         ${json_obj}[firstName]    John
    Should Be Equal    ${name_value[0]}    John



    #${street_value}=    Set Variable            ${json_obj}[address][streetAddress]
    ${street_value}=    Get Value From Json     ${json_obj}    $.address.streetAddress

    #Should Be Equal As Strings         ${json_obj}[address][streetAddress]    21 2nd Street
    Should Be Equal    ${street_value[0]}    21 2nd Street