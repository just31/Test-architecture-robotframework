*** Settings ***
Resource        ${EXECDIR}${/}resources/tests_api/resource_client_api.robot      # основные настройки, переменные
Test Setup  Создать соединение
Test Teardown  Закрыть все соединения

*** Variables ***
${url_venues_list_filters_dev}              /api/v1/venues/filters/common/?host_name=dev.juventus.com.ru
${url_venues_by_letter_slag_dev}              /api/v1/venues/?host_name=dev.efront.tix-system.com&letter_query=З&cities=sochi


*** Test Cases ***
Получение справочника по фильтрам площадки
    [Tags]              Матрешка     Dev
    Getting a guide to site filters         ${url_venues_list_filters_dev}

Получение событий по первой букве и слагу города
    [Tags]              Матрешка     Dev
    Getting events by the first letter and slug of the city         ${url_venues_by_letter_slag_dev}

*** Keywords ***
Getting a guide to site filters
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Get request        conn     ${url}
                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!

                    ${cities_len} =     Get Length      ${response.json()["cities"]}
                    ${place_types_len} =     Get Length      ${response.json()["place_types"]}

                    Should Be True    ${cities_len} > ${zero}     msg=Object cities is empty!
                    Should Be True    ${place_types_len} > ${zero}     msg=Object place_types is empty!

    Log             Status code = 200, Object cities is not empty, Object place_types is not empty

Getting events by the first letter and slug of the city
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Get request        conn     ${url}
                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!

                    ${results_len} =     Get Length      ${response.json()["results"]}
                    ${name_len} =     Get Length      ${response.json()["results"][0]["name"]}
                    ${city_name_len} =     Get Length      ${response.json()["results"][0]["city"]["name"]}

                    Should Be True    ${results_len} > ${zero}     msg=Results array is empty!
                    Should Be True    ${name_len} > ${zero}     msg=First item name is empty!
                    Should Be True    ${city_name_len} > ${zero}     msg=City name first item is not equal Сочи!

    Log             Status code = 200, Results array is not empty, First item name is not empty, City name first item = Сочи



