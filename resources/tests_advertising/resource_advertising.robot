*** Settings ***
Library			SeleniumLibrary


*** Keywords ***
#---ОБЩИЕ КЛЮЧЕВЫЕ СЛОВА, ОДИНАКОВЫЕ ДЛЯ РАЗЛИЧНЫХ ТЕСТОВ, В ПРОВЕРКАХ РЕКЛАМЫ В ПОИСКЕ.----#

Перейти в Google
    [Arguments]      ${type_browsers}
	Open Browser	https://google.com      ${type_browsers}
	Set Window Size     1920	1080

Перейти на сайт из рекламы
    [Arguments]		${expected_result_go}
    Click Element   xpath: //a[@href="${expected_result_go}/"]/div[@class="ads-visurl"]/span[contains(text(),'Реклама')]
    Sleep    2

Перейти на сайт по обычнной ссылке
    [Arguments]		${expected_result_go}
    Click Element   xpath: //a[@href="${expected_result_go}/"]
    Sleep    2