"""Главное окно: каталог товаров."""
from pathlib import Path

from PyQt5.QtGui import QColor, QFont, QPixmap
from PyQt5.QtWidgets import (QFrame, QHBoxLayout, QLabel, QListWidget,
                             QListWidgetItem, QMessageBox, QVBoxLayout, QWidget)

from app import db
from app.pricing import calculate_price
from app.stock import get_stock_label, is_low_stock

RESOURCES = Path(__file__).resolve().parent.parent / "resources"
LOW_STOCK_COLOR = "#ff8080"
ADDITIONAL_BACKGROUND = "#D2F6E7"


class ProductCard(QFrame):
    def __init__(self, row, final_price, background):
        super().__init__()
        _, image_file, category, name, manufacturer, composition, price, total = row
        self.setStyleSheet(f"background-color: {background}; font-family: Calibri;")
        image_path = RESOURCES / "images" / (image_file or "")
        if not image_path.is_file():
            image_path = RESOURCES / "picture.png"
        picture = QLabel()
        picture.setPixmap(QPixmap(str(image_path)).scaled(110, 80))
        title = QLabel(f"{manufacturer} | {name}")
        title.setFont(QFont("Calibri", 11, QFont.Bold))
        details = QLabel(f"{category}\nКоличество: {get_stock_label(total)}\nСостав: {composition}")
        details.setWordWrap(True)
        price_label = QLabel(f"{final_price} ₽")
        price_label.setFont(QFont("Calibri", 14))
        text_column = QVBoxLayout()
        text_column.addWidget(title)
        text_column.addWidget(details)
        layout = QHBoxLayout(self)
        layout.addWidget(picture)
        layout.addLayout(text_column, 1)
        layout.addWidget(price_label)


class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Чудо Обувь — каталог моделей обуви")
        self.catalog_list = QListWidget()
        layout = QVBoxLayout(self)
        logo = QLabel()
        logo.setPixmap(QPixmap(str(RESOURCES / "logo.png")))
        layout.addWidget(logo)
        layout.addWidget(self.catalog_list)
        self.load_catalog()

    def load_catalog(self):
        try:
            connection = db.connect()
        except Exception as error:
            QMessageBox.critical(self, "Ошибка подключения",
                                 f"Не удалось подключиться к базе данных: {error}")
            return
        with connection:
            for row in db.fetch_catalog(connection):
                dates = db.fetch_order_dates(connection, row[0])
                final_price = calculate_price(row[6], dates)
                background = LOW_STOCK_COLOR if is_low_stock(row[7]) else "#FFFFFF"
                card = ProductCard(row, final_price, background)
                item = QListWidgetItem()
                item.setSizeHint(card.sizeHint())
                self.catalog_list.addItem(item)
                self.catalog_list.setItemWidget(item, card)
