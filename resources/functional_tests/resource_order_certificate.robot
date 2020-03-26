*** Settings ***
Documentation   Keywords for order certificate testing
Library         SeleniumLibrary
Library         ExtendedSelenium2Library
Library         Collections
Library         DateTime
Library         String
Library	        Screenshot
# Ключевые слова, для отправления сообщений в слак.
Resource        ${EXECDIR}${/}resources/functional_tests/resource_for_slack.robot
# Общие для всех тестов, page object переменные.
Variables       ${EXECDIR}${/}page_objects/Elements_for_doorway.py

*** Keywords ***
#---ОБЩИЕ КЛЮЧЕВЫЕ СЛОВА, ОДИНАКОВЫЕ ДЛЯ РАЗЛИЧНЫХ ТЕСТОВ, В ПРОВЕРКАХ ЗАКАЗА СЕРТИФИКАТА(ОВ).----#

# Открываем браузер.
Open Browser On The Index Page
    [Arguments]     ${url}      ${type_browsers}
    Open Browser    ${url}      browser=${type_browsers}
    Set Window Size     1600	900
    Set Suite Variable     ${name_browsers}    ${type_browsers}

# Проверяем сценарий заказа сертификата, в русской версии сайтов.
Click List Serteficate
    [Arguments]     ${url}
    Появление элемента      xpath: ${Шапка_Подарочные_Сертификаты}
    Go to   ${url}/certificates/
    Появление элемента  xpath: ${Сертификат_Выберите_сертификат}
    log to console  На странице отобразилась кнопка "Выберите сертификат"

    # Собираем список сертификатов
    @{lits_serteficate}      Get WebElements        xpath: ${Сертификат_Список_сертификатов}
    # Количество сертификатов
    ${finish}   Get Element Count   xpath: ${Сертификат_Список_сертификатов}
    : FOR   ${index}    IN RANGE    1    2
    \       # Наименование сертификата на странице
    \       ${HREF2} =  Get Text      xpath: ${Сертификат_Наименование_Сертификата_}${index +1}${Сертификат_Наименование_Сертификата_продолжение}
    \       log to console  Записали название сертификата для проверки
    \       Click Element   xpath: ${Сертификат_Кнопка_Выбрать_}${index +1}${Сертификат_Кнопка_Выбрать_продолжение}
    \       # Проверяем совпадение элеменов
    \       Появление элемента      xpath: ${Сертификат_Кнопка_Продолжить}
    \       Log to console   Загрузилась кнопка "Продолжить"
    \       ${HREF} =  Get Text      xpath: ${Сертификат_Наименование_Сертификата2}
    \       log to console  Названия сертификатов совпали
    \       Run keyword if   '${HREF2}' == '${HREF}'  Выбор дизайна и номинала
    \       Click Element   xpath: ${Сертификат_Кнопка_Продолжить}
    \       Появление элемента   xpath: ${Сертификат_Кнопка_Оформить}
    \       Заполнение_1
    \       Click Element   xpath: ${Сертификат_Кнопка_Оформить}
    \       Sleep   2
    \       # Оформление заказа на странице корзины
    \       Появление элемента     xpath: //*[@id="cart-order-form"]
    \       Sleep   2
    \       Ваш заказ
    \       Check transition on acquiring       # Проверяем в ТЕСТЕ перехода на эквайринг, был ли переход на страницу эквайринга.
    END

# Выбираем дизайн и номинал сертификата.
Выбор дизайна и номинала
    Input Text      xpath: //*[@id='summa']     10000
    ${sport1}=  Run Keyword And Return Status  Page Should Contain Element  xpath: ${Сертификат_Шаблон_Дизайна_2}
    Run Keyword If   ${sport1}    Dizig2
    ${sport2}=  Run Keyword And Return Status  Page Should Contain Element  xpath: ${Сертификат_Шаблон_Дизайна_3}
    Run Keyword If   ${sport2}    Dizig3

    ${sport3}=  Run Keyword And Return Status  Page Should Contain Element  xpath: ${Сертификат_Шаблон_Дизайна_1}
    Run Keyword If   ${sport1}    Dizig1

Dizig2
    Click Element   xpath: ${Сертификат_Шаблон_Дизайна_2}
    ${1}    Get Element Attribute    xpath: ${Сертификат_Шаблон_Дизайна_2}        attribute=data-url
    ${2}    Get Element Attribute    xpath: ${Сертификат_Шаблон_Главный}        attribute=data-url
    Should Be Equal As Strings    ${1}   ${2}
    log to console  Дизайн 2 и шаблон совпали
