*** Settings ***
Library    json
Resource        ${EXECDIR}${/}resources/tests_api/resource_client_api.robot      # основные настройки, переменные
Test Setup  Создать соединение по новым автотестам
Test Teardown  Закрыть все соединения

*** Variables ***
${base_url_create_autotest}         http://qa.site.com
${url_create_autotest}              /api/v2/autoTests


*** Test Cases ***
Создание нового автотеста
    [Tags]              AutoTests TestIT
    ${headers}=    Create Dictionary    Content-Type    application/json-patch+json    Authorization=PrivateToken YOUR_TOKEN
    ${data} =    Set Variable    ck on the Poster and tickets", "Click on Gift certificates", "Click the search button", "Click on the Burger menu", "Changing the language versions of the site", "Working time display", "Side basket", "Press the Home button"]}
    Create AutoTest       ${url_create_autotest}       ${headers}      ${data}



*** Keywords ***
Создать соединение по новым автотестам
    Create session     conn     ${base_url_create_autotest}    disable_warnings=1

Create AutoTest
    [Arguments]     ${url}      ${headers}      ${data}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}=    Post Request        conn    ${url}       headers=${headers}        data=${data}

    log to console  ${data}
    log to console  ${response.json()}







