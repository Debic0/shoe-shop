"""Точка входа приложения «Чудо Обувь»."""
import sys

from PyQt5.QtGui import QIcon
from PyQt5.QtWidgets import QApplication

from app.main_window import MainWindow
from app.paths import bundle_dir


def main():
    application = QApplication(sys.argv)
    application.setWindowIcon(QIcon(str(bundle_dir() / "resources" / "icon.ico")))
    window = MainWindow()
    window.resize(900, 600)
    window.show()
    sys.exit(application.exec_())


if __name__ == "__main__":
    main()
