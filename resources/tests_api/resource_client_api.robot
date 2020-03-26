*** Settings ***
Documentation       Documentation   АВТОМАТИЗАЦИЯ API-ТЕСТОВ НА ROBOT FRAMEWORK.
Library             RequestsLibrary
Library             DateTime
Library             String

*** Variables ***
# ${base_url}         https://preprod.com
${zero} =     0

*** Keywords ***
Создать соединение
    Create session     conn     ${base_url}    disable_warnings=1

Закрыть все соединения
    Delete all sessions

Check Status 200
    [Arguments]    ${url}
    ${response}     Get request        conn     ${url}
                    Should be equal    ${response.status_code}    ${200}    msg=Статус данного запроса, не равен 200!
    ...                 msg=При выполнении GET ${url} был получен код состояния, отличный от 200 ОК.