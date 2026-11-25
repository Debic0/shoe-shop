# ShoeStore-release — комплект поставки «Чудо Обувь»

Учебное десктопное приложение «Магазин обуви» (Windows 10/11) и инфраструктура PostgreSQL в Docker.

| Путь | Назначение |
|---|---|
| `application/ShoeStore/` | Приложение в режиме onedir: `ShoeStore.exe` и сопутствующие файлы (`_internal`). Переносить нужно всю папку |
| `deployment/` | `compose.yaml`, `.env.example`, SQL-скрипт `database/shoe_store_docker.sql`, сервис проверки `docker/db-check` |
| `config.ini.example` | Образец настроек подключения (копируется в `application/ShoeStore/config.ini`) |
| `INSTALL.md` | Пошаговая инструкция установки и запуска |

База данных внутрь EXE не упакована: PostgreSQL запускается отдельно через Docker Compose.
Пароли и файлы `.env`, `config.ini` в комплект не входят: они создаются локально по инструкции.
