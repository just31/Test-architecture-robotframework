*** Settings ***
Documentation   Test order on the doorway sites.
Resource        ../resources/order.resource      # ключевые слова для тестирования заказа

*** Test Cases ***
Test order
    Order Tickets   https://crocus-city-hall.me
