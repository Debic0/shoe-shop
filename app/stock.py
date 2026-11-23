"""Правила отображения наличия товара."""

LOW_STOCK_HIGHLIGHT_LIMIT = 3


def get_stock_label(total_pairs):
    return "Много в наличии" if total_pairs > 5 else "Мало в наличии"


def is_low_stock(total_pairs):
    return total_pairs <= LOW_STOCK_HIGHLIGHT_LIMIT
