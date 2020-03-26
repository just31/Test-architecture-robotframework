from robot.libraries.BuiltIn import BuiltIn
from slackclient import SlackClient

import jenkinsapi
from jenkinsapi.jenkins import Jenkins

# Функционал отправляющий сообщения в слак от бота.
slack_client = SlackClient('YOUR TOKEN')


def send_message(msg):
    slack_client.api_call(
        "chat.postMessage",
        channel='bot-automated-tests',
        text=msg,
        username='bot_auto_test',
        icon_emoji=':robot_face:'
    )


# Функция формирующая текст с ошибками api, для отправления его в чат ботом.
def message_text_formation(index, msg, url_api):
    message_slack = f'{str(index)}. Адрес запроса: {url_api} \n Ошибка: {msg}'

    # Вызываем функцию, отправляющую сообщения в чат.
    send_message(message_slack)


# Класс для работы с тестами, тестовыми наборами.
class ApiListener(object):
    ROBOT_LISTENER_API_VERSION = 3

    # Инициализируем конструктор класса, с необходиммыми переменными, для всего тестового набора.
    def __init__(self, args):
        self.base_url = args
        self.index = 0
        self.msg_level = 'PASS'

    # Метод запускаюшщий прогон тест-сьюита по всем тестам api из папки test_api_robot.
    def start_suite(self, suite, result):
        suite.doc = 'АВТОМАТИЗАЦИЯ API-ТЕСТОВ НА ROBOT FRAMEWORK.'

        # Создаем переменную базового url, с которого будут отправляться запросы. Полученную из аргумента запуска.
        BuiltIn().set_suite_variable("${base_url}", f'https://{self.base_url}')

        # Information about tests only available via data at this point.
        for index, test in enumerate(suite.tests, start=0):
            # Получаем переменную базового url, с которого отправляются запросы.
            self.test_url = BuiltIn().get_variable_value('${base_url}')


    # Метод отлавливающий ошибки, в прохожении всех тестов. И формирующий текст для сообщения в слак, по ним.
    def log_message(self, msg):
        if msg.level == 'FAIL' and not msg.html:
            msg.html = True

            self.msg_level = msg.level

            # Получаем переменную с bad-запросом из ключевых слов robotframework, из-за которого не прошел тест.
            bad_request = BuiltIn().get_variable_value('${REQUEST_URL}')
            # Склеиваем ее с базовым url, чтобы получить полный путь api-запроса.
            full_url = self.test_url + bad_request

            # Добавляем индекс к каждому упавшему запросу.
            self.index = self.index + 1

            # Вызываем функцию, формирующую текст для слака.
            message_text_formation(self.index, msg.message, full_url)

    # Метод вызывающийся в конце всего тестового прогона. Если в тестах есть упавшие тесты, то в конце всего прогона
    # будет отправлена в слак, ссылка на allure-отчет.
    def close(self):
        if self.msg_level == 'FAIL':

            # Работаем с api Jenkins, получаем номер последней сборки по api-тестам.
            J = Jenkins("http://site.com:8080", "your_name", "your_passw")
            job = J.get_job("api_tests")
            build_last = job.get_last_build()
            build_last_str = str(build_last)
            build_last_str_replace = build_last_str.replace("api_tests #", "")
            build_last_int = int(build_last_str_replace)

            # Заполняем переменную с сообщением, для отправления ее в слак.
            self.url_allure = f"Ссылка на allure-отчет в Дженкинсе - http://site.com:8080/job/doorway_api_tests/{build_last_int}/allure/."
            #self.url_allure = "\n\n Ссылка на общий allure-отчет http://site.com:8080/job/doorway_api_tests/allure/. "

            # Вызываем функцию, отправляющую сообщения в чат.
            send_message(self.url_allure)
