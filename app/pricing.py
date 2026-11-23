"""Расчёт цены товара с учётом скидки."""
from datetime import date
from decimal import Decimal, ROUND_HALF_UP

DISCOUNT_RATE = Decimal("0.25")


def get_previous_month(calculation_date):
    if calculation_date.month == 1:
        return calculation_date.year - 1, 12
    return calculation_date.year, calculation_date.month - 1


def has_orders_in_previous_month(order_dates, calculation_date):
    previous = get_previous_month(calculation_date)
    return any((d.year, d.month) == previous for d in order_dates)


def calculate_price(base_price, order_dates, calculation_date=None):
    """Скидка 25% на товары без заказов в предыдущем календарном месяце."""
    calculation_date = calculation_date or date.today()
    price = Decimal(base_price)
    if has_orders_in_previous_month(order_dates, calculation_date):
        return price
    return (price * (1 - DISCOUNT_RATE)).quantize(Decimal("0.01"), ROUND_HALF_UP)
