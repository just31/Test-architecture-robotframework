*** Settings ***
Documentation   Test check authorization in bintranet.
# Подключаем файл с ключевыми словами, для данного теста. Можно выбирать любой, необходимый из папки ${EXECDIR}${/}resources/.
Resource        ${EXECDIR}${/}resources/functional_tests/functional_tests_bintranet/resources_common_bintranet.robot     # Ключевые слова, для функциональных тестов по бинтранету.
# Прописываем необходимые теги, для запуска данного теста, в каких-либо тестовых наборах.
Default Tags    Bintranet  Smoke  Regression   No_parallel


*** Variables ***
# Добавляем переменные с описанием теста и текстом для тегов теста. Для передачи их в листенер формирующий тест-кейсы.
${test_name}      check authorization in bintranet
${test_tags}      Проверка авторизации в бинтранете

*** Test Cases ***
# Тест-кейс заглушка, для запуска основного сценария данного теста.
First test case
    log         Start tests

*** Keywords ***
# ОСНОВНОЙ СЦЕНАРИЙ ТЕСТА, по проверке авторизации в бинтранете.
# Ключевые слова в сценарии теста, могут варьироваться.

Test run    # Общее ключевое слово, для всех тестов. Которое вызывается из листенера. Подключает в себе ключевое слово, конкретное для каждого теста.
    [Arguments]     ${url}
    Open Browser On The Index Page      ${url}      ${BROWSER}  # Определяет тип браузера в котором будет произв. проверка. Прописывается в аргум. запуска: --variable BROWSER:headlesschrome.
    Сheck authorization in bintranet

Сheck authorization in bintranet
    # Если пришло значение "separate", запускаем ключ. слово для проверки по отдельной роли.
    # Если нет, то ключ. слово проверяющее авторизацию в цикле, по всем трем ролям.
    Run Keyword If    "${type_check}"=="separate"     Login in bintranet and check page     ${user_name}      ${text_accaunt_value}
    ...     ELSE  Login in bintranet and check page all

    Close test    # Добавляем интервал в 2сек., между проверками. Закрываем браузер и завершаем тест.