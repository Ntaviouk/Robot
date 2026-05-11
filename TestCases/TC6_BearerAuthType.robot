*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem

*** Variables ***
${BASE_URL}         https://certtransaction.elementexpress.com
${BEARER_TOKEN}     Bearer E4F284BFADA11D01A52508ED7B92FFD7EE0905659F5DED06A4B73FC7739B48A287648801

*** Test Cases ***
Bearer Auth Test
    Create Session    mysession    ${BASE_URL}

    # Створюємо словник із заголовками
    ${headers}=    Create Dictionary    Authorization=${BEARER_TOKEN}    Content-Type=text/xml

    # Зчитуємо XML тіло запиту з файлу
    ${req_body}=   Get File    C:/SeleniumPractice/xmldata/PostData.txt

    # Використовуємо сучасне ключове слово POST On Session
    ${response}=   POST On Session    mysession    /    data=${req_body}    headers=${headers}    expected_status=200

    Log To Console    ${response.status_code}
    Log To Console    ${response.content}