Dizig3
    Click Element   xpath: ${Сертификат_Шаблон_Дизайна_3}
    ${1}    Get Element Attribute    xpath: ${Сертификат_Шаблон_Дизайна_3}      attribute=data-url
    ${2}    Get Element Attribute    xpath: ${Сертификат_Шаблон_Главный}        attribute=data-url
    Should Be Equal As Strings    ${1}   ${2}
    log to console  Дизайн 3 и шаблон совпали
Dizig1
    Click Element   xpath: ${Сертификат_Шаблон_Дизайна_1}
    ${1}    Get Element Attribute    xpath: ${Сертификат_Шаблон_Дизайна_1}        attribute=data-url
    ${2}    Get Element Attribute    xpath: ${Сертификат_Шаблон_Главный}      attribute=data-url
    Should Be Equal As Strings    ${1}   ${2}
    log to console  Дизайн 1 и шаблон совпали

# Заполняем тестовыми, пользовательскими данными форму в шагах заказа сертификата.
Заполнение_1
    Press Key      xpath: ${Сертификат_Поле_Формы_Email}       test@test.com
    Press Key      xpath: ${Сертификат_Поле_Формы_Phone}        81111111111
    Press Key      xpath: ${Сертификат_Поле_Формы_Сообщение}       Test Test Test Test Test
    Sleep   2
    log to console  Заполнили данные о сертификате

# Заполняем тестовыми данными форму на странице корзины, после выбора и оформления сертификата.
Ваш заказ
    Press Key      xpath: ${Корзина_Поле_Формы_Name}        AutoTest
    Press Key      xpath: ${Корзина_Поле_Формы_Surname}        Test Test
    Press Key      xpath: ${Корзина_Поле_Формы_Phone}         11111111111
    Press Key      xpath: ${Корзина_Поле_Формы_Email}        test@test.com
    Press Key      xpath: ${Корзина_Поле_Формы_Address}        Индекс, улица, дом, квартира (подъезд/домофон)
    Press Key      xpath: ${Корзина_Поле_Формы_Comment}        Комментарий
    Sleep   2
    log to console  Заполнили поля перед эквайрингом
    #Click Element   xpath: ${Корзина_Кнопка_Оформить_Заказ}
    ${element}=	    Execute JavaScript  $("${Корзина_Кнопка_Оформить_Заказ_Js}").css('display','block').click();

    ${url_page}=    Get Location
    ${old_wait}=  Set selenium implicit wait  30
    ${check_no_go_with_current_page}=  Run Keyword And Return Status  Wait For Element To Be Visible   xpath: ${Шапка_Поиск}   30s
    Run Keyword If    ${check_no_go_with_current_page}   Send fail message     ${null}
    set selenium implicit wait  ${old_wait}
    Sleep   12

# Добавляем решение по ожиданию появления элемента(ов), чтобы тесты проходили успешно.
Появление элемента
    [Arguments]     ${xpath}
    FOR     ${index}    IN RANGE   0  9
    \    ${time_index}=  Run Keyword And Return Status  Page Should Contain Element      ${xpath}
    \    Run Keyword If      ${time_index}       Exit For Loop
    \    Sleep   1
    END






#-----КЛЮЧЕВЫЕ СЛОВА, ДЛЯ ОТДЕЛЬНЫХ ТЕСТОВ.-------

#-----ДЛЯ ТЕСТА ПО ЭКВАЙРИНГУ:-------
# Проверяем в ТЕСТЕ проверки перехода на эквайринг, был ли переход или нет на страницу эквайринга.
# В случае, если перехода не было, шлем данные по сайту, в слак.
Check transition on acquiring
    ${check_status_no_go_with_current_page}       Run Keyword And Return Status  Page Should Contain Element  xpath: ${Шапка_Поиск}
    ${check_no_go_with_current_page} =  Set Variable If  "${name_browsers}" == "headlesschrome"       ${check_status_no_go_with_current_page}
    ${check_such_page}=  Run Keyword And Return Status  Page Should Contain  Номер вашего заказа
    Run Keyword If    ${check_no_go_with_current_page} or ${check_such_page}   Send fail message     Сайт на котором не произошел переход на эквайринг:    ELSE    Success test
    # Send fail message, Success test - Ключевые слова находящиеся в файле ресурсов - resource_for_slack.robot.
    # 1. Отправляет fail-сообщения в слак. 2. Пишет в лог-теста сообщение об успешном прохождении теста.




