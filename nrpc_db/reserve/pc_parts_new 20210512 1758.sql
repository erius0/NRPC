--
-- Скрипт сгенерирован Devart dbForge Studio 2019 for MySQL, Версия 8.1.22.0
-- Домашняя страница продукта: http://www.devart.com/ru/dbforge/mysql/studio
-- Дата скрипта: 12.05.2021 17:58:22
-- Версия сервера: 5.7.25
-- Версия клиента: 4.1
--

-- 
-- Отключение внешних ключей
-- 
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 
-- Установить режим SQL (SQL mode)
-- 
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 
-- Установка кодировки, с использованием которой клиент будет посылать запросы на сервер
--
SET NAMES 'utf8';

--
-- Удалить функцию `addNewUser`
--
DROP FUNCTION IF EXISTS addNewUser;

--
-- Удалить функцию `handleLogin`
--
DROP FUNCTION IF EXISTS handleLogin;

--
-- Удалить функцию `isUserAdmin`
--
DROP FUNCTION IF EXISTS isUserAdmin;

--
-- Удалить таблицу `ord`
--
DROP TABLE IF EXISTS ord;

--
-- Удалить функцию `addNewOrd`
--
DROP FUNCTION IF EXISTS addNewOrd;

--
-- Удалить функцию `addNewPart`
--
DROP FUNCTION IF EXISTS addNewPart;

--
-- Удалить функцию `modifySupply`
--
DROP FUNCTION IF EXISTS modifySupply;

--
-- Удалить таблицу `part_shop`
--
DROP TABLE IF EXISTS part_shop;

--
-- Удалить таблицу `shop`
--
DROP TABLE IF EXISTS shop;

--
-- Удалить функцию `modifyPart`
--
DROP FUNCTION IF EXISTS modifyPart;

--
-- Удалить таблицу `part`
--
DROP TABLE IF EXISTS part;

--
-- Удалить процедуру `selectParts`
--
DROP PROCEDURE IF EXISTS selectParts;

--
-- Удалить таблицу `category`
--
DROP TABLE IF EXISTS category;

--
-- Удалить таблицу `order_info`
--
DROP TABLE IF EXISTS order_info;

--
-- Удалить таблицу `status`
--
DROP TABLE IF EXISTS status;

--
-- Удалить таблицу `user`
--
DROP TABLE IF EXISTS user;

--
-- Удалить таблицу `supplier`
--
DROP TABLE IF EXISTS supplier;

