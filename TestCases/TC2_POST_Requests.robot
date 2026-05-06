*** Settings ***
Library        RequestsLibrary
Library        Collections

*** Variables ***
${BASE_URL}=     http://127.0.0.1:8000/customer


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
   ${responce}=    Post On Session    mysession    /register    json=${body}    headers=${header}

   Log To Console    ${responce.status_code}
   Log To Console    ${responce.content}

   #VALIDATIONS

   #Status Should Be    200    ${response}
   ${status_code}=    Convert To String    ${responce.status_code}
   Should Be Equal    ${status_code}       201



   ${res_body}=      Convert To String    ${responce.content}
   Should Contain    ${res_body}          OPERATION_SUCCESS
   Should Contain    ${res_body}          Operation completed successfully