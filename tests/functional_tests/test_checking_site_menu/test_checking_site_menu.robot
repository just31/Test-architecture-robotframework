*** Settings ***
Documentation   Test header elements on the doorway sites.
# Подключаем файл с ключевыми словами, для данного теста. Можно выбирать любой, необходимый из папки ${EXECDIR}${/}resources/.
Resource        ${EXECDIR}${/}resources/functional_tests/resources_common_functionality.robot     # Ключевые слова, для тестирования различного функционала на сайтах Дорвея.
# Прописываем необходимые теги, для запуска данного теста, в каких-либо тестовых наборах.
Default Tags    Functionality  Smoke  Regression   No_parallel


*** Variables ***
# Добавляем переменные с описанием теста и текстом для тегов теста. Для передачи их в листенер формирующий тест-кейсы.
${test_name}      checking site menu
${test_tags}      Проверка работы верхнего, выезжающего меню сайта

*** Test Cases ***
# Тест-кейс заглушка, для запуска основного сценария данного теста.
First test case
    log         Start tests

*** Keywords ***
# ОСНОВНОЙ СЦЕНАРИЙ ТЕСТА, по проверке работы верхнего, выезжающего меню сайта.
# Ключевые слова в сценарии теста, могут варьироваться.

Test run    # Общее ключевое слово, для всех тестов. Которое вызывается из листенера. Подключает в себе ключевое слово, конкретное для каждого теста.
    [Arguments]     ${url}
    Open Browser On The Index Page      ${url}      ${BROWSER}  # Определяет тип браузера в котором будет произв. проверка. Прописывается в аргум. запуска: --variable BROWSER:headlesschrome.
    Check site menu     ${url}

Check site menu
    [Arguments]     ${url}
    Open site menu      ${url}

    [Teardown]    Close test    # Добавляем интервал в 2сек., между проверками. Закрываем браузер и завершаем тест.

Close test
    Close Browser
    Sleep   2