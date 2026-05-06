*** Settings ***
Library        RequestsLibrary
Library        Collections

*** Variables ***
${BASE_URL}        http://127.0.0.1:8000

*** Test Cases ***
TC1:Returns all the videos games(GET)
    Create Session    mysession       ${BASE_URL}
    ${response}=      GET On Session  mysession    /app/videogames

    Status Should Be    200    ${response}

    ${content_type}=    Get From Dictionary    ${response.headers}    Content-Type
    Should Be Equal     ${content_type}        application/json

    ${json_data}=       Set Variable    ${response.json()}

    ${list_length}=     Get Length      ${json_data}
    Should Be True      ${list_length} > 0


    ${first_game}=      Set Variable       ${json_data}[0]
    Dictionary Should Contain Key    ${first_game}    name
    Dictionary Should Contain Key    ${first_game}    category

    Should Be Equal As Strings       ${first_game}[name]    Red Dead Redemption 2


TC2:Returns all the videos games(POST)
    Create Session     mysession    ${BASE_URL}

     ${body}=      Create Dictionary
    ...    id=${5}
    ...    name=CounterStrike2
    ...    releaseDate=2022-01-01
    ...    reviewScore=${82}
    ...    category=Shooter
    ...    rating=Mature

    ${header}=    Create Dictionary
    ...    Content-Type=application/json

    ${response}=    Post On Session    mysession    /app/videogames    json=${body}    headers=${header}

    Log to Console    ${response.status_code}
    Log to Console    ${response.content}

    Status Should Be    201    ${response}

   ${json_data}=    Set Variable    ${response.json()}
   Should Be Equal As Strings    ${json_data}[status]    Record Added Successfully


TC3: Returns the detail of a single game by ID(GET)
    Create Session     mysession    ${BASE_URL}

    ${response}=    Get On Session    mysession    /app/videogames/5

    Log to Console    ${response.status_code}
    Log to Console    ${response.content}

    Status Should Be    200    ${response}

    ${json_data}=       Set Variable    ${response.json()}

    Should Be Equal As Integers    ${json_data}[id]      5
    Should Be Equal As Strings     ${json_data}[name]    CounterStrike2


TC4:Update an existing video game by specifying a new body(PUT)
    Create Session     mysession    ${BASE_URL}

    ${body}=      Create Dictionary
    ...    id=${5}
    ...    name=CounterStrike2
    ...    releaseDate=2022-01-01
    ...    reviewScore=${5}
    ...    category=Shooter
    ...    rating=Mature

    ${header}=    Create Dictionary
    ...    Content-Type=application/json

    ${response}=    Put On Session    mysession    /app/videogames/5    json=${body}    headers=${header}

    Log to Console    ${response.status_code}
    Log to Console    ${response.content}

    Status Should Be    200    ${response}

    ${content_type}=    Get From Dictionary    ${response.headers}    Content-Type
    Should Be Equal     ${content_type}        application/json

    ${json_data}=    Set Variable    ${response.json()}
    Dictionaries Should Be Equal     ${json_data}        ${body}


TC5: Deletes a video game by ID (DELETE)
    Create Session     mysession    ${BASE_URL}
    ${response}=    Delete On Session    mysession    /app/videogames/5

    Log to Console    ${response.status_code}
    Log to Console    ${response.content}

    Status Should Be    200    ${response}

    ${json_data}=    Set Variable    ${response.json()}

    Should Be Equal As Strings     ${json_data}[status]    Record Deleted Successfully

TC6: Deletion Check(GET)
    Create Session     mysession    ${BASE_URL}

    ${response}=    Get On Session    mysession    /app/videogames/5    expected_status=404

    Log to Console    ${response.status_code}
    Log to Console    ${response.content}

    Status Should Be    404    ${response}

    ${json_data}=       Set Variable    ${response.json()}

    Should Be Equal As Strings     ${json_data}[detail]    Video game not found