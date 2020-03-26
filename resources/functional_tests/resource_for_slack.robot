#-----КЛЮЧЕВЫЕ СЛОВА, ДЛЯ ОТПРАВЛЕНИЯ СООБЩЕНИЙ В СЛАК.-------

*** Keywords ***
# Отправляем сообщения в слак, в случае негативных результатов проверок в ключевых словах.
Send fail message
    [Arguments]     ${text_message}
    ${url}=    Get Location
    Set Suite Variable     ${fell_here}    ${url}
    ${fell_capture} =	Capture Page Screenshot
    Set Suite Variable     ${fell_screen}      ${fell_capture}

    # Создаем список, содержащий значения: url, доп. текста и скриншота, для отправления их в сообщении в слак.
    @{url_with_screen_and_text} =	Create List	    ${fell_here}	${fell_screen}	${text_message}
    Set Suite Variable     ${url_with_screen_and_text}    ${null}

    Sleep   2

# Пишем в лог-теста сообщение об успешном прохождении теста.
Success test
   Log            Тест пройден успешно!
   Set Suite Variable     ${url_with_screen_and_text}    ${null}
   Sleep   2