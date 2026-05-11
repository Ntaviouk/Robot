*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    https://maps.googleapis.com
# Прибрано знак '?' в кінці шляху
${REQ_URI}     /maps/api/place/nearbysearch/json

*** Test Cases ***
Google Map Places API TC
    Create Session    mysession    ${BASE_URL}

    # Створюємо словник із параметрами запиту (query parameters)
    ${params}=    Create Dictionary    location=-33.8670522,151.1957362    radius=500    types=food    name=harbour    key=YOUR_API_KEY

    # Використовуємо сучасне ключове слово GET On Session
    ${response}=    GET On Session    mysession    ${REQ_URI}    params=${params}    expected_status=200

    Log To Console    ${response.status_code}
    Log To Console    ${response.content}