"""Пути к файлам приложения: работают и при запуске из исходников, и из EXE (PyInstaller)."""
import sys
from pathlib import Path


def is_frozen():
    """True, если приложение запущено из собранного PyInstaller-пакета."""
    return getattr(sys, "frozen", False)


def bundle_dir():
    """Папка с упакованными ресурсами (resources/). В EXE это служебная папка _internal."""
    if is_frozen():
        return Path(getattr(sys, "_MEIPASS", Path(sys.executable).resolve().parent))
    return Path(__file__).resolve().parent.parent


def app_dir():
    """Папка, где лежит запускаемый файл. Рядом с ShoeStore.exe ожидается config.ini."""
    if is_frozen():
        return Path(sys.executable).resolve().parent
    return Path(__file__).resolve().parent.parent
