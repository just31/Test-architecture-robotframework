# Установка


Установка зависимостей:

    pip install -r requirements.txt
    

Скачиваем драйвер для работы с браузером используя пакет webdrivermanager

    webdrivermanager chrome

# Запуск тестов
**Команды запусков по функциональным автотестам, с использованием основных листенеров:**    
    
    pabot --processes 10 --listener "listeners/functional_tests/DoorwayCommonListener.py;parallel:229" --listener allure_robotframework tests/functional_tests/test_NAME/test_NAME_parallel - 
    для параллельного запуска по списку сайтов. 
    
    robot --listener "listeners/functional_tests/DoorwayCommonListener.py;consistent:54" --listener allure_robotframework tests/functional_tests/test_NAME/test_NAME.robot - 
    для последовательного запуска по указанному числу сайтов.  
        
    robot --listener listeners/functional_tests/DoorwayCommonListener.py:preprod --listener allure_robotframework tests/functional_tests/test_NAME/test_NAME.robot - 
    по запуску на препрод-сайтах.
    
    robot --listener listeners/functional_tests/DoorwayCommonListener.py:staging --listener allure_robotframework tests/functional_tests/test_NAME/test_NAME.robot - 
    по запуску на сайтах стэйджинга.
    
    robot --listener "listeners/functional_tests/DoorwayCommonListener.py;single:site1.com" --listener allure_robotframework tests/functional_tests/test_NAME/test_NAME.robot - 
    по запуску на указанном, в аргументах запуска, сайте.
    
    robot --listener "listeners/functional_tests/DoorwayCommonListener.py;multi:site2.com:site3.com" --listener allure_robotframework tests/functional_tests/test_NAME/test_NAME.robot - 
    по запуску на указанных, в аргументах запуска, сайтах.
    
    robot --listener "listeners/for_runs_by_tags/DoorwayListenerByTags.py;preprod" --listener allure_robotframework -i Smoke -e Parallel tests - 
    общий не параллельный запуск нескольких тестов на сайтах препродов, имеющих один общий тег - Smoke.
    
    robot --listener listeners/functional_tests/DoorwayCommonListener.py:preprod --listener allure_robotframework -i No_parallel tests/functional_tests/tests_browsers - 
    кроссбраузерный не параллельный запуск выбранного теста, в firefox. 
    
    pabot --processes 10 --listener listeners/functional_tests/DoorwayCommonListener.py:parallel --listener allure_robotframework -i Parallel tests/functional_tests/tests_browsers - 
    кроссбраузерный параллельный запуск выбранного теста, в firefox.
    
    ## Вместо NAME, в командах запуска, нужно указать название функционального теста, который нужно запустить и название папки его содержащей. Например:
         robot --listener listeners/functional_tests/DoorwayCommonListener.py:preprod --listener allure_robotframework tests/functional_tests/test_acquiring/test_acquiring.robot - 
         запуск указанного автотеста, на сайтах препродов. 
    
    ### Запуск тестов объединенных одним тегом, может производиться не только по тегу 'Smoke', но и по любому, другому тегу. Который может быть указан в параметрах автотестов. 


**Запуск автотеста по авторизации:**

    robot --variable BROWSER:headlesschrome --listener "listeners/functional_tests/functional_tests_bintranet/BintranetCommonListener.py;tester_role" --listener allure_robotframework tests/functional_tests/tests_bintranet/test_authorization/test_authorization.robot - запуск автотеста по авторизации, под конкретным аккаунтом. Например, вместо tester_role, можно указать: tester_admin. Авторизация должна произойти под админом.

    robot --variable BROWSER:headlesschrome --listener "listeners/functional_tests/functional_tests_bintranet/BintranetCommonListener.py;main" --listener allure_robotframework tests/functional_tests/tests_bintranet/test_authorization/test_authorization.robot - запуск автотеста по  авторизации, в цикле под тремя аккаунтами: Менеджера, Логиста, Администратора.


**Запуск api тестов:**

    robot --listener "listeners/tests_api/ApiListener.py;staging.com" --listener allure_robotframework -e Dev tests/tests_api - запуск api-тестов со стейджинга.
    robot --listener "listeners/tests_api/ApiListener.py;preprod.com" --listener allure_robotframework -e Dev tests/tests_api - запуск api-тестов с препрода.
    robot --listener "listeners/tests_api/ApiListener.py;prod.com" --listener allure_robotframework -e Dev tests/tests_api - запуск api-тестов с прода.
    robot --listener "listeners/tests_api/ApiListener.py;dev.com" --listener allure_robotframework -i Dev tests/tests_api - запуск api-тестов на dev.
              
    
**Запуск автотеста по проверке сайтов, в рекламе:**

    robot --listener listeners/tests_advertising/AdvertisingListener.py --listener allure_robotframework tests/tests_advertising/test_doorway_advertising.robot
    
              
# Организация тестов
    - папка tests, содержит подпапки с различными видами автотестов: функциональные, api-тесты, нагрузочные, и т.д. 
    - папка listeners, содержит подпапки с листенерами, необходимыми для запусков по различным видам автотестов.
    - файл Elements.py в папке page_object, содержит общие переменные с локаторами(css-селекторами), необходимыми для различных автотестов.
    - папка resources, содержит подпапки с общими ключевами словами(keywords), для различных видов автотестов.	
    - файл selenium_library_helper.py в папке libraries, содержит вспомогательные ресурсы, для автотестов.
    Общая информация по новой структуре автотестов есть в файле - common_description.txt.


