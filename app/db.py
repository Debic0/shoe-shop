"""Доступ к базе данных PostgreSQL."""
import psycopg2

from app.config import load_database_settings

CATALOG_QUERY = """
SELECT p.product_id, p.image_file, c.category_name, p.product_name,
       m.manufacturer_name, p.composition, p.price,
       COALESCE((SELECT SUM(s.quantity) FROM stock_item s
                 WHERE s.product_id = p.product_id), 0)
FROM product p
JOIN category c ON c.category_id = p.category_id
JOIN manufacturer m ON m.manufacturer_id = p.manufacturer_id
ORDER BY p.product_id
"""

ORDER_DATES_QUERY = """
SELECT o.order_date
FROM customer_order o
JOIN order_item i ON i.order_id = o.order_id
JOIN stock_item s ON s.stock_item_id = i.stock_item_id
WHERE s.product_id = %s
"""


def connect():
    return psycopg2.connect(**load_database_settings())


def fetch_catalog(connection):
    with connection.cursor() as cursor:
        cursor.execute(CATALOG_QUERY)
        return cursor.fetchall()


def fetch_order_dates(connection, product_id):
    with connection.cursor() as cursor:
        cursor.execute(ORDER_DATES_QUERY, (product_id,))
        return [row[0] for row in cursor.fetchall()]
