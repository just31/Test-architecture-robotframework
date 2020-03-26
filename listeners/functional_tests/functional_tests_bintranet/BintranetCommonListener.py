import re
import logging

import requests
from robot.libraries.BuiltIn import BuiltIn

from robot.model.keyword import Keywords
from robot.model.testcase import TestCases
from robot.running.model import TestCase, Keyword

from urllib.parse import urlparse

from requests.auth import HTTPBasicAuth

# Импортируем все необходимые функции из нашего, вспомогательного модуля utils:
import sys
sys.path.append("listeners/")
from utils import *

logger = logging.getLogger(__name__)

# Формируем класс, для общего листенера, по функциональным тестам Бинтранета.
class BintranetCommonListener(object):
    ROBOT_LISTENER_API_VERSION = 3

    # В конструкторе класса, можем принимать различные переменные, переданные в аргументах запуска 'args'.
    def __init__(self, args):
        self.ROBOT_LIBRARY_LISTENER = self

        # Если передан аргумент не равный main, присваиваем его переменной self.accaunt, с названием роли для авторизации.
        if args != "main":
            self.accaunt = args

            # Составляем тексты для проверки, по каждому аккаунту
            if self.accaunt == "tester_manager":
                self.text_accaunt = "Менеджер"
            if self.accaunt == "tester_logist":
                self.text_accaunt = "Логист"
            if self.accaunt == "tester_admin":
                self.text_accaunt = "Администратор"

            # Создаем переменную определяющую тип теста, как раздельный.
            self.type_check = "separate"
        else:
            # Создаем переменную определяющую тип теста, как общий.
            self.type_check = "all"

            self.accaunt = "common"
            self.text_accaunt = "Менеджер, Администратор, Логист"

    # Создаем тест-кейсы, для дев-бинтранета http://31.41.152.75/dev/. По полученному ${test_name}.
    def start_suite(self, suite, result):

        # Создаем переменную с общим паролем, для всех аккаунтов. Передаем ее в кейворд проверяющий логин в бинтранете, по разным ролям.
        BuiltIn().set_suite_variable("${password_for_all_accaunts}", "your_password")
        # Создаем переменную для разделения типов теста по проверке авторизации. Общая проверка или отдельная по разным ролям.
        BuiltIn().set_suite_variable("${type_check}", f'{self.type_check}')

        # Если в аргументах запуска было передано название роли отличное от 'common', то создам необходимые переменные, для данного типа теста.
        if self.accaunt != 'common':
            # Создаем переменную с название роли, для авторизации. Переданную в аргументах запуска.
            BuiltIn().set_suite_variable("${user_name}", f'{self.accaunt}')
            # Создаем переменную с текстом, для проверки по каждой из ролей.
            BuiltIn().set_suite_variable("${text_accaunt_value}", f'{self.text_accaunt}')

        site_url = "http://site.com/accounts/login/?next=/dev/"

        if 'Test Authorization' in suite.name:
            # Создаем объект TestCase, в него будет записывать TestCase, parent - текущий TestSuite
            test_cases = TestCases(parent=suite)

        # Получаем переменные с описанием теста и текстом для тегов теста.
        test_name = BuiltIn().get_variable_value('${test_name}')
        test_tags = BuiltIn().get_variable_value('${test_tags}')

        if 'Test Authorization' in suite.name:
            # Создаем Keyword и записываем в список Keywords
            if test_name is None:
                pass
            else:
                ks = Keywords()
                ks.append(Keyword(name='Test run', args=(site_url,)))

                # Создаем TestCase с полученным именем теста и текстом для тегов теста. И добавляем к нему созданный Keyword.
                test_case = TestCase(name=f'Test {test_name}: {self.text_accaunt}', tags=f'{test_tags}')
                test_case.keywords = ks

                # Добавляем TestCase к TestCases
                test_cases.append(test_case)

            # Добавлем созданный список TestCases к текущему TestSuite
            suite.tests.extend(test_cases)


    # Для тестов, в которых необходимо отправлять сообщения в слак:
    # Прослушиваем сообщения лога, получаем из файла ресурсов теста - словарь ${url_with_screen}, содержащий значения url, доп. текста и скриншота, для сообщения в слак.
    # Распарсиваем данный словарь, формируем по полученным из него значениям, текст для сообщения в слак.
    def log_message(self, msg):
        url_with_screen_and_text = BuiltIn().get_variable_value('${url_with_screen_and_text}')

        if url_with_screen_and_text is None:
            pass
        else:
            for index, test in enumerate(url_with_screen_and_text, start=0):
                test_url = url_with_screen_and_text[0]
                test_screen = url_with_screen_and_text[1]
                text_for_slack = url_with_screen_and_text[2]

            URL = test_url
            slashparts = URL.split('/')
            if slashparts.__len__() > 5:
                basename = '/'.join(slashparts[:4]) + '/'
            else:
                basename = f'https://{urlparse(URL).hostname}/'

            text_from_slack = f"{text_for_slack} {basename} \n Скриншот:"
            image_url = test_screen

            # Вызываем функцию, отправляющую сообщения в чат слака.
            send_message(image_url, text_from_slack)

            # Обнуляем переменную словаря, после отправления сообщения в слак.
            url_with_screen_and_text = None


    # Метод вызывающийся в конце всего тестового прогона.
    # Его можно использовать в тестах, в которых необходимо совершать какие либо действия, после прогона всего тестового набора.
    def close(self):
        pass
