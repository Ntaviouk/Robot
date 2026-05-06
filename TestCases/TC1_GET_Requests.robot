*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    http://api.openweathermap.org
${API_KEY}     9093ccdb1ca883aee0065d64f4679b25
${CITY}        Lviv
${UNITS}       metric
${LANG}        ua

*** Test Cases ***
Get Weather
    Create Session    weather    ${BASE_URL}

    ${params}=    Create Dictionary
    ...    q=${CITY}
    ...    appid=${API_KEY}
    ...    units=${UNITS}
    ...    lang=${LANG}

    ${response}=    GET On Session    weather    /data/2.5/weather    params=${params}


    #Log To Console    ${response.status_code}
    #Log To Console    ${response.content}
    #Log To Console    ${response.headers}

    #VALIDATIONS

    #Status Should Be    200    ${response}
    ${status_code}=    Convert To String     ${response.status_code}
    Should Be Equal    ${status_code}        200


    #${json_data}=    Set Variable    ${response.json()}
    #Should Be Equal As Strings    ${json_data}[name]    ${CITY}
    ${body}=           Convert To String    ${response.content}
    Should Contain     ${body}              Lviv


    ${contentTypeValue}=    Get From Dictionary    ${response.headers}    Content-Type
    Should Be Equal    ${contentTypeValue}    application/json; charset=utf-8


