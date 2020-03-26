# Проверка различного функционала по Бинтранету.
# Со списков ключевых слов, для каждой отдельной части проверяемого функционала.
*** Settings ***
Documentation   Keywords for checks functionality in Bintranet
Library         SeleniumLibrary
Library         Collections
Library         DateTime
Library         String
Library	        Screenshot
# Ключевые слова, для отправления сообщений в слак.
Resource        ${EXECDIR}${/}resources/functional_tests/resource_for_slack.robot
# Общие для всех тестов, page object переменные.
Variables       ${EXECDIR}${/}page_objects/Elements_for_bintranet.py

*** Variables ***
${url_dev}      http://site.com/dev/


*** Keywords ***
#---ОБЩИЕ КЛЮЧЕВЫЕ СЛОВА, ОДИНАКОВЫЕ ДЛЯ РАЗЛИЧНЫХ ТЕСТОВ, ПО ПРОВЕРКЕ РАЗЛИЧНОГО ФУНКЦИОНАЛА В БИНТРАНЕТЕ.----#

# Открываем браузер.
Open Browser On The Index Page
    [Arguments]     ${url}      ${type_browsers}
    Open Browser    ${url}      browser=${type_browsers}
    Set Window Size     1600	900
    Set Suite Variable     ${name_browsers}    ${type_browsers}

# Проверяем авторизацию, по трем разным ролям: менеджер, логист, администратор.
Login in bintranet and check page
    [Arguments]     ${user_name}      ${text_accaunt_value}
    Set Tags        ${text_accaunt_value}
    Press Key      xpath: ${Имя_Пользователя_Bintranet}        ${user_name}
    Press Key      xpath: ${Пароль_Пользователя_Bintranet}         ${password_for_all_accaunts}
    Click Element   xpath: ${Кнопка_Войти}
    sleep  3
    # Если зашли не в дев-бинтранет, переходим принудительно по ссылке на дев-бинтранет.
    ${status_no_dev}=  Run Keyword And Return Status  Page Should Contain Element      ${Синий_Фон_страницы}
    Run Keyword If      ${status_no_dev}       Go to      ${url_dev}
    log to console  Вошли в бинтранет
    # Проверяем наличие правой панели, перекрывающей кнопку Выхода. Если она есть, закрываем ее.
    ${status_right_panel}=  Run Keyword And Return Status  Element Should Be Visible      ${Правая_Панель}
    Run Keyword If      ${status_right_panel}       Click Element   xpath: ${Правая_Панель}
    sleep  1
    # Получаем тайтл страницы и название роли аккаунта. Проверяем их с ожидаемыми.
    ${title} =      Get Title
    Should be equal    ${title}     Бинтранет      msg=Тайтл страницы не равен Бинтранет!
    ${text_account} =      Get Text    ${Название_Аккаунта}
    log to console  ${text_accaunt_value}
    ${matches}=     Get Regexp Matches  ${text_account}   ${text_accaunt_value}
    should be equal as strings  ${matches[0]}   ${text_accaunt_value}        msg=Текст вверху с названием роли пользователя, не содержит слово ${text_accaunt_value}!
    log to console  Проверили статусы тайтла и названия аккаунта. Статусы совпали.
    sleep  2
    Run Keyword If    "${type_check}"=="all"     Logout in bintranet for multi

# Проверяем общую авторизацию, по трем разным ролям: менеджер, логист, администратор. В цикле перебора данных.
Login in bintranet and check page all
    ${data_for_check}    Create Dictionary      tester_manager=Менеджер     tester_logist=Логист     tester_admin=Администратор
    ${items}    Get Dictionary Items   ${data_for_check}

    :FOR    ${user_name}    ${text_accaunt_value}    IN    @{items}
    \    Login in bintranet and check page     ${user_name}      ${text_accaunt_value}

# Если прошла проверка авторизации только по одной роли, то делаем logout по ней.
Logout in bintranet for single
    Click Element   xpath: ${Ссылка_На_Профиль_Пользователя}
    sleep  2
    Click Element   xpath: ${Ссылка_Выход}
    log to console  Вышли из бинтранета
    sleep  5
    log to console  Завершили тест

# Если идет проверка авторизации, сразу по всем 3 ролям, то делаем logout по каждой роли.
Logout in bintranet for multi
    # Выходим из бинтранета
    Click Element   xpath: ${Ссылка_На_Профиль_Пользователя}
    sleep  2
    Click Element   xpath: ${Ссылка_Выход}
    log to console  Вышли из бинтранета
    sleep  5
    log to console  Завершили тест

# Выходим из бинтранета
Close test
    Run Keyword If    "${type_check}"=="separate"     Logout in bintranet for single
    # Закрываем браузер и завершаем тест.
    [Teardown]    Close Browser
    Sleep   2














