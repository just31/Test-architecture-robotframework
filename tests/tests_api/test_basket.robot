*** Settings ***
Resource        ${EXECDIR}${/}resources/tests_api/resource_client_api.robot      # основные настройки, переменные
Test Setup  Создать соединение по корзине
Test Teardown  Закрыть все соединения

*** Variables ***
${base_url_basket}         https://staging.com
${base_url}         ${base_url_basket}
${url_create_basket}              /api/v1/basket/baskets/
${url_create_tickets}              /api/v1/basket/tickets/
${url_update_tickets}              /api/v1/basket/tickets/3j_-DW4BdNJS2kpBya-P/


*** Test Cases ***
Создание объекта корзины
    [Tags]              Корзина(basket)
    ${data}=    Evaluate    {'uuid': (None, 'b2bb3b2c-ffc6-11e9-a353-9e97a793de25'), 'name': (None, 'AutoTest'), 'email': (None, 'test@test.com'), 'phone': (None, '+7 (111) 111-11-11'), 'site_name': (None, 'https://crocus-city.me'), 'ticket_ids': (None, 'HmdPoG0Bx5sQ7cncT5ee')}
    Creating object basket      ${url_create_basket}      ${data}

Получение данных из корзины по uuid
    [Tags]              Корзина(basket)
    Get data from basket by uuid

Добавление билетов в корзину
    [Tags]              Корзина(basket)
    Adding tickets to cart      ${url_create_tickets}

Обновление информации о билетах
    [Tags]              Корзина(basket)
    Update information about tickets      ${url_update_tickets}

Удаление билетов из корзины
    [Tags]              Корзина(basket)
    Delete tickets from the shopping cart

Обновление информации о корзине
    [Tags]              Корзина(basket)
    Update information about cart


*** Keywords ***
Создать соединение по корзине
    Create session     conn     ${base_url_basket}    disable_warnings=1

Creating object basket
    [Arguments]     ${url}      ${data}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}=    Post Request        conn    ${url}      files=${data}
                    Should be equal    ${response.status_code}    ${201}     msg=Статус данного запроса, не равен 201!
                    ${result_len_uuid} =     Get Length      ${response.json()["uuid"]}
                    Should Be True    ${result_len_uuid} > ${zero}     msg=Uuid basket is not settle!

                    Should be equal    ${response.json()["name"]}      AutoTest      msg=Basket name user is not AutoTest!
                    Should be equal    ${response.json()["email"]}      test@test.com      msg=Basket email user is not test@test.com!

    Set Suite Variable     @{uuid}     ${response.json()["uuid"]}

    Log             Status code = 201, Uuid basket is settle, Basket name user = AutoTest, Basket email user = test@test.com

Get data from basket by uuid
    ${url} =    Set Variable    /api/v1/basket/baskets/@{uuid}[0]
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Get request        conn     ${url}
    Check Status 200        ${url}
                    ${result_len_uuid} =     Get Length      ${response.json()["uuid"]}
                    Should Be True    ${result_len_uuid} > ${zero}     msg=Uuid basket is not settle!

                    Should be equal    ${response.json()["name"]}      AutoTest     msg=Basket name user is not AutoTest!
                    Should be equal    ${response.json()["email"]}      test@test.com      msg=Basket email user is not test@test.com!

    Log             Status code = 200, Uuid basket is settle, Basket name user = AutoTest, Basket email user = test@test.com

Adding tickets to cart
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${date} =	Get Current Date
    ${convert}=      Convert Date      ${date}      result_format=%Y-%m-%dT%H:%M:%S+03:00
    ${data}=    Evaluate    {'basket_uuid': (None, '@{uuid}[0]'), 'carryall_id': (None, '3j_-DW4BdNJS2kpBya-P'), 'price': (None, '9200.0'), 'event_date': (None, '2019-10-29T20:00:00+03:00'), 'margin': (None, '1.0'), 'created_at': (None, '${convert}')}
    ${response}=    Post Request        conn    ${url}      files=${data}
                    Should be equal    ${response.status_code}    ${201}     msg=Статус данного запроса, не равен 201!
                    Should Be True    ${response.json()["price"]} > ${zero}     msg=Price of added tickets is empty!

    Log             Status code = 201, Data in the basket has been successfully added, Price of added tickets is not empty

Update information about tickets
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${date} =	Get Current Date
    ${convert}=      Convert Date      ${date}      result_format=%Y-%m-%dT%H:%M:%S+03:00
    ${data}=    Evaluate    {'basket_uuid': (None, '@{uuid}[0]'), 'carryall_id': (None, '3j_-DW4BdNJS2kpBya-P'), 'price': (None, '9250.0'), 'event_date': (None, '2019-10-29T20:00:00+03:00'), 'margin': (None, '1.0'), 'created_at': (None, '${convert}')}
    ${response}=    Put request        conn    ${url}      files=${data}
                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!
                    Should Be True    ${response.json()["price"]} > ${zero}     msg=Ticket price is not has been updated!

    Log             Status code = 200, Ticket price has been updated and it is equal now = ${response.json()["price"]}

Delete tickets from the shopping cart
    ${url} =    Set Variable    /api/v1/basket/tickets/@{uuid}[0]_3j_-DW4BdNJS2kpBya-P
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Delete request        conn     ${url}
                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!
                    Should be equal    ${response.json()["status"]}      deleted      msg=Return status is not deleted!

    Log             Status code = 200, Return status = deleted

Update information about cart
    ${url} =    Set Variable    /api/v1/basket/baskets/@{uuid}[0]
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Get request        conn     ${url}
                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!

                    ${result_len_uuid} =     Get Length      ${response.json()["uuid"]}
                    Should Be True    ${result_len_uuid} > ${zero}     msg=Uuid basket is not updated!

    #log to console  ${response.json()}
    Log             Status code = 200, Basket information has been successfully updated, Uuid basket has been updated