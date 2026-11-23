"""Чтение параметров подключения к базе данных из config.ini."""
import configparser
from pathlib import Path

CONFIG_PATH = Path(__file__).resolve().parent.parent / "config.ini"


def load_database_settings():
    parser = configparser.ConfigParser()
    if not parser.read(CONFIG_PATH, encoding="utf-8"):
        raise FileNotFoundError(f"Не найден файл настроек {CONFIG_PATH}. Скопируйте config.ini.example в config.ini")
    section = parser["database"]
    return {
        "host": section["host"],
        "port": section["port"],
        "dbname": section["name"],
        "user": section["user"],
        "password": section["password"],
    }
