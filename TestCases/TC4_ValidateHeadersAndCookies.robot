*** Settings ***
Library        RequestsLibrary
Library        Collections

*** Variables ***
${BASE_URL}    https://jsonplaceholder.typicode.com

*** Test Cases ***
TestHeaders
    Create Session     mysession    ${BASE_URL}
    ${response}=    Get On Session    mysession    /photos

    #Log To Console    ${response.headers}

    #${content_type}=    Get From Dictionary    ${response.headers}    Content-Type
    #Should Be Equal As Strings    ${content_type}    application/json
    Should Be Equal As Strings    ${response.headers['Content-Type']}    	application/json; charset=utf-8

TestCookies
    Create Session     mysession    https://github.com/
    ${response}=    Get On Session    mysession    /

    Log To Console  ${response.cookies}

    Dictionary Should Contain Key    ${response.cookies}    _gh_sess

    Should Not Be Empty    ${response.cookies['_gh_sess']}

