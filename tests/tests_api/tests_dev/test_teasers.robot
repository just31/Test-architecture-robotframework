*** Settings ***
Resource        ${EXECDIR}${/}resources/tests_api/resource_client_api.robot      # основные настройки, переменные
Test Setup  Создать соединение
Test Teardown  Закрыть все соединения

*** Variables ***
${url_teasers_dev}              /api/v1/teasers/?host_name=dev.juventus.com.ru


*** Test Cases ***
Получение тизерных блоков, на указанном в host_name сайте
    [Tags]              Тизеры мероприятий     Dev
    Getting teaser blocks on the site specified in host_name         ${url_teasers_dev}


*** Keywords ***
Getting teaser blocks on the site specified in host_name
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Get request        conn     ${url}
                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!

                    ${results_len} =     Get Length      ${response.json()["results"]}
                    ${first_item_name_len} =     Get Length      ${response.json()["results"][0]["name"]}

                    Should Be True    ${results_len} > ${zero}     msg=Results array is empty!
                    Should Be True    ${first_item_name_len} > ${zero}     msg=First item name is empty!

    Log             Status code = 200, Results array is not empty, First item name is not empty



