*** Settings ***
Resource        ${EXECDIR}${/}resources/tests_api/resource_client_api.robot      # основные настройки, переменные
Test Setup  Создать соединение
Test Teardown  Закрыть все соединения

*** Variables ***
${url_events_search_empty}              /api/v1/search/?query=sd&host_name=crocus-city-hall.me
${url_events_search_part_word}              /api/v1/search/?query=Мил&host_name=crocus-city-hall.me


*** Test Cases ***
Проверка поиска по мероприятиям, если не было найдено результатов по запросу
    [Tags]              Поиск по событиям
    Check event search if no results were found for the query       ${url_events_search_empty}

Проверка поиска по мероприятиям, по указанному слову или части слова
    [Tags]              Поиск по событиям
    Checking the search for events, for the specified word or part of the word       ${url_events_search_part_word}


*** Keywords ***
Check event search if no results were found for the query
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Get request        conn     ${url}

                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!

                    ${results_event_len} =     Get Length      ${response.json()["results"]["event"]}

                    Should Be True    ${results_event_len} == ${zero}     msg=Results search is not empty!

    Log             Status code = 200, Results search is empty

Checking the search for events, for the specified word or part of the word
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Get request        conn     ${url}

                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!

                    ${event_title_len} =     Get Length      ${response.json()["results"]["event"][0]["title"]}

                    Should Be True    ${event_title_len} > ${zero}     msg=Results search on the specified phrases is the empty!

    Log             Status code = 200, Results search on the specified phrases is not empty


