-- База данных «Чудо Обувь» (PostgreSQL 14): структура и данные.
-- Вариант для импорта в Docker: БД shoe_store уже создана контейнером (POSTGRES_DB),
-- поэтому команды DROP DATABASE, CREATE DATABASE и \connect из исходного скрипта убраны.
-- Запуск: docker compose exec db psql -v ON_ERROR_STOP=1 -U shoe_user -d shoe_store -f /tmp/shoe_store_docker.sql

CREATE TABLE category     (category_id     SERIAL PRIMARY KEY, category_name     VARCHAR(100) NOT NULL UNIQUE);
CREATE TABLE subcategory  (subcategory_id  SERIAL PRIMARY KEY, subcategory_name  VARCHAR(100) NOT NULL UNIQUE);
CREATE TABLE manufacturer (manufacturer_id SERIAL PRIMARY KEY, manufacturer_name VARCHAR(150) NOT NULL UNIQUE);
CREATE TABLE role         (role_id         SERIAL PRIMARY KEY, role_name         VARCHAR(50)  NOT NULL UNIQUE);
CREATE TABLE size         (size_id         SERIAL PRIMARY KEY, size_value        NUMERIC(3,1) NOT NULL UNIQUE);

CREATE TABLE app_user (
    user_id     SERIAL PRIMARY KEY,
    last_name   VARCHAR(60) NOT NULL,
    first_name  VARCHAR(60) NOT NULL,
    middle_name VARCHAR(60),
    login       VARCHAR(50) NOT NULL UNIQUE,
    role_id     INT NOT NULL REFERENCES role(role_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE product (
    product_id      SERIAL PRIMARY KEY,
    category_id     INT NOT NULL REFERENCES category(category_id)         ON UPDATE CASCADE ON DELETE RESTRICT,
    subcategory_id  INT NOT NULL REFERENCES subcategory(subcategory_id)   ON UPDATE CASCADE ON DELETE RESTRICT,
    manufacturer_id INT NOT NULL REFERENCES manufacturer(manufacturer_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    product_name    VARCHAR(250) NOT NULL,
    image_file      VARCHAR(100),
    description     TEXT,
    composition     TEXT,
    price           NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    UNIQUE (product_name, manufacturer_id)
);

CREATE TABLE stock_item (
    stock_item_id SERIAL PRIMARY KEY,
    product_id    INT NOT NULL REFERENCES product(product_id) ON UPDATE CASCADE ON DELETE CASCADE,
    size_id       INT NOT NULL REFERENCES size(size_id)       ON UPDATE CASCADE ON DELETE RESTRICT,
    quantity      INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    UNIQUE (product_id, size_id)
);

CREATE TABLE customer_order (
    order_id   SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    user_id    INT NOT NULL REFERENCES app_user(user_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE order_item (
    order_item_id SERIAL PRIMARY KEY,
    order_id      INT NOT NULL REFERENCES customer_order(order_id)  ON UPDATE CASCADE ON DELETE CASCADE,
    stock_item_id INT NOT NULL REFERENCES stock_item(stock_item_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    quantity      INT NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    UNIQUE (order_id, stock_item_id)
);


INSERT INTO category (category_name) VALUES ('Детская обувь');
INSERT INTO category (category_name) VALUES ('Женская обувь');
INSERT INTO category (category_name) VALUES ('Мужская обувь');
INSERT INTO subcategory (subcategory_name) VALUES ('Босоножки');
INSERT INTO subcategory (subcategory_name) VALUES ('Ботинки');
INSERT INTO subcategory (subcategory_name) VALUES ('Кроссовки');
INSERT INTO subcategory (subcategory_name) VALUES ('Сапоги');
INSERT INTO subcategory (subcategory_name) VALUES ('Туфли');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Азимут');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Барбари');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Берестов');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Весна');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Здоровый шаг');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Карапуз');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Кожевенные традиции');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Лапушка');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Маленький франт');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Малыш-Спорт');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Модный силуэт');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Северята');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Стиль и комфорт');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Твой комфорт');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Топ-Топ');
INSERT INTO manufacturer (manufacturer_name) VALUES ('Тёплые ножки');
INSERT INTO role (role_name) VALUES ('Авторизованный пользователь');
INSERT INTO role (role_name) VALUES ('Администратор');
INSERT INTO role (role_name) VALUES ('Менеджер');
INSERT INTO size (size_value) VALUES (18.0);
INSERT INTO size (size_value) VALUES (19.0);
INSERT INTO size (size_value) VALUES (20.0);
INSERT INTO size (size_value) VALUES (21.0);
INSERT INTO size (size_value) VALUES (22.0);
INSERT INTO size (size_value) VALUES (23.0);
INSERT INTO size (size_value) VALUES (24.0);
INSERT INTO size (size_value) VALUES (25.0);
INSERT INTO size (size_value) VALUES (26.0);
INSERT INTO size (size_value) VALUES (27.0);
INSERT INTO size (size_value) VALUES (28.0);
INSERT INTO size (size_value) VALUES (29.0);
INSERT INTO size (size_value) VALUES (30.0);
INSERT INTO size (size_value) VALUES (31.0);
INSERT INTO size (size_value) VALUES (32.0);
INSERT INTO size (size_value) VALUES (33.0);
INSERT INTO size (size_value) VALUES (34.0);
INSERT INTO size (size_value) VALUES (35.0);
INSERT INTO size (size_value) VALUES (36.0);
INSERT INTO size (size_value) VALUES (36.5);
INSERT INTO size (size_value) VALUES (37.0);
INSERT INTO size (size_value) VALUES (37.5);
INSERT INTO size (size_value) VALUES (38.0);
INSERT INTO size (size_value) VALUES (38.5);
INSERT INTO size (size_value) VALUES (39.0);
INSERT INTO size (size_value) VALUES (39.5);
INSERT INTO size (size_value) VALUES (40.0);
INSERT INTO size (size_value) VALUES (40.5);
INSERT INTO size (size_value) VALUES (41.0);
INSERT INTO size (size_value) VALUES (41.5);
INSERT INTO size (size_value) VALUES (42.0);
INSERT INTO size (size_value) VALUES (42.5);
INSERT INTO size (size_value) VALUES (43.0);
INSERT INTO size (size_value) VALUES (44.0);
INSERT INTO size (size_value) VALUES (45.0);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Иванов', 'Иван', 'Сергеевич', 'isivanov', 2);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Петров', 'Пётр', 'Алексеевич', 'papetrov', 3);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Сидорова', 'Анна', 'Дмитриевна', 'asidorova', 1);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Кузнецова', 'Екатерина', 'Андреевна', 'ekuznetsova', 3);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Смирнов', 'Дмитрий', 'Владимирович', 'dsmirnov', 1);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Попов', 'Алексей', 'Николаевич', 'apopov', 2);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Васильева', 'Ольга', 'Игоревна', 'ovasileva', 1);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Соколов', 'Павел', 'Викторович', 'psokolov', 3);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Михайлова', 'Татьяна', 'Юрьевна', 'tmikhailova', 1);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Новикова', 'Наталья', 'Сергеевна', 'nnovikova', 3);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Фёдоров', 'Андрей', 'Максимович', 'afedorov', 2);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Морозов', 'Сергей', 'Павлович', 'smorozov', 1);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Волкова', 'Юлия', 'Александровна', 'jvolkova', 3);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Алексеев', 'Артём', 'Евгеньевич', 'aalekseev', 1);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Лебедева', 'Ирина', 'Владимировна', 'ilebedeva', 1);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Егоров', 'Никита', 'Денисович', 'negorov', 3);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Павлова', 'Елена', 'Петровна', 'epavlova', 1);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Козлов', 'Роман', 'Олегович', 'rkozlov', 2);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Степанова', 'Виктория', 'Романовна', 'vstepanova', 3);
INSERT INTO app_user (last_name, first_name, middle_name, login, role_id) VALUES ('Николаев', 'Владимир', 'Иванович', 'vnikolaev', 1);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (1, 3, 10, 'Кроссовки детские «Звёздочка» экокожа', 'IMG_KS_195217.png', 'Кроссовки детские «Звёздочка» экокожа. Производитель: ООО «Малыш-Спорт», г. Смоленск', 'Верх — экокожа (полиуретан на хлопковой основе), подкладка — хлопок 100%, подошва — ПВХ', 2190);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (1, 3, 15, 'Кроссовки детские «Гонщик» экокожа', 'IMG_KS_195213.png', 'Кроссовки детские «Гонщик» экокожа. Производитель: Фабрика «Топ-Топ», г. Киров', 'Верх — экокожа (микрофибра), подкладка — текстиль сетчатый (полиэстер), подошва — термопластичная резина (ТЭП)', 2490);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (1, 3, 8, 'Кроссовки детские «Радуга» экокожа перфорированная', 'IMG_KS_195222.png', 'Кроссовки детские «Радуга» экокожа перфорированная. Производитель: ИП Смирнова Л.В. (бренд «Лапушка»), г. Вологда', 'Верх — экокожа перфорированная, вставки — нейлон, стелька — ортопедическая с латексной подушкой, подошва — ЭВА', 1990);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (1, 4, 16, 'Сапожки детские «Снежинка» зимние на меху', 'IMG_KB_185501.png', 'Сапожки детские «Снежинка» зимние на меху. Производитель: ООО «Тёплые ножки», г. Новосибирск', 'Верх — экокожа морозостойкая, утеплитель — искусственный мех (акрил 70%, полиэстер 30%), подкладка — флис, подошва — термоэластопласт (ТЭП)', 3490);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (1, 4, 12, 'Сапожки детские «Медвежонок» демисезонные непромокаемые', 'IMG_KB_164816.png', 'Сапожки детские «Медвежонок» демисезонные непромокаемые. Производитель: Компания «Северята», г. Архангельск', 'Верх — плащёвая ткань с водоотталкивающей пропиткой (полиэстер 100%), отделка — экокожа, подкладка — микрофибра, мембрана — AirTex, подошва — резина', 3190);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (1, 4, 4, 'Сапожки детские «Принцесса» кожаные', 'IMG_KB_164811.png', 'Сапожки детские «Принцесса» кожаные. Производитель: Мастерская «Весна», г. Тула', 'Верх — натуральная кожа (КРС), подкладка — шерсть натуральная (70%), байка (30%), стелька — войлочная, подошва — полиуретан', 4290);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (1, 1, 5, 'Сандалии детские «Пчёлка» ортопедические летние', 'IMG_KSd_195207.png', 'Сандалии детские «Пчёлка» ортопедические летние. Производитель: ООО «Здоровый шаг», г. Воронеж', 'Верх — нубук натуральный, подкладка — кожа растительного дубления, стелька — анатомическая с супинатором (латекс + пробка), подошва — каучук', 2790);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (1, 1, 6, 'Сандалии детские «Морячок» текстильные с фиксатором', 'IMG_KSd_185508.png', 'Сандалии детские «Морячок» текстильные с фиксатором. Производитель: ИП Кузнецов А.Д. (бренд «Карапуз»), г. Краснодар', 'Верх — джинсовая ткань (хлопок 100%), окантовка — искусственная кожа, подкладка — хлопок, подошва — ЭВА лёгкая', 1690);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (1, 5, 9, 'Туфли детские «Бантик» лаковые праздничные', 'IMG_KSho_185512.png', 'Туфли детские «Бантик» лаковые праздничные. Производитель: Дом обуви «Маленький франт», г. Москва', 'Верх — искусственная лаковая кожа (ПВХ), носок усиленный — термопластичный полиуретан, подкладка — кожа искусственная дышащая, стелька — анатомическая с амортизацией, подошва — полиуретан', 2390);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (2, 4, 2, 'Сапоги зимние натуральная кожа', 'IMG_WB_170905.png', 'Сапоги женские зимние, нескользящая, устойчивая подошва, натуральный мех. Производитель: Дом обуви «Барбари», г. Новороссийск', 'Верх — натуральная кожа, подкладка — евромех, натуральный мех, текстильный утеплитель, подошва — резина', 25000);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (2, 4, 2, 'Сапоги осенние натуральная кожа', 'IMG_WB_170859.png', 'Сапоги женские демисезонные из высококачественной натуральной кожи. Производитель: Дом обуви «Барбари», г. Новороссийск', 'Верх — натуральная кожа, подкладка — текстильный утеплитель, стелька — текстиль, подошва — ТПР', 15000);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (2, 4, 14, 'Сапоги трубы демисезонные замшевые', 'IMG_WB_170906.png', 'Сапоги женские демисезонные замшевые. Производитель: ОАО «Твой комфорт», г. Ярославль', 'Верх — натуральная замша, утепленные, тракторная подошва, стелька — байка, подошва — резина', 17000);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (2, 1, 13, 'Босоножки «Песчаный берег» коричневые', 'IMG_WSd_174332.png', 'Коричневая кожаная модель с открытым носком, боковой пряжкой и закрытым каблуком. Производитель: ИП «Стиль и комфорт», г. Санкт-Петербург', 'Верх — 100% козья кожа, подкладка — 100% кожа; подошва: 100% кожа', 7500);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (2, 1, 7, 'Женские босоножки «Черный кофе» со скульптурным каблуком', 'IMG_WSd_185156.png', 'Открытый носок и ремешок со сборной пряжкой, низкий каблук и резиновая подошва гарантируют комфорт. Производитель: ЗАО «Кожевенные традиции», г. Вятка', 'Верх — кожа собственного производств, подкладка — кожа; подошва: резина', 5600);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (2, 1, 11, 'Босоножки женские «Летний бриз»', 'IMG_WSd_185551.png', 'Босоножки женские кожаные белые, регулируемый ремешок, закрытый каблук и кожаная подошва. Производитель: ООО «Модный силуэт», г. Кострома', 'Верх — натуральная кожа, подкладка — натуральная кожа, подошва — кожа', 7130);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (2, 5, 11, 'Демисезонные туфли натуральная кожа', 'IMG_WSho_174409.png', 'Комфортные лаконичные лодочки, классический дизайна с современными акцентами. Производитель: ООО «Модный силуэт», г. Кострома', 'Верх — натуральная овечья кожа, подкладка и стелька — натуральная овечья кожа, подошва — резина', 12340);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (2, 5, 7, 'Туфли женские натуральная кожа с металлическими вставками', 'IMG_WSho_185202.png', 'Стильные туфли для весеннего и летнего сезона. Производитель: ЗАО «Кожевенные традиции», г. Вятка', 'Верх — натуральная телячьей кожа, металлическая пряжка, подкладка и стелька— натуральная овечья кожа, подошва — резина', 7757);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (2, 5, 13, 'Туфли классические лодочки натуральная кожа', 'IMG_WSho_185545.png', 'Модель из натуральной кожи, классический острый носок и изящная шпилька. Производитель: ИП «Стиль и комфорт», г. Санкт-Петербург', 'Верх — натуральная кожа, подкладка и стелька — натуральная кожа, подошва — тунит', 7550);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (2, 3, 15, 'Кроссовки белые с оранжевым и красным', 'IMG_WS_174110.png', 'Многослойный верх из кожи и текстиля. Производитель: Фабрика «Топ-Топ», г. Киров', 'Верх — 70% кожа, 30% текстиль, подкладка — текстиль, подошва — резина', 9450);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (2, 3, 15, 'Кроссовки летние кожаные', 'IMG_WS_185528.png', 'Уверенность на каждом шагу. Материал обеспечивает долговечность и комфорт при носке. Производитель: Фабрика «Топ-Топ», г. Киров', 'Верх — 87% кожа, 11% текстиль, 2% синтетика; подкладка: 100% текстиль; подошва: резина, пластик', 8565);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (2, 3, 13, 'Кроссовки кожаные', 'IMG_WS_185535.png', 'Кроссовки женские из натуральной кожи. Производитель: ИП «Стиль и комфорт», г. Санкт-Петербург', 'Верх — натуральная кожа, подкладка — кожа, подошва — полиуретан', 8765);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (2, 3, 13, 'Кроссовки «Стиль и комфорт»', 'IMG_WS_185538.png', 'Кроссовки женские из натуральной кожи и синтетических материалов, сетчатые вставки. Производитель: ИП «Стиль и комфорт», г. Санкт-Петербург', 'Верх — 70% кожа, 20% полиамид, 10% полиуретан; подкладка — текстиль, подошва — ТПУ', 7795);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (3, 3, 1, 'Кроссовки для бега «Драйв»', 'IMG_MS_185531.png', 'Сочетание стиля, комфорта и современных технологий. Производитель: Фабрика «Азимут», г. Санкт-Петербург', 'Верх — сетка, подкладка — текстиль, подошва — резина', 6550);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (3, 3, 1, 'Кроссовки «Азимут Бег»', 'IMG_MS_185532.png', 'Универсальный выбор для повседневного использования. Производитель: Фабрика «Азимут», г. Санкт-Петербург', 'Верх — 6% кожа, 29% текстиль, 15% полимерные материалы; подкладка — 100% текстиль; подошва — полимерные материалы, резина', 7890);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (3, 3, 15, 'Кроссовки', 'IMG_MS_185533.png', 'Кроссовки для мужчин, идеальное сочетание стиля и комфорта. Производитель: Фабрика «Топ-Топ», г. Киров', 'Верх — 56% кожа, 29% текстиль, 15% полимерные материалы; подкладка — 100% текстиль; подошва — полимерные материалы, резина', 9567);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (3, 5, 2, 'Черные туфли в классическом стиле — база для деловых образов', 'IMG_MSho_190514.png', 'Модель выполнена из натуральной кожи, на резиновой подошве. Производитель: Дом обуви «Барбари», г. Новороссийск', 'Верх — натуральная кожа, подкладка — текстиль, стелька — натуральная кожа, подошва — резина', 24569);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (3, 5, 3, 'Туфли мужские светлые классика демисезонные', 'IMG_MSho_190518.png', 'Туфли на низком каблуке кожаные', 'Верх — натуральная кожа, подкладка — текстиль, стелька — натуральная кожа, подошва — ТЭП', 10155);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (3, 5, 3, 'Туфли из натуральной кожи', 'IMG_MSho_191612.png', 'Модель выполнена из натуральной кожи, на резиновой подошве, поддеживает классический и деловой стиль образов. Производитель: Дом обуви «Берестов», г. Москва', 'Верх — натуральная кожа, подкладка — натуральная кожа, стелька — натуральная кожа, подошва — резина', 25625);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (3, 2, 2, 'Ботинки мужские демисезонные', 'IMG_MB_174349.png', 'Ботинки из натуральной кожи темно-коричневого и черного цвета на шнурках. Производитель: Дом обуви «Берестов», г. Москва', 'Верх — натуральная кожа, подкладка — текстиль, подошва — искусственный материал', 21500);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (3, 2, 7, 'Ботинки черные из натуральной кожи', 'IMG_MB_191200.png', 'Ботинки представляют баланс традиций и современности. Выполнены из натуральной кожи насыщенного черного цвета. Производитель: ЗАО «Кожевенные традиции», г. Вятка', 'Верх — натуральная кожа, подкладка — ворсин, стелька — ворсин, подошва — тунит', 14567);
INSERT INTO product (category_id, subcategory_id, manufacturer_id, product_name, image_file, description, composition, price) VALUES (3, 2, 2, 'Ботинки зимние классические', 'IMG_MB_191205.png', 'Выбор на каждый день — натуральная кожа, натуральный мех. Производитель: Дом обуви «Барбари», г. Новороссийск', 'Верх — натуральная кожа, подкладка — натуральный мех, стелька — натуральный мех, подошва — ТЭП', 15670);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (1, 3, 20);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (1, 4, 20);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (1, 5, 20);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (1, 6, 20);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (1, 7, 20);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (1, 8, 20);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (2, 16, 2);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (2, 17, 2);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (3, 2, 30);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (3, 3, 30);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (4, 2, 15);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (4, 3, 15);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (5, 4, 5);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (5, 5, 5);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (5, 6, 5);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (6, 1, 4);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (6, 2, 4);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (6, 3, 4);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (7, 4, 4);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (7, 5, 4);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (7, 6, 4);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (7, 7, 4);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (8, 10, 7);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (8, 11, 7);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (8, 12, 7);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (8, 13, 7);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (9, 1, 7);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (9, 2, 7);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (9, 3, 7);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (10, 19, 12);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (10, 21, 12);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (11, 25, 2);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (11, 27, 2);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (12, 21, 5);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (12, 25, 5);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (12, 27, 5);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (13, 19, 10);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (13, 21, 10);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (13, 23, 10);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (13, 25, 10);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (13, 27, 10);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (14, 18, 3);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (15, 21, 23);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (15, 25, 23);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (15, 27, 23);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (16, 19, 25);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (16, 21, 25);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (16, 23, 25);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (17, 19, 4);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (17, 23, 4);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (17, 25, 4);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (17, 27, 4);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (18, 18, 9);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (18, 23, 9);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (19, 18, 2);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (19, 19, 2);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (20, 21, 5);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (20, 22, 5);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (20, 23, 5);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (20, 24, 5);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (21, 18, 16);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (21, 19, 16);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (21, 23, 16);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (21, 25, 16);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (22, 18, 3);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (22, 23, 3);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (23, 30, 18);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (23, 31, 18);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (23, 32, 18);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (23, 33, 18);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (24, 23, 50);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (24, 24, 50);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (24, 25, 50);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (24, 26, 50);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (24, 27, 50);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (24, 29, 50);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (25, 29, 3);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (25, 31, 3);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (25, 34, 3);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (26, 27, 23);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (26, 29, 23);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (26, 33, 23);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (27, 31, 15);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (27, 33, 15);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (27, 34, 15);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (28, 34, 3);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (29, 29, 1);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (29, 31, 1);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (30, 31, 20);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (30, 33, 20);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (31, 29, 30);
INSERT INTO stock_item (product_id, size_id, quantity) VALUES (31, 31, 30);
INSERT INTO customer_order (order_id, order_date, user_id) VALUES (1, '2026-04-02', 3);
INSERT INTO customer_order (order_id, order_date, user_id) VALUES (2, '2026-04-05', 17);
INSERT INTO customer_order (order_id, order_date, user_id) VALUES (3, '2026-04-08', 7);
INSERT INTO customer_order (order_id, order_date, user_id) VALUES (4, '2026-04-12', 15);
INSERT INTO customer_order (order_id, order_date, user_id) VALUES (5, '2026-04-18', 12);
INSERT INTO customer_order (order_id, order_date, user_id) VALUES (6, '2026-04-22', 9);
INSERT INTO customer_order (order_id, order_date, user_id) VALUES (7, '2026-04-25', 14);
INSERT INTO customer_order (order_id, order_date, user_id) VALUES (8, '2026-04-28', 20);
INSERT INTO customer_order (order_id, order_date, user_id) VALUES (9, '2026-05-05', 5);
INSERT INTO customer_order (order_id, order_date, user_id) VALUES (10, '2026-05-08', 17);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (1, 1, 1, 2190);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (1, 20, 1, 2790);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (2, 30, 1, 25000);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (2, 39, 1, 7500);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (3, 34, 1, 17000);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (3, 57, 1, 8565);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (3, 65, 1, 7795);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (4, 50, 1, 7757);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (4, 48, 1, 12340);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (4, 44, 1, 7130);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (4, 62, 1, 8765);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (4, 32, 1, 15000);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (5, 77, 1, 9567);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (5, 87, 1, 21500);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (5, 73, 1, 7890);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (6, 80, 1, 24569);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (6, 89, 1, 14567);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (6, 91, 1, 15670);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (7, 16, 1, 4290);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (7, 2, 2, 2190);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (7, 24, 1, 1690);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (8, 86, 1, 25625);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (8, 75, 3, 7890);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (8, 70, 2, 6550);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (9, 7, 1, 2490);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (9, 14, 2, 3190);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (10, 53, 1, 7550);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (10, 43, 1, 7130);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (10, 46, 1, 12340);
INSERT INTO order_item (order_id, stock_item_id, quantity, unit_price) VALUES (10, 61, 2, 8765);
SELECT setval('customer_order_order_id_seq', (SELECT MAX(order_id) FROM customer_order));
