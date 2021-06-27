--
-- Скрипт сгенерирован Devart dbForge Studio 2019 for MySQL, Версия 8.1.22.0
-- Домашняя страница продукта: http://www.devart.com/ru/dbforge/mysql/studio
-- Дата скрипта: 24.03.2021 18:54:13
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
-- Удалить функцию `addNewPart`
--
DROP FUNCTION IF EXISTS addNewPart;

--
-- Удалить таблицу `stock`
--
DROP TABLE IF EXISTS stock;

--
-- Удалить таблицу `shop`
--
DROP TABLE IF EXISTS shop;

--
-- Удалить таблицу `ord_parts`
--
DROP TABLE IF EXISTS ord_parts;

--
-- Удалить таблицу `ord`
--
DROP TABLE IF EXISTS ord;

--
-- Удалить таблицу `user`
--
DROP TABLE IF EXISTS user;

--
-- Удалить таблицу `part`
--
DROP TABLE IF EXISTS part;

--
-- Удалить таблицу `category`
--
DROP TABLE IF EXISTS category;

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
AUTO_INCREMENT = 2,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `name` для объекта типа таблица `supplier`
--
ALTER TABLE supplier
ADD UNIQUE INDEX name (name);

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

--
-- Создать таблицу `part`
--
CREATE TABLE part (
  id int(11) NOT NULL AUTO_INCREMENT,
  upc bigint(12) NOT NULL,
  price decimal(19, 2) NOT NULL,
  id_category int(11) NOT NULL,
  id_supplier int(11) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 7,
AVG_ROW_LENGTH = 4096,
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

--
-- Создать таблицу `user`
--
CREATE TABLE user (
  id int(11) NOT NULL AUTO_INCREMENT,
  login varchar(255) NOT NULL,
  password varchar(255) NOT NULL,
  info varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 2,
AVG_ROW_LENGTH = 16384,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `login` для объекта типа таблица `user`
--
ALTER TABLE user
ADD UNIQUE INDEX login (login);

--
-- Создать таблицу `ord`
--
CREATE TABLE ord (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_user int(11) NOT NULL,
  status int(11) NOT NULL,
  date datetime NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 3,
AVG_ROW_LENGTH = 16384,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать внешний ключ
--
ALTER TABLE ord
ADD CONSTRAINT FK_ord_user_id FOREIGN KEY (id_user)
REFERENCES user (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать таблицу `ord_parts`
--
CREATE TABLE ord_parts (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_order int(11) NOT NULL,
  id_part int(11) NOT NULL,
  count int(11) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 3,
AVG_ROW_LENGTH = 8192,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать внешний ключ
--
ALTER TABLE ord_parts
ADD CONSTRAINT FK_ord_parts_ord_id FOREIGN KEY (id_order)
REFERENCES ord (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE ord_parts
ADD CONSTRAINT FK_ord_parts_part_id FOREIGN KEY (id_part)
REFERENCES part (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

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
-- Создать индекс `name` для объекта типа таблица `shop`
--
ALTER TABLE shop
ADD UNIQUE INDEX name (name);

--
-- Создать таблицу `stock`
--
CREATE TABLE stock (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_part int(11) NOT NULL,
  id_shop int(11) NOT NULL,
  count varchar(255) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 10,
AVG_ROW_LENGTH = 4096,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать внешний ключ
--
ALTER TABLE stock
ADD CONSTRAINT FK_stock_part_id FOREIGN KEY (id_part)
REFERENCES part (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE stock
ADD CONSTRAINT FK_stock_shop_id FOREIGN KEY (id_shop)
REFERENCES shop (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

DELIMITER $$

--
-- Создать функцию `addNewPart`
--
CREATE FUNCTION addNewPart (upc bigint(12), category_id int(11), supplier_id int(11), price dec(11, 2))
RETURNS int(11)
BEGIN
  DECLARE part_id int;
  DECLARE shop_id int;
  DECLARE n int;
  DECLARE i int;
  INSERT IGNORE INTO part
    VALUES (NULL, upc, price, category_id, supplier_id);
  SELECT
    p.id INTO part_id
  FROM part p
  WHERE p.upc = upc;
  SELECT
    COUNT(*)
  FROM s shop INTO n;
  SET i = 1;
  WHILE i <= n DO
    INSERT IGNORE INTO stock
      VALUES (NULL, part_id, i, 0);
    SET i = i + 1;
  END WHILE;
  RETURN 1;
END
$$

DELIMITER ;

-- 
-- Вывод данных для таблицы supplier
--
INSERT INTO supplier VALUES
(1, 'Compart', 'ул. Гидротехников, д. 155', '+7 (911) 324-03-22', 'office@comp.ru');

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
-- Вывод данных для таблицы user
--
INSERT INTO user VALUES
(1, 'erius', '12345678', '');

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
(2, 111111111111, 239.99, 1, 1),
(3, 123123123123, 699.99, 2, 1);

-- 
-- Вывод данных для таблицы ord
--
INSERT INTO ord VALUES
(2, 1, 3, '2021-03-24 00:00:00');

-- 
-- Вывод данных для таблицы stock
--
INSERT INTO stock VALUES
(5, 2, 1, '10'),
(7, 2, 2, '6'),
(8, 3, 1, '1'),
(9, 3, 2, '0\r\n');

-- 
-- Вывод данных для таблицы ord_parts
--
INSERT INTO ord_parts VALUES
(1, 2, 3, 1),
(2, 2, 2, 2);

-- 
-- Восстановить предыдущий режим SQL (SQL mode)
-- 
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

-- 
-- Включение внешних ключей
-- 
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;