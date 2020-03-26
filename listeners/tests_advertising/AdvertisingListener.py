import logging
from urllib.parse import urlparse

from robot.model.keyword import Keywords
from robot.model.testcase import TestCases
from robot.running.model import TestCase, Keyword

from robot.libraries.BuiltIn import BuiltIn


logger = logging.getLogger(__name__)


# Формируем класс, для общего листенера, по различным группам сайтов.
class AdvertisingListener(object):
    ROBOT_LISTENER_API_VERSION = 3

    # В конструкторе класса, формируем список сайтов.
    def __init__(self):
        self.ROBOT_LIBRARY_LISTENER = self


    # Генерим список тест-кейсов в методе листенера start_suite, по каждому сайту из полученного списка сайтов.
    def start_suite(self, suite, result):
        """
        Генерируем тест кейсы. Для каждого сайта отдельный тест кейс, который запустит нужный кейворд с параметроми
        Создаем объект TestCases и наполняем его TestCase, в котором задаем нужный Keyword
        """
        site_list = ['https://arena.com', 'https://luzhniki.com',
                       'https://theatreallascala.com', 'https://crocus-city.me', 'https://bdt.com']
        # Создаем объект TestCase, в него будет записывать TestCase, parent - текущий TestSuite
        test_cases = TestCases(parent=suite)
        for site_url in site_list:
            site_host = site_url.split('//')

            # Получаем переменные с описанием теста и текстом для тегов теста.
            test_name = BuiltIn().get_variable_value('${test_name}')
            test_tags = BuiltIn().get_variable_value('${test_tags}')

            def switch_keyword(argument):
                switcher = {
                    "arena.com": "билеты в Арена",
                    "luzhniki.com": "Билеты на стадион «Лужники»",
                    "theatreallascala.com": "Билеты в Teatro alla Scala",
                    "crocus-city.me": "https://crocus-city.me",
                    "bdt.com": "https://bdt.com"
                }
                return switcher.get(argument, "Invalid host")

            if test_name is None:
                pass
            else:
                # Создаем Keyword и записываем в список Keywords
                ks = Keywords()
                ks.append(Keyword(name='Test run', args=(switch_keyword(site_host[1]), site_url)))

                # Создаем TestCase с нужным именем и добавлеям к нему созданный Keyword
                test_case = TestCase(name=f'{test_name} {urlparse(site_url).hostname} из рекламы в поиске',
                                     tags=f'{test_tags}')
                test_case.keywords = ks

                # Добавляем TestCase к TestCases
                test_cases.append(test_case)

                print(test_cases)

        # Добавляем созданный список TestCases к текущему TestSuite
        suite.tests.extend(test_cases)


    # Для тестов, в которых необходимо отправлять сообщения в слак:
    # Прослушиваем сообщения лога, получаем из файла ресурсов теста - словарь ${url_with_screen}, содержащий значения url и скриншот для сообщения в слак.
    # Распарсиваем данный словарь, формируем по полученным из него значениям, текст для сообщения в слак.
    def log_message(self, msg):
        pass


    # Метод вызывающийся в конце всего тестового прогона.
    # Его можно использовать в тестах, в которых необходимо совершать какие либо действия, после прогона всего тестового набора.
    def close(self):
        pass
