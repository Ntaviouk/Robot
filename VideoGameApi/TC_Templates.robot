*** Settings ***
Library         RequestsLibrary
Library         Collections

Suite Setup     Create Session    mysession    ${BASE_URL}
Suite Teardown  Clean Up Database And Sessions

*** Variables ***
${BASE_URL}     http://127.0.0.1:8000

*** Test Cases ***
TC1: Returns all the videos games (GET)
    ${response}=    GET On Session  mysession    /app/videogames
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

TC2: Add Multiple Video Games (POST)
    [Documentation]    Використання Data-Driven підходу для створення декількох ігор
    [Template]         Create Video Game
    # id    name                releaseDate   reviewScore   category   rating
    5       CounterStrike2      2022-01-01    82            Shooter    Mature
    6       The Witcher 3       2015-05-19    95            RPG        Mature
    7       Minecraft           2011-11-18    90            Sandbox    Everyone
    8       Cyberpunk 2077      2020-12-10    75            RPG        Mature

TC3: Returns the detail of a single game by ID (GET)
    ${response}=    Get On Session    mysession    /app/videogames/5
    Status Should Be    200    ${response}
    ${json_data}=       Set Variable    ${response.json()}
    Should Be Equal As Integers    ${json_data}[id]      5
    Should Be Equal As Strings     ${json_data}[name]    CounterStrike2

*** Keywords ***
Create Video Game
    [Documentation]    Ключове слово, яке приймає аргументи з шаблону і робить POST запит
    [Arguments]    ${id}    ${name}    ${releaseDate}    ${reviewScore}    ${category}    ${rating}

    ${body}=    Create Dictionary
    ...    id=${id}
    ...    name=${name}
    ...    releaseDate=${releaseDate}
    ...    reviewScore=${reviewScore}
    ...    category=${category}
    ...    rating=${rating}

    ${header}=    Create Dictionary
    ...    Content-Type=application/json

    ${response}=    Post On Session    mysession    /app/videogames    json=${body}    headers=${header}

    Log to Console    ${response.status_code}
    Log to Console    ${response.content}

    Status Should Be    201    ${response}

    ${json_data}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json_data}[status]    Record Added Successfully

Clean Up Database And Sessions
    [Documentation]    Видалення всіх тестових даних, створених під час прогону
    Delete On Session    mysession    /app/videogames/5    expected_status=any
    Delete On Session    mysession    /app/videogames/6    expected_status=any
    Delete On Session    mysession    /app/videogames/7    expected_status=any
    Delete On Session    mysession    /app/videogames/8    expected_status=any
    Delete All Sessions