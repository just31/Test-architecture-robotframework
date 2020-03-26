*** Settings ***
Resource        ${EXECDIR}${/}resources/tests_api/resource_client_api.robot      # основные настройки, переменные
Test Setup  Создать соединение
Test Teardown  Закрыть все соединения

*** Variables ***
${url_form_order_call}              /api/v1/callback/

*** Test Cases ***
Отправка заявки Заказать звонок
    [Tags]              Форма Заказать звонок
    ${host_name}     Fetch From Right    ${base_url}     https://
    ${headers}=    Create Dictionary    Content-Type    application/json
    ${data} =    Set Variable    {"host_name": "${host_name}","name": "AutoTest","phone": "89111111111","email": "test@test.com","event_id": "82688","title": "Alekseev. Моя звезда"}
    Sending a request to Order a call       ${url_form_order_call}       ${headers}      ${data}


*** Keywords ***
Sending a request to Order a call
    [Arguments]     ${url}      ${headers}      ${data}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}=    Post Request        conn    ${url}       headers=${headers}        data=${data}
                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!

                    ${len_bintranet_id} =     Get Length      ${response.json()["bintranet_id"]}

                    Should Be True    ${len_bintranet_id} > ${zero}     msg=Bintranet id is empty!
                    Should be equal    ${response.json()["email"]}      test@test.com     msg=Email custom tester is not test@test.com!

    Log             Status code = 200, Bintranet id is not empty, Email custom tester = test@test.com