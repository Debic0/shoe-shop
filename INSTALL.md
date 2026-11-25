# Установка и запуск ShoeStore

Приложение `ShoeStore.exe` — это только клиентская часть. **База данных внутрь EXE не упакована**:
PostgreSQL 14 запускается отдельно через Docker Compose, данные хранятся в именованном томе `db_data`.

## Требования

- Windows 10/11 (64 бита);
- Docker Desktop с Linux containers и Docker Compose v2, запущенный до начала установки;
- Python на компьютере не нужен.

## Состав комплекта

```
ShoeStore-release/
├── application/ShoeStore/        приложение (ShoeStore.exe и папка _internal)
├── deployment/                   compose.yaml, .env.example, database/, docker/db-check/
├── config.ini.example
├── README.md
└── INSTALL.md
```

Распакуйте архив в папку без кириллицы и пробелов, например `C:\ShoeStore-release`. Не переносите отдельно один EXE: нужна вся папка `application\ShoeStore`.

## Подготовка базы

1. Откройте PowerShell в папке `deployment`.
2. Создайте файл настроек и укажите свой локальный пароль (не публикуйте его):
   ```powershell
   copy .env.example .env
   ```
   Откройте `.env` и замените `POSTGRES_PASSWORD`.
3. Запустите инфраструктуру:
   ```powershell
   docker compose up -d
   docker compose ps
   ```
   Сервис `db` должен получить состояние `healthy`. Сервис `db-check` завершается со статусом `Exited (0)`: это нормально.
   Если порт `5433` занят (например, запущена рабочая копия проекта), измените `POSTGRES_HOST_PORT` в `.env` либо остановите другой экземпляр командой `docker compose stop` (не `down -v`).
4. **При новой пустой базе** импортируйте SQL (один раз):
   ```powershell
   docker compose cp database/shoe_store_docker.sql db:/tmp/shoe_store_docker.sql
   docker compose exec db psql -v ON_ERROR_STOP=1 -U shoe_user -d shoe_store -f /tmp/shoe_store_docker.sql
   ```
   Для уже заполненной базы повторный импорт не выполняйте: будет ошибка `relation already exists`.
   Скрипт `shoe_store_docker.sql` — это скрипт магазина без команд `DROP DATABASE`, `CREATE DATABASE` и `\connect`, так как база `shoe_store` уже создана контейнером.
5. Проверьте подключение:
   ```powershell
   docker compose run --rm db-check
   ```
   Ожидается строка `OK: база=shoe_store; таблиц=10`.

## Настройка приложения

1. Скопируйте `config.ini.example` из корня комплекта в `application\ShoeStore\config.ini` — **рядом с `ShoeStore.exe`**.
2. Откройте `config.ini` и укажите:
   ```ini
   [database]
   host = 127.0.0.1
   port = 5433
   name = shoe_store
   user = shoe_user
   password = ВАШ_ПАРОЛЬ_ИЗ_.env
   ```
   Если вы меняли `POSTGRES_HOST_PORT`, укажите здесь тот же порт.

## Запуск

Откройте `application\ShoeStore\ShoeStore.exe`. Должно открыться окно «Чудо Обувь» с каталогом товаров.

## Проверка

- окно открылось, каталог загрузился (в учебной базе 31 товар), изображения отображаются;
- проверка из консоли: `docker compose run --rm db-check` (в папке `deployment`).

## Остановка

```powershell
docker compose stop
```
Данные сохраняются в томе `db_data`. **Не используйте `docker compose down -v` без резервной копии**: команда удаляет том вместе с данными.

## Типичные проблемы

| Симптом | Что сделать |
|---|---|
| Окно «Ошибка подключения» | Проверьте `docker compose ps` (`db` — healthy), порт и пароль в `config.ini` |
| Окно «Не найден файл настроек» | `config.ini` должен лежать рядом с `ShoeStore.exe` |
| `port is already allocated` | Поменяйте `POSTGRES_HOST_PORT` в `.env` и `port` в `config.ini` |
| Приложение не запускается | Убедитесь, что скопирована вся папка `ShoeStore` вместе с `_internal` |
| SmartScreen предупреждает об издателе | Учебная сборка без подписи: «Подробнее» → «Выполнить в любом случае» |
