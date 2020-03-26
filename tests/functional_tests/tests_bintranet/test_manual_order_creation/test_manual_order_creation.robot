*** Settings ***
Documentation   Test check manual order creation in bintranet.
# Подключаем файл с ключевыми словами, для данного теста. Можно выбирать любой, необходимый из папки ${EXECDIR}${/}resources/.
Resource        ${EXECDIR}${/}resources/functional_tests/functional_tests_bintranet/resources_common_bintranet.robot     # Ключевые слова, для функциональных тестов по бинтранету.
# Прописываем необходимые теги, для запуска данного теста, в каких-либо тестовых наборах.
Default Tags    Bintranet  Smoke  Regression   No_parallel


*** Variables ***
# Создаем переменную с базовым url, для тест-кейсов данного теста.
${url}      http://site.com/accounts/login/?next=/dev/

*** Test Cases ***
# Пишем ОСНОВНОЙ СЦЕНАРИЙ в тест-кейсах, для теста по проверке создания заказа вручную, в бинтранете.
Авторизация в дев-бинтранете под менеджером
    [Tags]              Проверка создания заказа вручную, в бинтранете
    ${step_2} =    Authorization in dev-bintranet        ${url}
    # Создаем переменную шагов ${STEP_2}, для продолжения данного теста. Если значение переменной true, продолжаем тест.
    Set Suite Variable     ${STEP_2}    ${step_2}
    Run Keyword If    "${STEP_2}"!="True"     Send fail message     Авторизация в дев-бинтранете под менеджером не сработала.
    Run Keyword If    "${STEP_2}"!="True"     Close test

Разлогинивание и завершение теста
    Run Keyword If    "${STEP_2}"=="True"     Close test    # Добавляем интервал в 2сек., между проверками. Закрываем браузер и завершаем тест.
    # Обнуляем переменные шагов, данного теста.
    Set Suite Variable     ${STEP_2}    ${null}

*** Keywords ***
# КЛЮЧЕВЫЕ СЛОВА, по проверке создания заказа вручную, в бинтранете.

Authorization in dev-bintranet
    [Arguments]     ${url}
    Open Browser On The Index Page      ${url}      ${BROWSER}  # Определяет тип браузера в котором будет произв. проверка. Прописывается в аргум. запуска: --variable BROWSER:headlesschrome.
    # Если пришло значение "separate", запускаем ключ. слово для проверки по отдельной роли.
    # Если нет, то ключ. слово проверяющее авторизацию в цикле, по всем трем ролям.
    Run Keyword If    "${type_check}"=="separate"     Login in bintranet and check page     ${user_name}      ${text_accaunt_value}
    ...     ELSE  Login in bintranet and check page all
    # Если данное ключевое слово отработало без ошибок, создаем переменную ${success} и возвращаем ее в тест-кейс.
    ${success} =    Set Variable    True
    [Return]    ${success}


