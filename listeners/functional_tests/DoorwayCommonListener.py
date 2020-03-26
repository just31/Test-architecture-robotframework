import re
import logging

import requests
from robot.libraries.BuiltIn import BuiltIn

from robot.model.keyword import Keywords
from robot.model.testcase import TestCases
from robot.running.model import TestCase, Keyword

from urllib.parse import urlparse

# Импортируем все необходимые функции из нашего, вспомогательного модуля utils:
import sys
sys.path.append("listeners/")
from utils import *

logger = logging.getLogger(__name__)

# Формируем класс, для общего листенера, по различным группам сайтов.
class DoorwayCommonListener(object):
    ROBOT_LISTENER_API_VERSION = 3

    # В кнструкторе класса, формируем списки сайтов.
    def __init__(self, args):
        self.ROBOT_LIBRARY_LISTENER = self

        # Сохраняем переданные аргументы запуска, в переменную self.args. Для передаче ее в метод start_suite.
        self.args = args

        # Сохраняем значение переданное в аргументах запуска, в переменную self.type_sites.
        # Формируем списки сайтов, для различных видов проверок.
        # Кроме списка, для параллельного прогона. Его нужно сделать отдельно в методе листенера - start_suite.
        if args.find("single") != -1:
            self.type_sites = "single"
        elif args.find("multi") != -1:
            self.type_sites = "multi"
        elif args.find("consistent") != -1:
            self.type_sites = "consistent"
        else:
            self.type_sites = args

        # Если передан один сайт, для одиночного прогона, получаем его url.
        if self.type_sites == 'single':
            parametrs = args.split(':')
            self.sites = []
            self.sites.append(f'http://{parametrs[1]}')

        # Если передано несколько сайтов, для выборочного прогона, стараемся получить их url.
        if self.type_sites == 'multi':
            parametrs = args.split(':')
            self.sites = []
            for index, url in enumerate(parametrs, start=0):
                if index > 0:
                    self.sites.append(f'http://{url}')

        # Получаем кол-во сайтов для последовательного прогона. И вызываем по этому кол-ву функцию генерации списка сайтов.
        if self.type_sites == 'consistent':
            parametrs = args.split(':')
            number_sites = int(parametrs[1])
            self.sites = get_sites_list_from_doorway(number_sites)


    # Генерим список тест-кейсов в методе листенера start_suite, по каждому сайту из полученного списка сайтов.
    def start_suite(self, suite, result):

        # Сохраняем значение переданное в аргументах, для параллельного запуска, в переменную self.type_sites.
        if self.args.find("parallel") != -1:
            self.type_sites = "parallel"

        # Формируем общий список сайтов для параллельного прогона. Настраиваем его функционал.
        # Список может быть динамический, если пришел аргумент 'parallel' или статический, если пришел аргумент 'vse'.
        if self.type_sites == 'parallel' or self.type_sites == 'vse':

            # Получаем кол-во динамических сайтов для параллельного прогона.
            if self.type_sites == 'parallel':
                parametrs = self.args.split(':')
                number_sites = int(parametrs[1])
                self.sites = get_sites_list_from_doorway(number_sites)

            # Получаем номер тест сьюта из названия
            result = re.findall(r'\d+', suite.name)
            if not result:
                return
            test_suite_number = int(result[0])

            # Вызываем функцию возвращающую динамический список сайтов, по указанному кол-ву.
            site_list = get_sites_list_from_doorway(number_sites)

            # Берем из полученного списка сайтов, равную часть, с позиции, равной номеру тестсьюта
            count = len(site_list) // 10
            self.sites = site_list[test_suite_number * count: test_suite_number * count + count]


        # Сохраняем полученный список сайтов, в переменную sites.
        sites = self.sites

        # Создаем объект TestCase, в него будет записывать TestCase, parent - текущий TestSuite
        test_cases = TestCases(parent=suite)

        for site_url in sites:
            # Получаем переменные с описанием теста и текстом для тегов теста.
            test_name = BuiltIn().get_variable_value('${test_name}')
            test_tags = BuiltIn().get_variable_value('${test_tags}')

            # Создаем Keyword и записываем в список Keywords
            if test_name is None:
                pass
            else:
                ks = Keywords()
                ks.append(Keyword(name='Test run', args=(site_url,)))

                # Создаем TestCase с полученным именем теста и текстом для тегов теста. И добавляем к нему созданный Keyword.
                test_case = TestCase(name=f'Test {test_name} on {site_url}', tags=f'{test_tags}')
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
