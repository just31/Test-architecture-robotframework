*** Settings ***
Resource        ${EXECDIR}${/}resources/tests_api/resource_client_api.robot      # основные настройки, переменные
Test Setup  Создать соединение
Test Teardown  Закрыть все соединения

*** Variables ***
${url_news}              /api/v1/news/?host_name=site.com&sortBy=id&query=ТЕСТ
${url_new_id}              /api/v1/news/186/?host_name=site.com&query=Тестовая новость


*** Test Cases ***
Получение новостей сайта
    [Tags]              Новости
    Get site news       ${url_news}

Получение новостей сайта по id
    [Tags]              Новости
    Get site news by id       ${url_new_id}


*** Keywords ***
Get site news
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    Check Status 200        ${url_news}
    ${response}     Get request        conn     ${url}
                    ${new_id} =     Convert To Integer      186
                    Should be equal    ${response.json()["results"][0]['id']}      ${new_id}        msg=Test news id is not 186!
    Log             Status code = 200, Test news id = 186

Get site news by id
    [Arguments]     ${url}
    Set Suite Variable     ${REQUEST_URL}    ${url}

    Check Status 200        ${url_new_id}
    ${response}     Get request        conn     ${url}
                    ${new_id} =     Convert To Integer      186
                    Should be equal    ${response.json()["id"]}      ${new_id}        msg=Test news id is not 186!
    Log             Status code = 200, Test news id = 186, Slug is new - testovaja-novost


