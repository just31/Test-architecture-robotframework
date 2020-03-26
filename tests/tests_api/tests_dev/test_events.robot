*** Settings ***
Resource        ${EXECDIR}${/}resources/tests_api/resource_client_api.robot      # основные настройки, переменные
Test Setup  Создать соединение
Test Teardown  Закрыть все соединения

*** Variables ***
${url_events_carryoll_dev}             /api/v1/events/poster_filters/?host_name=dev.juventus.com.ru


*** Test Cases ***
Получение данных по фильтрам из carryall на деве
    [Tags]              Мероприятия     Dev
    Getting events from the carryoll on dev       ${url_events_carryoll_dev}


*** Keywords ***
Getting events from the carryoll on dev
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Get request        conn     ${url}
                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!

                    Should be equal    ${response.json()["lists"]["genre"]["name"]}    genre    msg=Results array no contains object genre!

    Log             Status code = 200, Results array contains object genre