--
-- Создать таблицу `supplier`
--
CREATE TABLE supplier (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  address varchar(255) NOT NULL,
  phone varchar(255) NOT NULL,
  email varchar(255) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 3,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `name` для объекта типа таблица `supplier`
--
ALTER TABLE supplier
ADD UNIQUE INDEX name (name);

--
-- Создать таблицу `user`
--
CREATE TABLE user (
  id int(11) NOT NULL AUTO_INCREMENT,
  login varchar(255) NOT NULL,
  password varchar(255) NOT NULL,
  name varchar(255) NOT NULL,
  surname varchar(255) NOT NULL,
  phone bigint(12) NOT NULL,
  email varchar(50) NOT NULL,
  address varchar(255) NOT NULL,
  is_admin tinyint(1) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 11,
AVG_ROW_LENGTH = 1820,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `email` для объекта типа таблица `user`
--
ALTER TABLE user
ADD UNIQUE INDEX email (email);

--
-- Создать индекс `login` для объекта типа таблица `user`
--
ALTER TABLE user
ADD UNIQUE INDEX login (login);

--
-- Создать индекс `phone` для объекта типа таблица `user`
--
ALTER TABLE user
ADD UNIQUE INDEX phone (phone);

--
-- Создать таблицу `status`
--
CREATE TABLE status (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 4,
AVG_ROW_LENGTH = 8192,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `name` для объекта типа таблица `status`
--
ALTER TABLE status
ADD UNIQUE INDEX name (name);

--
-- Создать таблицу `order_info`
--
CREATE TABLE order_info (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_user int(11) NOT NULL,
  id_status int(11) NOT NULL,
  date datetime NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 4,
AVG_ROW_LENGTH = 16384,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать внешний ключ
--
ALTER TABLE order_info
ADD CONSTRAINT FK_ord_status_id FOREIGN KEY (id_status)
REFERENCES status (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE order_info
ADD CONSTRAINT FK_ord_user_id FOREIGN KEY (id_user)
REFERENCES user (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать таблицу `category`
--
CREATE TABLE category (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 8,
AVG_ROW_LENGTH = 2340,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `name` для объекта типа таблица `category`
--
ALTER TABLE category
ADD UNIQUE INDEX name (name);

DELIMITER $$

--
-- Создать процедуру `selectParts`
--
CREATE PROCEDURE selectParts (upc varchar(255), name varchar(255), price_bottom dec(19, 2), price_upper dec(19, 2), categorys varchar(255), suppliers varchar(255))
BEGIN
  SELECT
    p.id,
    p.upc,
    p.name,
    p.price,
    c.id AS 'category',
    s.id AS 'supplier'
  FROM part p
    JOIN category c
      ON p.id_category = c.id
    JOIN supplier s
      ON p.id_supplier = s.id
  WHERE (upc = ''
  OR upc IS NULL
  OR p.upc LIKE CONCAT('%', upc, '%'))
  AND (name = ''
  OR name IS NULL
  OR p.name LIKE CONCAT('%', NAME, '%'))
  AND (p.price >= price_bottom
  AND p.price <= price_upper)
  AND (categorys = ''
  OR categorys IS NULL
  OR categorys LIKE CONCAT('%', CONVERT(p.id_category, char), '%'))
  AND (suppliers = ''
  OR suppliers IS NULL
  OR suppliers LIKE CONCAT('%', CONVERT(p.id_supplier, char), '%'));
END
$$

DELIMITER ;

--
-- Создать таблицу `part`
--
CREATE TABLE part (
  id int(11) NOT NULL AUTO_INCREMENT,
  upc varchar(255) NOT NULL,
  name varchar(255) NOT NULL,
  price decimal(19, 2) NOT NULL,
  id_category int(11) NOT NULL,
  id_supplier int(11) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 22,
AVG_ROW_LENGTH = 2340,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `upc` для объекта типа таблица `part`
--
ALTER TABLE part
ADD UNIQUE INDEX upc (upc);

--
-- Создать внешний ключ
--
ALTER TABLE part
ADD CONSTRAINT FK_part_category_id FOREIGN KEY (id_category)
REFERENCES category (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE part
ADD CONSTRAINT FK_part_supplier_id FOREIGN KEY (id_supplier)
REFERENCES supplier (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

DELIMITER $$

--
-- Создать функцию `modifyPart`
--
CREATE FUNCTION modifyPart (id int, upc varchar(255), name varchar(255), price dec(19, 2), category_id varchar(255), supplier_id varchar(255))
RETURNS int(11)
BEGIN
  UPDATE part p
  SET p.upc = upc,
      p.name = name,
      p.price = price,
      p.id_category = category_id,
      p.id_supplier = supplier_id
  WHERE p.id = id;

  RETURN 1;
END
$$

DELIMITER ;

--
-- Создать таблицу `shop`
--
CREATE TABLE shop (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  address varchar(255) NOT NULL,
  phone varchar(255) NOT NULL,
  email varchar(255) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 3,
AVG_ROW_LENGTH = 8192,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `UK_shop` для объекта типа таблица `shop`
--
ALTER TABLE shop
ADD UNIQUE INDEX UK_shop (name, address);

--
-- Создать таблицу `part_shop`
--
CREATE TABLE part_shop (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_part int(11) NOT NULL,
  id_shop int(11) NOT NULL,
  count int(11) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 15,
AVG_ROW_LENGTH = 1638,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `UK_stock` для объекта типа таблица `part_shop`
--
ALTER TABLE part_shop
ADD UNIQUE INDEX UK_stock (id_part, id_shop);

--
-- Создать внешний ключ
--
ALTER TABLE part_shop
ADD CONSTRAINT FK_part_shop_shop_id FOREIGN KEY (id_shop)
REFERENCES shop (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE part_shop
ADD CONSTRAINT FK_stock_part_id FOREIGN KEY (id_part)
REFERENCES part (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

DELIMITER $$

--
-- Создать функцию `modifySupply`
--
CREATE FUNCTION modifySupply (part_id int, shop_id int, supply int)
RETURNS int(11)
BEGIN
  UPDATE part_shop ps
  SET ps.count = ps.count + supply
  WHERE ps.id_part = part_id
  AND ps.id_shop = shop_id;


  RETURN 1;
END
$$

--
-- Создать функцию `addNewPart`
--
CREATE FUNCTION addNewPart (upc varchar(255), name varchar(255), price dec(19, 2), category_id int, supplier_id int)
RETURNS int(11)
BEGIN
  DECLARE part_id int;
  DECLARE shop_id int;
  DECLARE n int;
  DECLARE i int;

  INSERT IGNORE INTO part
    VALUES (NULL, upc, name, price, category_id, supplier_id);

  SELECT
    LAST_INSERT_ID() INTO part_id;

  SELECT
    COUNT(*)
  FROM shop s INTO n;

  SET i = 1;
  WHILE i <= n DO
    INSERT IGNORE INTO part_shop
      VALUES (NULL, part_id, i, 0);
    SET i = i + 1;
  END WHILE;

  RETURN 1;
END
$$

--
-- Создать функцию `addNewOrd`
--
CREATE FUNCTION addNewOrd (user_id int, part_id int, shop_id int, ord_count int)
RETURNS int(11)
BEGIN
  DECLARE order_info_id int;
  DECLARE part_shop_id int;
  DECLARE part_count int;

  SELECT
    ps.id,
    ps.count INTO part_shop_id, part_count
  FROM part_shop ps
  WHERE ps.id_part = part_id
  AND ps.id_shop = shop_id;

  IF (part_count < ord_count) THEN
    RETURN 0;
  END IF;

  INSERT IGNORE INTO order_info
    VALUES (NULL, user_id, 1, CURDATE());

  SELECT
    LAST_INSERT_ID() INTO order_info_id;

  UPDATE part_shop ps
  SET ps.count = ps.count - ord_count
  WHERE ps.id = part_shop_id;

  INSERT IGNORE INTO ord
    VALUE (NULL, order_info_id, part_shop_id, ord_count);

  RETURN 1;
END
$$

DELIMITER ;

--
-- Создать таблицу `ord`
--
CREATE TABLE ord (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_order_info int(11) NOT NULL,
  id_part_shop int(11) NOT NULL,
  count int(11) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 2,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `FK_ord_parts_ord_id` для объекта типа таблица `ord`
--
ALTER TABLE ord
ADD INDEX FK_ord_parts_ord_id (id_order_info);

--
-- Создать индекс `FK_ord_parts_part_id` для объекта типа таблица `ord`
--
ALTER TABLE ord
ADD INDEX FK_ord_parts_part_id (id_part_shop);

--
-- Создать индекс `UK_ord` для объекта типа таблица `ord`
--
ALTER TABLE ord
ADD UNIQUE INDEX UK_ord (id_order_info, id_part_shop);

--
-- Создать внешний ключ
--
ALTER TABLE ord
ADD CONSTRAINT FK_ord_order_info_id FOREIGN KEY (id_order_info)
REFERENCES order_info (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE ord
ADD CONSTRAINT FK_ord_part_shop_id FOREIGN KEY (id_part_shop)
REFERENCES part_shop (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

DELIMITER $$

--
-- Создать функцию `isUserAdmin`
--
CREATE FUNCTION isUserAdmin (login varchar(255))
RETURNS tinyint(1)
BEGIN
  DECLARE is_user_admin bool;
  SELECT
    is_admin INTO is_user_admin
  FROM user u
  WHERE u.login = login;
  RETURN is_user_admin;
END
$$

--
-- Создать функцию `handleLogin`
--
CREATE FUNCTION handleLogin (login varchar(255), password varchar(255))
RETURNS int(11)
BEGIN
  DECLARE existing_users int;
  SELECT
    COUNT(*) INTO existing_users
  FROM user u
  WHERE u.login = login
  AND u.PASSWORD = password;

  IF (existing_users > 0) THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END
$$

--
-- Создать функцию `addNewUser`
--
CREATE FUNCTION addNewUser (login varchar(255), password varchar(255), name varchar(255), surname varchar(255), phone varchar(255), email varchar(255), address varchar(255))
RETURNS int(11)
BEGIN
  DECLARE loginCount int;
  DECLARE phoneCount int;
  DECLARE emailCount int;

  SELECT
    COUNT(*) INTO loginCount
  FROM user u
  WHERE u.login = login;

  IF (loginCount > 0) THEN
    RETURN 0;
  END IF;

  SELECT
    COUNT(*) INTO phoneCount
  FROM user u
  WHERE u.phone = phone;

  IF (phoneCount > 0) THEN
    RETURN 1;
  END IF;

  SELECT
    COUNT(*) INTO emailCount
  FROM user u
  WHERE u.email = email;

  IF (emailCount > 0) THEN
    RETURN 2;
  END IF;

  INSERT IGNORE INTO user
    VALUES (NULL, login, password, name, surname, phone, email, address, 0);

  RETURN 3;
END
$$

DELIMITER ;

-- 
-- Вывод данных для таблицы supplier
--
INSERT INTO supplier VALUES
(1, 'Compart', 'ул. Гидротехников, д. 155', '+7 (911) 324-03-22', 'office@comp.ru'),
(2, 'WalrusTorg', 'ул. Пролетарская, д. 154', '+7 (905) 259-21-89', 'office@waltorg.ru');

-- 
-- Вывод данных для таблицы category
--
INSERT INTO category VALUES
(5, 'Блок питания'),
(2, 'Видеокарта'),
(7, 'Жесткий диск'),
(6, 'Корпус'),
(4, 'Материнская плата'),
(3, 'Оперативная память'),
(1, 'Процессор');

-- 
-- Вывод данных для таблицы shop
--
INSERT INTO shop VALUES
(1, 'Магазин в ТК Алоха', 'ул. Тютчевская, д. 2', '+7 (932) 139-73-10', 'tutchevskaya15@novparts.ru'),
(2, 'Магазин у ст. м. Чёрная речка', 'ул. Савушкина, д. 56', '+7 (924) 098-32-12', 'savushkina56@novparts.ru');

-- 
-- Вывод данных для таблицы part
--
INSERT INTO part VALUES
(15, '75764839123', 'AMD Ryzen 5 3600 OEM', 15990.99, 1, 2),
(16, '321981321321', 'Gigabyte GeForce GTX 1050Ti', 15990.99, 2, 2),
(17, '123453289123', 'Palit Gaming Pro GeForce RTX 3070', 119000.99, 2, 1),
(18, '987654321321', 'MSI X470 AM4 Gaming Plus Max', 7990.99, 4, 2),
(19, '541269041211', 'norm', 1999.99, 7, 1),
(20, '123456543214', 'eee', 199.12, 4, 2),
(21, '999999999999', 'test', 1234.99, 4, 1);

-- 
-- Вывод данных для таблицы user
--
INSERT INTO user VALUES
(1, 'erius', 'Roge2003', 'Егор', 'Капралов', 89052592189, 'egor_kapralov2003@mail.ru', 'ул. Рогожский Поселок, д. 113', 1),
(2, 'WalrusYT', 'LubluMamy2003', 'Илья', 'Тат', 89630899425, 'taytsev@mail.ru', 'ул. Дружбы, д. 7', 0),
(3, 'arcwarden', 'pudgemom', 'Стэко', 'Слэйв', 89577366567, 'xrenxrenxrenxren@mail.ru', 'ул. Ращупкина, д. 21', 0),
(4, 'pupkin', 'vasya123', 'Вася', 'Пупкин', 89113451232, 'vasya_pupkin@mail.ru', 'ул. Ясеневая, д. 77', 0),
(5, 'erius1', 'wasd123', 'egor', 'karpov', 89052592169, 'wasd@mail.ru', 'ул. Пушкина, д. 1', 0),
(6, 'black', 'bigpig', 'слэкос', 'на бабках', 822813371488, 'xrenxrenxrenxren@yandex.dot', 'не скажу', 0),
(7, 'ernest', 'wasd', 'Ерог', 'Карпов', 89052592117, 'egor_kapralov1993@mail.ru', 'нет', 0),
(9, 'elka', '123', 'Елена', 'Комарова', 1111111111, 'ekom@yandex.ru', 'не скажу', 0),
(10, 'erius123', 'wasd', 'Егор', 'Капралов', 8888888888, 'egor_kapralov321312@mail.ru', 'не скажу', 0);

-- 
-- Вывод данных для таблицы status
--
INSERT INTO status VALUES
(2, 'Можно забрать'),
(1, 'Ожидает прибытия'),
(3, 'Отменен');

-- 
-- Вывод данных для таблицы part_shop
--
INSERT INTO part_shop VALUES
(1, 15, 1, 0),
(2, 15, 2, 0),
(3, 16, 1, 8),
(4, 16, 2, 0),
(5, 17, 1, 0),
(6, 17, 2, 0),
(7, 18, 1, 0),
(8, 18, 2, 0),
(9, 19, 1, 0),
(10, 19, 2, 0),
(11, 20, 1, 0),
(12, 20, 2, 0),
(13, 21, 1, 0),
(14, 21, 2, 0);

-- 
-- Вывод данных для таблицы order_info
--
INSERT INTO order_info VALUES
(3, 1, 1, '2021-04-07 00:00:00');

-- 
-- Вывод данных для таблицы ord
--
INSERT INTO ord VALUES
(1, 3, 3, 2);

-- 
-- Восстановить предыдущий режим SQL (SQL mode)
-- 
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

-- 
-- Включение внешних ключей
-- 
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;