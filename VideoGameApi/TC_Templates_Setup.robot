*** Settings ***
Library        RequestsLibrary
Library        Collections

Suite Setup    Create Session    mysession    ${BASE_URL}
Suite Teardown    Clean Up Database And Sessions

Test Template  Execute And Verify API Call


*** Variables ***
${BASE_URL}       http://127.0.0.1:8000

&{GAME_DATA}      id=${5}    name=CounterStrike2    releaseDate=2022-01-01    reviewScore=${82}    category=Shooter    rating=Mature
&{UPDATE_DATA}    id=${5}    name=CounterStrike2    releaseDate=2022-01-01    reviewScore=${5}     category=Shooter    rating=Mature


*** Test Cases ***
TC1: Returns all video games (GET)     GET     /app/videogames      200           ${NONE}         name            Red Dead Redemption 2
TC2: Returns all video games (POST)    POST    /app/videogames      201           ${GAME_DATA}    status          Record Added Successfully
TC3: Detail of a single game (GET)     GET     /app/videogames/5    200           ${NONE}         name            CounterStrike2
TC4: Update an existing game (PUT)     PUT     /app/videogames/5    200           ${UPDATE_DATA}  ${NONE}         ${NONE}
TC5: Deletes a video game (DELETE)     DELETE  /app/videogames/5    200           ${NONE}         status          Record Deleted Successfully
TC6: Deletion Check (GET)              GET     /app/videogames/5    404           ${NONE}         detail          Video game not found


*** Keywords ***
Execute And Verify API Call
    [Arguments]    ${method}    ${endpoint}    ${expected_status}    ${payload}    ${check_key}    ${check_value}

    ${headers}=    Create Dictionary    Content-Type=application/json

    IF    '${method}' == 'GET'
        ${response}=    GET On Session       mysession    ${endpoint}    expected_status=any
    ELSE IF    '${method}' == 'POST'
        ${response}=    POST On Session      mysession    ${endpoint}    json=${payload}    headers=${headers}    expected_status=any
    ELSE IF    '${method}' == 'PUT'
        ${response}=    PUT On Session       mysession    ${endpoint}    json=${payload}    headers=${headers}    expected_status=any
    ELSE IF    '${method}' == 'DELETE'
        ${response}=    DELETE On Session    mysession    ${endpoint}    expected_status=any
    END

    Log to Console    \nStatus: ${response.status_code} | Body: ${response.content}

    Status Should Be    ${expected_status}    ${response}

    ${content_type}=    Get From Dictionary    ${response.headers}    Content-Type    default=${NONE}
    IF    '${content_type}' != '${NONE}'
        Should Contain    ${content_type}    application/json
    END

    IF    '${check_key}' != '${NONE}'
        ${json_data}=    Set Variable    ${response.json()}
        ${is_list}=      Evaluate        isinstance($json_data, list)

        IF    ${is_list}
            Should Be Equal As Strings    ${json_data}[0][${check_key}]    ${check_value}
        ELSE
            Should Be Equal As Strings    ${json_data}[${check_key}]       ${check_value}
        END
    END

    IF    '${method}' == 'PUT'
        Dictionaries Should Be Equal    ${response.json()}    ${payload}
    END

Clean Up Database And Sessions
    DELETE On Session    mysession    /app/videogames/5    expected_status=any
    Delete All Sessions