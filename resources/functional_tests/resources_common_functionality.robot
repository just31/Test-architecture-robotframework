# Проверка различного функционала сайтов Дорвея, не связанного с заказами билетов или сертификатов.
# Со списков ключевых слов, для каждой отдельной части проверяемого функционала.
*** Settings ***
Documentation   Keywords for checks basic functionality in sites Doorway
Library         SeleniumLibrary
Library         Collections
Library         DateTime
Library         String
Library	        Screenshot
# Ключевые слова, для отправления сообщений в слак.
Resource        ${EXECDIR}${/}resources/functional_tests/resource_for_slack.robot
# Общие для всех тестов, page object переменные.
Variables       ${EXECDIR}${/}page_objects/Elements_for_doorway.py

*** Keywords ***
#---ОБЩИЕ КЛЮЧЕВЫЕ СЛОВА, ОДИНАКОВЫЕ ДЛЯ РАЗЛИЧНЫХ ТЕСТОВ, ПО ПРОВЕРКЕ РАЗЛИЧНОГО ФУНКЦИОНАЛА САЙТОВ ДОРВЕЯ.----#

# Открываем браузер.
Open Browser On The Index Page
    [Arguments]     ${url}      ${type_browsers}
    Open Browser    ${url}      browser=${type_browsers}
    Set Window Size     1600	900
    Set Suite Variable     ${name_browsers}    ${type_browsers}

# Получаем список всех элементов языковой раскладки и их кол-во. Для прогона в них переданного ключевого слова.
Get list languages versions
    [Arguments]     ${url}      ${name_keywords}
    ${test_keywords} =    Set Variable    ${name_keywords}
    @{list_language}      Get WebElements        xpath: ${Шапка_Список_Языков}
    ${finish}   Get Element Count   xpath: ${Шапка_Список_Языков}
    log to console  Список иностранных языков равен ${finish-1}
    ${start} =  Set Variable If
    ...	    "${test_keywords}" == "Header elements"       0
    ...	    "${test_keywords}" == "Checking the site menu"       0
    # Создаем пустой список, для хранения всех атрибутов attribute=value, значений языкового меню.
    @{list_lang_elements}=    Create List

    # Заполняем список @{list_lang_elements} значениями attribute=value.
    :FOR  ${lang_element}  IN  @{list_language}
    \       ${HREF}     Get Element Attribute    ${lang_element}       attribute=value
    \       log to console  ${HREF}
    \       Append To List    ${list_lang_elements}   ${HREF}
    END

    # Делаем обход по каждому значению списка @{list_language}, с переходом на соответствующую яз. версию сайта.
    :FOR  ${lang_link}  IN  @{list_lang_elements}
    \       run keyword if  "${lang_link}" == "ru"
            ...    sleep  0
            ...    ELSE
            ...    Go to     ${url}/${lang_link}
    \       run keyword if  "${test_keywords}" == "Header elements"     Header elements     ${url}/${lang_link}
    \       run keyword if  "${test_keywords}" == "Checking the site menu"     Checking the site menu
    \       Sleep   2
    END
    Go to     ${url}
    sleep  2

# Проверяем появление всех элементов хедера.
Header elements
    [Arguments]     ${url}
    Появление элемента      xpath: ${Шапка_Вернуться_на_Главную}
    log to console          Шапка_Вернуться_на_Главную
    Появление элемента      xpath: ${Шапка_Афиша_и_Билеты}
    log to console          Шапка_Афиша_и_Билеты
    Появление элемента      xpath: ${Шапка_Подарочные_Сертификаты}
    log to console          Шапка_Подарочные_Сертификаты
    Появление элемента      xpath: ${Шапка_Гарантии}
    log to console          Шапка_Гарантии
    Появление элемента      xpath: ${Шапка_Поиск}
    log to console          Шапка_Поиск
    Появление элемента      xpath: ${Шапка_Корзина}
    log to console          Шапка_Корзина
    Появление элемента      xpath: ${Шапка_Меню}
    log to console          Шапка_Меню
    sleep  2
    log to console  ${url}/ все элементы найдены

