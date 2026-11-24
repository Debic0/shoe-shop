# ShoeShop — система оформления заказов обуви

Учебный проект (демонстрационный экзамен 09.02.07): десктопное приложение «Чудо Обувь»
для просмотра каталога обуви и оформления заказов.

## Возможности

- просмотр каталога моделей обуви с ценой, скидкой и наличием;
- подсветка товаров с малым остатком (3 пары и менее);
- скидка 25% на товары, по которым не было заказов в предыдущем календарном месяце;
- сортировка, фильтрация и поиск товаров, оформление заказов, управление заказами (в разработке).

## Требования

- Python 3.10
- PostgreSQL 14
- библиотеки из файла requirements.txt

## Установка и запуск

1. Клонировать репозиторий: `git clone <адрес репозитория>`
2. Создать окружение и установить зависимости:
   `python -m venv venv`, `venv\Scripts\activate`, `pip install -r requirements.txt`
3. Создать базу данных и загрузить скрипт: `psql -U postgres -f database/shoe_store.sql`
4. Скопировать `config.ini.example` в `config.ini` и указать параметры подключения.
5. Запустить приложение: `python main.py`

## Структура репозитория

- `app/` — модули приложения
- `resources/` — изображения, логотип, иконка
- `database/` — скрипт базы данных
- `docs/` — ER-диаграмма

## ER-диаграмма базы данных

Диаграмма находится в файле `docs/er_diagram.pdf`. Основные таблицы: `product`, `stock_item`,
`size`, `category`, `subcategory`, `manufacturer`, `app_user`, `role`, `customer_order`, `order_item`.
Остаток хранится по сочетанию «модель + размер» (`stock_item`), заказ — в `customer_order` и `order_item`.

## Запуск PostgreSQL через Docker Compose

Предварительные требования: Docker Desktop (Linux containers), Compose v2.

1. Создать файл настроек и указать свой локальный пароль (файл `.env` в Git не попадает):
   `copy .env.example .env`
2. Собрать образ и запустить сервисы: `docker compose up --build -d`
3. Проверить состояние: `docker compose ps` (сервис `db` — healthy, `db-check` — Exited (0)).
4. Импортировать базу (один раз):
   `docker compose cp database/shoe_store_docker.sql db:/tmp/shoe_store_docker.sql`
   `docker compose exec db psql -v ON_ERROR_STOP=1 -U shoe_user -d shoe_store -f /tmp/shoe_store_docker.sql`
5. Проверить подключение из контейнера: `docker compose run --rm db-check`
6. Для приложения в `config.ini` указать `host = localhost`, `port = 5433` и пароль из `.env`.
7. Остановка: `docker compose stop`, повторный запуск: `docker compose start`.
   Команду `docker compose down -v` не выполнять.

Контейнер `db-check` обращается к базе по адресу `db:5432`, приложение на Windows — по `localhost:5433`.

## Постоянное хранение и сети

**Том.** Данные PostgreSQL хранятся в именованном томе `db_data` (в Docker он называется
`<проект>_db_data`, например `shoe-shop_db_data`) и сохраняются при пересоздании контейнера `db`.
Том не заменяет резервное копирование.

**Резервная копия** (каталог `backups/` исключён из Git):

```
mkdir backups
docker compose exec db pg_dump -U shoe_user -d shoe_store -f /tmp/shoe_store_before_volume.sql
docker compose cp db:/tmp/shoe_store_before_volume.sql ./backups/shoe_store_before_volume.sql
```

**Восстановление** в новую пустую базу:

```
docker compose cp ./backups/shoe_store_before_volume.sql db:/tmp/restore.sql
docker compose exec db psql -v ON_ERROR_STOP=1 -U shoe_user -d shoe_store -f /tmp/restore.sql
```

**Запуск и пересоздание:**

```
docker compose up --build -d
docker compose up -d --force-recreate db
docker compose ps
```

**Сеть и адреса.** Сервисы `db` и `db-check` работают в сети `shoe-backend`. Контейнер `db-check`
подключается к `db:5432`, приложение на Windows — к `127.0.0.1:5433` (порт опубликован только на
локальном интерфейсе).

**Предупреждение.** Команды `docker compose down -v` и `docker volume prune` удаляют тома и данные БД.
Не выполняйте их без резервной копии.

## Автор

Никонов Александр, группа ПКС-33
