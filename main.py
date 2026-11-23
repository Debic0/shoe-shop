"""Точка входа приложения «Чудо Обувь»."""
import sys
from pathlib import Path

from PyQt5.QtGui import QIcon
from PyQt5.QtWidgets import QApplication

from app.main_window import MainWindow


def main():
    application = QApplication(sys.argv)
    application.setWindowIcon(QIcon(str(Path(__file__).parent / "resources" / "icon.ico")))
    window = MainWindow()
    window.resize(900, 600)
    window.show()
    sys.exit(application.exec_())


if __name__ == "__main__":
    main()
