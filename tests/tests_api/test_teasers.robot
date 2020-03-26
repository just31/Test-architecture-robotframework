*** Settings ***
Resource        ${EXECDIR}${/}resources/tests_api/resource_client_api.robot      # основные настройки, переменные
Test Setup  Создать соединение
Test Teardown  Закрыть все соединения

*** Variables ***
${url_teasers}              api/v1/teasers/?host_name=crocus-city.me
${url_teasers_id}              /api/v1/teasers/5/?host_name=crocus-city.me

*** Test Cases ***
Получить информацию по тизерам и площадкам по ним
    [Tags]              Тизеры мероприятий
    Get information on teasers and sites on them        ${url_teasers}

Получить информацию по тизерам определенной площадки
    [Tags]              Тизеры мероприятий
    Get information on teasers of a specific site       ${url_teasers_id}


*** Keywords ***
Get information on teasers and sites on them
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Get request        conn     ${url}

                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!

                    ${results_len} =     Get Length      ${response.json()["results"]}
                    ${results_len_convert} =     Convert To Integer      ${results_len}
                    ${lists_len} =     Get Length      ${response.json()["results"][0]["filter"]["lists"]["place"]["items"]}

                    Should Be True    ${results_len_convert} > ${zero}     msg=Results array is empty!
                    Should Be True    ${lists_len} > ${zero}     msg=List items teasers is empty!

    Log             Status code = 200, Results array is not empty, List items teasers is not empty


Get information on teasers of a specific site
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Get request        conn     ${url}

                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!

                    ${id} =     Convert To Integer      5

                    Should Be True    ${response.json()["id"]} == ${id}     msg=Id choice place teaser is not equal 5!

    Log             Status code = 200, Id choice place teaser is the equal 5

