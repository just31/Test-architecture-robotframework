*** Settings ***
Resource        ${EXECDIR}${/}resources/tests_api/resource_client_api.robot      # основные настройки, переменные
Test Setup  Создать соединение по отзывам с Мхат
Test Teardown  Закрыть все соединения

*** Variables ***
${base_url_reviews}         https://mx.theater
${base_url}         ${base_url_reviews}
${url_reviews}              /api/v1/reviews/52/?host_name=mx.theater
${url_create_reviews}              /api/v1/reviews/
${url_get_review_by_id}              /api/v1/reviews/3069/?host_name=staging.com


*** Test Cases ***
Получение отзывов о мероприятии
    [Tags]              Отзывы
    Getting feedback about the event       ${url_reviews}

Добавить отзыв к мероприятию
    [Tags]              Отзывы
    Add feedback to the event       ${url_create_reviews}

Получение отзывов по ID события с керриола
    [Tags]              Отзывы
    Getting feedback on the event ID from carryol       ${url_get_review_by_id}


*** Keywords ***
Создать соединение по отзывам с Мхат
    Create session     conn     ${base_url_reviews}    disable_warnings=1

Getting feedback about the event
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Get request        conn     ${url}
                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!

                    ${result_len} =     Get Length      ${response.json()["results"]}

                    Should Be True    ${response.json()["count"]} > ${zero}     msg=Сount value is empty!
                    Should Be True    ${result_len} > ${zero}     msg=Results array is empty!

    Log            Status code = 200, Сount value is not empty, Results array is not empty

Add feedback to the event
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${data}=    Evaluate    {'host_name': (None, 'mx.theater'), 'name': (None, 'AutoTest'), 'text': (None, 'Complex feeling, in General..'), 'event_id': (None, '3805'), 'parser_name': (None, 'test')}
    ${response}=    Post Request        conn    ${url}      files=${data}
                    Should be equal    ${response.status_code}    ${201}    msg=Статус данного запроса, не равен 201!

                    ${id_convert} =     Convert To Integer      3805

                    Should be equal    ${response.json()["name"]}    AutoTest    msg=Name user is not - AutoTest!
                    Should be equal    ${response.json()["event_id"]}    ${id_convert}    msg=Event id is not 3805!

    Log            Status code = 201, Name user is AutoTest, Event id is 3805

Getting feedback on the event ID from carryol
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    ${response}     Get request        conn     ${url}
                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!

                    ${reviews_array_len}=     Get Length      ${response.json()["results"]}
                    ${field_text_len}=     Get Length      ${response.json()["results"][0]["text"]}

                    Should Be True    ${reviews_array_len} > ${zero}     msg=Array results with reviews is empty!
                    Should Be True    ${field_text_len} > ${zero}     msg=Field text in results with reviews is empty!

    Log             Status code = 200, Array results with reviews is not empty, Field text in results with reviews is not empty





