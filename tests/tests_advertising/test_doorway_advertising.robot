*** Settings ***
Documentation   Test go to advertising, from search google.com
# Подключаем файл с ключевыми словами, для данного теста. Можно выбирать любой, необходимый из папки ${EXECDIR}${/}resources/.
Resource        ${EXECDIR}${/}resources/tests_advertising/resource_advertising.robot      # Ключевые слова для тестирования переходов на сайты из поиска из рекламы.
# Прописываем необходимые теги, для запуска данного теста, в каких-либо тестовых наборах.
Default Tags    Sanity  Smoke  Regression


*** Variables ***
# Добавляем переменные с описанием теста и текстом для тегов теста. Для передачи их в листенер формирующий тест-кейсы.
${test_name}      Перейти на сайт
${test_tags}      Переход из рекламы на топовые сайты дорвеев

*** Test Cases ***
# Тест-кейс заглушка, для запуска основного сценария данного теста.
First test case
    log     Start tests

*** Keywords ***
# ОСНОВНОЙ СЦЕНАРИЙ ТЕСТА, по проверке переходов на сайты из поиска из рекламы.
# Ключевые слова в сценарии теста, могут варьироваться.

Test run    # Общее ключевое слово, для всех тестов. Которое вызывается из листенера. Подключает в себе ключевое слово, конкретное для каждого теста.
    [Arguments]		${query}	${url}
    Поиск и переход на данный сайт с первой страницы google.com		${query}	${url}

Поиск и переход на данный сайт с первой страницы google.com
	[Arguments]		${query}	${url}
	Перейти в Google    headlesschrome
	# Перейти в Google    headlessfirefox
	# Перейти в Google    firefox
	sleep  2
	Set Window Size     1600	900
	Input Text		class=gLFyf	${query}
	Submit Form	    //form[@id="tsf"]
	#Wait Until Page Contains	${url}
	sleep  2
	${expected_result_go}=       Set Variable    ${url}
	${choose_link}=  Run Keyword And Return Status  Page Should Contain Element  xpath: //a[@href="${expected_result}/"]/div[@class="ads-visurl"]/span[contains(text(),'Реклама')]
    Run Keyword If    ${choose_link}  Перейти на сайт из рекламы    ${expected_result_go}  ELSE    Перейти на сайт по обычнной ссылке     ${expected_result_go}

    [Teardown]    Close Browser





