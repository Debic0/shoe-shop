"""Правила отображения наличия товара."""

LOW_STOCK_HIGHLIGHT_LIMIT = 3


def get_stock_label(total_pairs):
    return "много" if total_pairs > 5 else "мало"


def is_low_stock(total_pairs):
    return total_pairs <= LOW_STOCK_HIGHLIGHT_LIMIT