# Проверяем переходы по ссылкам верхнего, выезжающего меню
Checking the site menu
    Появление элемента      xpath: ${Шапка_Меню}
    Sleep   2
    Click Element       xpath: ${Шапка_Меню}
    log to console  Открыли боковое меню сайта
    Sleep   2
    log to console  Ждём 2 секунды
    # Вычисляем количество страниц для проверки
    @{List}    Get WebElements     xpath: ${Меню_Поле_ссылок}
    # Создаем пустой список для ссылок меню
    @{list_href_menu}=    Create List

    # Заполняем список @{list_href_menu} ссылками всех пунктов меню
    :FOR  ${link_menu}  IN  @{List}
    \       ${href}    Get Element Attribute    ${link_menu}       attribute=href
    \       Append To List    ${list_href_menu}    ${href}
    END
    # Переходим по каждой из ссылок меню. Закрываем открытые вкладки ю-туба, в браузере.
    :FOR  ${link_menu}  IN  @{list_href_menu}
    \       Появление элемента      xpath: ${Шапка_Меню}
    \       Click Element   xpath: ${Шапка_Меню}
    \       Go to      ${link_menu}
    \       sleep  1
    \       Remove youtube tabs
    \       sleep  2

# Добавляем решение по ожиданию появления элемента(ов), чтобы тесты проходили успешно.
Появление элемента
    [Arguments]     ${xpath}
    FOR     ${index}    IN RANGE   0  9
    \    ${time_index}=  Run Keyword And Return Status  Page Should Contain Element      ${xpath}
    \    Run Keyword If      ${time_index}       Exit For Loop
    \    Sleep   1
    END

# Закрываем открытые вкладки ю-туба, в браузере.
Remove youtube tabs
    @{titles_var}        Get Window Titles
    ${titles_length}=    Get length    ${titles_var}
    sleep  1
    FOR     ${index}    IN RANGE   1  ${titles_length}
    \       ${status_new_tab}=  Run Keyword And Return Status       Select Window   title=${titles_var}[${index}]
#    \       log to console  Тайтл открытой вкладки ${titles_var}[${index}]
    \       Run Keyword If      ${status_new_tab}       Select Window   title=${titles_var}[${index}]
    \       Run Keyword If      ${status_new_tab}       sleep  1
    \       Run Keyword If      ${status_new_tab}       close window
    \       Run Keyword If    '${index}' == '${titles_length-1}'    log to console      Закрыли открытые вкладки youtube
    END
    Select Window   title=${titles_var}[0]



#-----КЛЮЧЕВЫЕ СЛОВА, ДЛЯ ОТДЕЛЬНЫХ ТЕСТОВ.-------

#-----ДЛЯ ТЕСТА ПО ПРОВЕРКЕ МЕНЮ В ХЕДЕРЕ:-------
# Проверяем сценарий работы левого, верхнего меню на всех языках.
Open site menu
    [Arguments]     ${url}
    # Проверяем наличие языковой раскладки на сайте. Если она есть, вызываем ключевое слово Get list languages versions, для проверки во всех яз. версиях.
    # Передаем в Get list languages versions, аргумент с синонимом основного ключевого слова, для проверки.
    ${check_status_lang_wrap}       Run Keyword And Return Status  Page Should Contain Element  xpath: ${Шапка_обертка}
    Run Keyword If    ${check_status_lang_wrap}    Get list languages versions     ${url}   Checking the site menu    ELSE    Checking the site menu


#-----ДЛЯ ТЕСТА ПО ПРОВЕРКЕ ВСЕХ ЭЛЕМЕНТОВ В ХЕДЕРЕ:-------
# Проверяем шапку сайтов Дорвея, на наличие в ней всех обязательных элементов, во всех языковых версиях.
Check all header elements
    [Arguments]     ${url}
    # Проверяем наличие языковой раскладки на сайте. Если она есть, вызываем ключевое слово Get list languages versions, для проверки во всех яз. версиях.
    # Передаем в Get list languages versions, аргумент с синонимом основного ключевого слова, для проверки.
    ${check_status_lang_wrap}       Run Keyword And Return Status  Page Should Contain Element  xpath: ${Шапка_обертка}
    Run Keyword If    ${check_status_lang_wrap}    Get list languages versions     ${url}   Header elements    ELSE    Header elements      ${url}
