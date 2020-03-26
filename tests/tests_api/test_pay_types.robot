*** Settings ***
Resource        ${EXECDIR}${/}resources/tests_api/resource_client_api.robot      # основные настройки, переменные
Test Setup  Создать соединение
Test Teardown  Закрыть все соединения

*** Variables ***
${url_pay_types}              /api/v1/pay-types/?host_name=mbronnaya.com
${url_pay_types_id}              /api/v1/pay-types/1/?host_name=mbronnaya.com


*** Test Cases ***
Получение списка платежных типов
    [Tags]              Платежные типы
    Getting a list of payment types       ${url_pay_types}

Получение списка платежного типа по id
    [Tags]              Платежные типы
    Getting a list of payment types by id      ${url_pay_types_id}


*** Keywords ***
Getting a list of payment types
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Get request        conn     ${url}
                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!

                    ${results_len} =     Get Length      ${response.json()["results"]}

                    Should Be True    ${results_len} > ${zero}     msg=Results array with payment types is empty!

    Log             Status code = 200, Results array with payment types is not empty

Getting a list of payment types by id
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Get request        conn     ${url}
                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!

                    ${id_pay_types} =     Convert To Integer      1

                    Should be equal    ${response.json()["id"]}      ${id_pay_types}     msg=Id this is type pay no equal 1!
                    Should be equal    ${response.json()["title"]}      Наличными курьеру     msg=Title this is type pay is not Наличными курьеру!

    Log             Status code = 200, Id this is type pay = 1, Title this is type pay, is Наличными курьеру







