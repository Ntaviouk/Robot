*** Settings ***
Library        RequestsLibrary
Library        Collections

*** Variables ***
${BASE_URL}=     http://127.0.0.1:8080/customer


*** Test Cases ***
Register New User
    Create Session     mysession    ${BASE_URL}

    ${body}=      Create Dictionary
    ...    FirstName=Dmytro
    ...    LastName=Daniuk
    ...    UserName=Ntaviouk
    ...    Password=Qwerty
    ...    Email=dimasdaniuk@gmail.com

    ${header}=    Create Dictionary
    ...    Content-Type=application/json

                                                              #Or data=${body}
   ${response}=    Post On Session    mysession    /register    json=${body}    headers=${header}

   Log To Console    ${response.status_code}
   Log To Console    ${response.content}

   #VALIDATIONS

   #Status Should Be    200    ${response}
   ${status_code}=    Convert To String    ${response.status_code}
   Should Be Equal    ${status_code}       200



   ${res_body}=      Convert To String    ${response.content}
   Should Contain    ${res_body}          OPERATION_SUCCESS
   Should Contain    ${res_body}          Operation completed successfully