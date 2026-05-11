*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    http://restapi.demoqa.com

*** Test Cases ***
Basic Auth Test
    ${auth}=    Create List    ToolsQA    TestPassword

    Create Session    mysession    ${BASE_URL}    auth=${auth}

    # Використовуємо сучасне ключове слово GET On Session
    ${response}=    GET On Session    mysession    /authentication/CheckForAuthentication/    expected_status=200

    Log To Console    ${response.content}

    Status Should Be    200    ${response}