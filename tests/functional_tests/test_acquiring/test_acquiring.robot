*** Settings ***
Documentation   Test check ekvaring on the doorway sites.
# Подключаем файл с ключевыми словами, для данного теста. Можно выбирать любой, необходимый из папки ${EXECDIR}${/}resources/.
Resource        ${EXECDIR}${/}resources/functional_tests/resource_order_certificate.robot     # Ключевые слова, для тестирования заказа сертификата.
# Прописываем необходимые теги, для запуска данного теста, в каких-либо тестовых наборах.
Default Tags    Sanity  Smoke  Regression   No_parallel


*** Variables ***
# Добавляем переменные с описанием теста и текстом для тегов теста. Для передачи их в листенер формирующий тест-кейсы.
${test_name}      check ekvaring
${test_tags}      Проверка перехода на эквайринг

*** Test Cases ***
# Тест-кейс заглушка, для запуска основного сценария данного теста.
First test case
    log         Start tests

*** Keywords ***
# ОСНОВНОЙ СЦЕНАРИЙ ТЕСТА, по проверке перехода на страницу эквайринга.
# Ключевые слова в сценарии теста, могут варьироваться.

Test run    # Общее ключевое слово, для всех тестов. Которое вызывается из листенера. Подключает в себе ключевое слово, конкретное для каждого теста.
    [Arguments]     ${url}
    Open Browser On The Index Page      ${url}      headlesschrome
    Check ekvaring     ${url}

Check ekvaring
    [Arguments]     ${url}
    Click List Serteficate      ${url}

    [Teardown]    Close test    # Добавлеям интервал в 2сек., между проверками. Закрываем браузер и завершаем тест.

Close test
    Close Browser
    Sleep   2
