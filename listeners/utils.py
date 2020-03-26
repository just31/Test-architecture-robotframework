import json
import logging

import requests

logger = logging.getLogger(__name__)

# Функционал отправляющий сообщения со скриншотом в слак от бота.
slack_token_bot = 'YOUR TOKEN'


def send_message(file, initial_comment):
    r = requests.post('https://slack.com/api/files.upload',
                      data={'token': slack_token_bot,
                            'channels': ['bot-automated-tests'], 'as_user': True,
                            'title': 'Page with error', 'initial_comment': initial_comment},
                      files={'file': open(file, 'rb')})


# Функция формирующая список сайтов, для прогона. По кол-ву number_sites.
def get_sites_list_from_doorway(number_sites):
    """Скачиваем список сайта с апи, если исключение, загружаем из файла.

    Url - https://staging.com/api-2c74fd/sites/?token=your_token

    Пример:
    site_type: "MULTI_PLACE" - мультиплощадочный сайт, REGULAR - обычный,
    is_responsive = true - сайт адаптивный,
    profit - сумма заказов, оплаченных по данному сайту в рублях
    """
    url = 'https://staging.com/api-2c74fd/sites/?token=your_token'
    filename = 'sites_list.json'
    try:
        response = requests.get(url).json()
        logger.info(f'Api response {response}')
        json.dump(response, open(filename, 'w'))
        logger.info('Success api request')
    except Exception as e:
        logger.error(f'Api request exception: {e}')
        response = []

    if len(response) == 0:
        try:
            response = json.load(open(filename, 'r'))
        except:
            pass

    site_list = []
    # Создаем список исключенных из проверки сайтов.
    expect_list_sites = ['site1.com', 'site2.com', 'site3.com', 'site4.com', 'site5.com']

    for key, site in enumerate(response, start=0):
        # Если host_name, из response не совпадает ни с одним из значений в списке исключений, добавлем его в site_list.
        for i, expect_host in enumerate(expect_list_sites):
            if expect_host != response[key]["host"]:
                if response[key]["event_place_type"] == "theatre" and response[key]["site_type"] == "REGULAR" \
                        and key <= number_sites:
                    if i == 0:
                        site_list.append(f"https://{site.get('host')}")

    # print(site_list.__len__())
    # print(site_list)

    return site_list
