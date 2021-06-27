--
-- Скрипт сгенерирован Devart dbForge Studio 2019 for MySQL, Версия 8.1.22.0
-- Домашняя страница продукта: http://www.devart.com/ru/dbforge/mysql/studio
-- Дата скрипта: 19.05.2021 18:13:42
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
-- Установка базы данных по умолчанию
--
USE pc_parts_new;

--
-- Создать таблицу `user`
--
CREATE TABLE user (
  id int(11) NOT NULL AUTO_INCREMENT,
  login varchar(255) NOT NULL,
  password varchar(255) NOT NULL,
  name varchar(255) NOT NULL,
  surname varchar(255) NOT NULL,
  phone varchar(255) NOT NULL,
  email varchar(50) NOT NULL,
  address varchar(255) NOT NULL,
  is_admin tinyint(1) NOT NULL,
  cart varchar(255) NOT NULL DEFAULT '_',
  pref_shop_id int(11) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 13,
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
AUTO_INCREMENT = 6,
AVG_ROW_LENGTH = 4096,
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
AUTO_INCREMENT = 21,
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
CREATE PROCEDURE selectParts (upc varchar(255) CHARSET utf8, name varchar(255) CHARSET utf8, price_bottom dec(19, 2), price_upper dec(19, 2), category int, supplier int)
BEGIN
  SELECT
    p.id,
    p.upc,
    p.name,
    p.price,
    c.name AS 'category',
    s.name AS 'supplier'
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
  AND (p.id_category = category
  OR category = 0)
  AND (p.id_supplier = supplier
  OR supplier = 0);
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
  description text DEFAULT NULL,
  image varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 48,
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
CREATE FUNCTION modifyPart (id int, upc varchar(255) CHARSET utf8, name varchar(255) CHARSET utf8, price dec(19, 2), category_id int, supplier_id int, description text CHARSET utf8, image varchar(255) CHARSET utf8)
RETURNS int(11)
BEGIN
  UPDATE part p
  SET p.upc = upc,
      p.name = name,
      p.price = price,
      p.id_category = category_id,
      p.id_supplier = supplier_id,
      p.description = description,
      p.image = image
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

DELIMITER $$

--
-- Создать функцию `modifyUser`
--
CREATE FUNCTION modifyUser (login varchar(255) CHARSET utf8, name varchar(255) CHARSET utf8, surname varchar(255) CHARSET utf8, phone varchar(255) CHARSET utf8, email varchar(255) CHARSET utf8, address varchar(255) CHARSET utf8, shop int)
RETURNS int(11)
BEGIN
  UPDATE user u
  SET u.name = name,
      u.surname = surname,
      u.phone = phone,
      u.email = email,
      u.address = address,
      u.pref_shop_id = shop
  WHERE u.login = login;

  RETURN 1;
END
$$

--
-- Создать процедуру `selectPartsShopping`
--
CREATE PROCEDURE selectPartsShopping (name varchar(255) CHARSET utf8, price_bottom dec(19, 2), price_upper dec(19, 2), category int, sort int, show_absent bool, shop_id int)
BEGIN
  SELECT
    p.id,
    p.name,
    p.price,
    p.image,
    ps.count AS 'in_stock',
    s.id AS 'shop',
    COUNT(*) AS 'count'
  FROM part p
    JOIN category c
      ON p.id_category = c.id
    JOIN part_shop ps
      ON p.id = ps.id_part
    JOIN shop s
      ON ps.id_shop = s.id
  WHERE (name = ''
  OR name IS NULL
  OR p.name LIKE CONCAT('%', name, '%'))
  AND (p.price >= price_bottom
  AND p.price <= price_upper)
  AND (p.id_category = category
  OR category = 0)
  AND (s.id = shop_id
  OR shop_id = 0)
  GROUP BY p.id
  HAVING ((NOT show_absent
  AND in_stock > 0
  AND (shop = shop_id
  OR shop_id = 0))
  OR show_absent)
  ORDER BY CASE sort WHEN 0 THEN p.price END ASC,
  CASE sort WHEN 1 THEN p.price END DESC;
END
$$

--
-- Создать процедуру `partInfo`
--
CREATE PROCEDURE partInfo (id int, shop int)
BEGIN
  SELECT
    p.upc,
    p.name,
    p.price,
    c.id AS 'category',
    c.name AS 'category_name',
    s.id AS 'supplier',
    s.name AS 'supplier_name',
    p.description,
    p.image,
    ps.count AS 'in_stock'
  FROM part p
    JOIN category c
      ON p.id_category = c.id
    JOIN supplier s
      ON p.id_supplier = s.id
    JOIN part_shop ps
      ON p.id = ps.id_part
    JOIN shop s1
      ON ps.id_shop = s1.id
  WHERE p.id = id
  AND s1.id = shop;
END
$$

DELIMITER ;

--
-- Создать представление `get_shops`
--
CREATE
VIEW get_shops
AS
SELECT
  `s`.`id` AS `id`,
  `s`.`name` AS `name`
FROM `shop` `s`
ORDER BY `s`.`id`;

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
AUTO_INCREMENT = 67,
AVG_ROW_LENGTH = 2048,
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
REFERENCES part (id) ON DELETE CASCADE ON UPDATE NO ACTION;

DELIMITER $$

--
-- Создать функцию `modifySupply`
--
CREATE FUNCTION modifySupply (part_id int, shop_id int, supply int)
RETURNS int(11)
BEGIN
  UPDATE part_shop ps
  SET ps.count = supply
  WHERE ps.id_part = part_id
  AND ps.id_shop = shop_id;


  RETURN 1;
END
$$

--
-- Создать функцию `addNewPart`
--
CREATE FUNCTION addNewPart (upc varchar(255) CHARSET utf8, name varchar(255) CHARSET utf8, price dec(19, 2), category_id int, supplier_id int, description text CHARSET utf8, image varchar(255) CHARSET utf8)
RETURNS int(11)
BEGIN
  DECLARE part_id int;
  DECLARE shop_id int;
  DECLARE n int;
  DECLARE i int;

  INSERT IGNORE INTO part
    VALUES (NULL, upc, name, price, category_id, supplier_id, description, image);

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

--
-- Создать процедуру `partStock`
--
CREATE PROCEDURE partStock (id int)
BEGIN
  SELECT
    s.id,
    s.name,
    ps.count
  FROM part p
    JOIN part_shop ps
      ON p.id = ps.id_part
    JOIN shop s
      ON ps.id_shop = s.id
  WHERE ps.id_part = id;
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
-- Создать процедуру `userInfo`
--
CREATE PROCEDURE userInfo (login varchar(255) CHARSET utf8)
BEGIN
  SELECT
    u.name,
    u.surname,
    u.phone,
    u.email,
    u.address,
    u.pref_shop_id
  FROM user u
  WHERE u.login = login;
END
$$

--
-- Создать функцию `saveCart`
--
CREATE FUNCTION saveCart (login varchar(255) CHARSET utf8, cart varchar(255) CHARSET utf8)
RETURNS int(11)
BEGIN
  UPDATE user u
  SET u.cart = cart
  WHERE u.login = login;

  RETURN 1;
END
$$

--
-- Создать функцию `isUserAdmin`
--
CREATE FUNCTION isUserAdmin (login varchar(255) CHARSET utf8)
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
CREATE FUNCTION handleLogin (login varchar(255) CHARSET utf8, password varchar(255) CHARSET utf8)
RETURNS varchar(255) CHARSET utf8
BEGIN
  DECLARE existing_users int;
  DECLARE cart varchar(255) CHARSET utf8;

  SELECT
    COUNT(*) INTO existing_users
  FROM user u
  WHERE u.login = login
  AND u.PASSWORD = password;

  IF (existing_users > 0) THEN
    SELECT
      u.cart INTO cart
    FROM user u
    WHERE u.login = login;

    RETURN CONVERT(cart USING utf8);
  ELSE
    RETURN '0';
  END IF;
END
$$

--
-- Создать функцию `getUserShop`
--
CREATE FUNCTION getUserShop (login varchar(255) CHARSET utf8)
RETURNS int(11)
BEGIN
  DECLARE id_shop int;
  SELECT
    u.pref_shop_id INTO id_shop
  FROM user u
  WHERE u.login = login;

  RETURN id_shop;
END
$$

--
-- Создать функцию `addNewUser`
--
CREATE FUNCTION addNewUser (login varchar(255) CHARSET utf8, password varchar(255) CHARSET utf8, name varchar(255) CHARSET utf8, surname varchar(255) CHARSET utf8, phone varchar(255) CHARSET utf8, email varchar(255) CHARSET utf8, address varchar(255) CHARSET utf8)
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
    VALUES (NULL, login, password, name, surname, phone, email, address, 0, '_', 0);

  RETURN 3;
END
$$

DELIMITER ;

-- 
-- Вывод данных для таблицы supplier
--
INSERT INTO supplier VALUES
(1, 'Compart', 'ул. Гидротехников, д. 155', '+7 (911) 324-03-22', 'office@comp.ru'),
(2, 'WalrusTorg', 'ул. Пролетарская, д. 154', '+7 (905) 259-21-89', 'office@waltorg.ru'),
(3, 'OpenPC', 'ул. Комиссара Смирнова, д. 55', '+7 (974) 648-75-50', 'office@openpc.com'),
(4, 'InterDel', 'ул. Галстяна, д. 197', '+7 (976) 285-17-14', 'office@interdel.com'),
(5, 'PartsEx', 'ул. 5 Декабря, д. 159', '+7 (941) 598-51-05', 'office@partsex.ru');

-- 
-- Вывод данных для таблицы category
--
INSERT INTO category VALUES
(7, 'HDD'),
(9, 'PCI-E модуль'),
(16, 'RGB подсветка'),
(19, 'SSD'),
(5, 'Блок питания'),
(2, 'Видеокарта'),
(20, 'Другое'),
(15, 'Кабели'),
(12, 'Клавиатура'),
(6, 'Корпус'),
(4, 'Материнская плата'),
(8, 'Монитор'),
(13, 'Мышь'),
(14, 'Наушники'),
(17, 'Ноутбук'),
(3, 'Оперативная память'),
(11, 'Охлаждение'),
(18, 'ПК'),
(1, 'Процессор'),
(10, 'Сетевое оборудование');

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
(39, '691970352436', 'Процессор AMD Ryzen 5 3600 OEM [AM4, 6 x 3600 МГц, L2 - 3 Мб, L3 - 32 МБ, 2хDDR4-3200 МГц, TDP 65 Вт]', 14599.00, 1, 1, '6-ядерный процессор AMD Ryzen 5 3600 OEM порадует высоким уровнем производительности подавляющее большинство пользователей. Устройство будет уверенно себя чувствовать в составе мощной игровой системы. Базовая частота процессора равна 3600 МГц. Турбочастота – 4200 МГц. Важной особенностью процессора является очень большой объем кэша третьего уровня: величина этого показателя равна 32 МБ. Объем кэша L2 – 3 МБ.\r\nПроцессор AMD Ryzen 5 3600 OEM не имеет встроенного графического ядра. Модель совместима с памятью DDR4, объем которой может достигать 128 ГБ. Минимально допустимая частота оперативной памяти – 1600 МГц. Максимально допустимая частота вдвое выше – 3200 МГц.\r\nПроцессор не укомплектован системой охлаждения. Выбор кулера предоставлен производителем пользователю. Несмотря на высокий уровень эксплуатационных параметров, процессор отличается незначительным (лишь 65 Вт) показателем TDP. Для установки устройства используется сокет AM4.', '691970352436.jpg'),
(40, '029079274707', 'Видеокарта Gigabyte GeForce GTX 1050 Ti [GV-N105TOC-4GD] [PCI-E 3.0, 4 ГБ GDDR5, 128 бит, 1316 МГц - 1455 МГц, HDMI, DisplayPort, DVI-D]', 21599.00, 2, 1, 'Видеокарта Gigabyte GeForce GTX 1050 Ti создана для игрового компьютера. Разработана как модель с серьезными возможностями. Качество сборки и деталей не вызывает сомнения – производитель не стал экономить на охлаждении, внутри установлен радиатор с термотрубками, отводящий тепло от подсистемы питания, графического чипа и памяти, снаружи – два 90-миллиметровых вентилятора.\r\nПри подключении к монитору с разрешением не выше Full HD Gigabyte GeForce GTX 1050 Ti обеспечит безупречную картинку. Возможно, что для самых требовательных игр придется немного снизить настройки, но большинство будет работать отлично и на максимальных.', '029079274707.jpg'),
(41, '493435063406', 'Материнская плата MSI X470 GAMING PLUS MAX [AM4, AMD X470, 4xDDR4-4133 МГц, 3xPCI-Ex16, аудио 7.1, Standard-ATX]', 8599.00, 4, 4, 'Материнская плата MSI X470 GAMING PLUS MAX – гарантия успеха при сборке высококлассного игрового компьютера. Возможности чипсета AMD X470, на котором базируется устройство, не нуждаются в каких-либо рекомендациях. Плата поддерживает CrossFire X. Есть поддержка NVMe-накопителей. Максимальный объем памяти – 64 ГБ. Если вас не слишком интересуют игры, то вы сможете воспользоваться тем, что совокупность эксплуатационных характеристик модели также позволяет создать мощную рабочую станцию универсального назначения.\r\nФорм-фактор платы MSI X470 GAMING PLUS MAX – Standard-ATX. Высота и ширина устройства равны 305 и 244 мм соответственно. Комплектация – стандартна. Особенностью модели является наличие подсветки.', '493435063406.jpg'),
(42, '491143185890', 'Процессор AMD Ryzen 7 2700X BOX [AM4, 8 x 3700 МГц, L2 - 4 МБ, L3 - 16 Мб, 2хDDR4-2933 МГц, TDP 105 Вт, кулер]', 18599.00, 1, 4, 'Процессор AMD Ryzen 7 2700X BOX оборудован разъемом подключения AM4 и предназначен для эксплуатации в высокопроизводительном игровом системном блоке. Восьмиядерная модель с поддержкой 16 потоков имеет базовую тактовую частоту на уровне 3700 МГц и поддерживает технологию разгона Precision Boost 2, благодаря которой тактовую частоту можно довести до 4300 МГц. ЦПУ рассчитан на работу с памятью DDR4, тактовая частота которой находится в диапазоне 1600-2933 МГц. Наибольший объем ОЗУ, поддерживаемый этой моделью, равняется 128 ГБ.\r\nВыделяемая процессором AMD Ryzen 7 2700X BOX тепловая мощность достигает 105 Вт, а его наибольшая температура в процессе работы составляет 85 °C. Устройство поставляется вместе с эффективным кулером, поэтому вам не придется выбирать для него соответствующую систему отвода тепла. Интегрированное графическое ядро не предусмотрено конструкцией этой модели.', '491143185890.jpg'),
(43, '797944610237', 'Оперативная память Kingston HyperX Predator [HX430C15PB3K2/16] 16 ГБ [DDR4, 8 ГБx2 шт, 3000 МГц, PC24000, 15-17-17-32]', 7799.00, 3, 2, 'Оперативная память Kingston HyperX Predator [HX430C15PB3K2/16] – это 16-гигабайтный комплект, состоящий из двух 8-гигабайтных модулей. Модель соответствует типу DDR4. Память станет отличным вариантом для использования в составе ультрапроизводительного игрового компьютера. Если же вы хотите собрать мощную систему универсального назначения, то память Kingston HyperX Predator [HX430C15PB3K2/16] также способна удовлетворить все требования.\r\nСкоростные характеристики памяти впечатляют: используя тактовую частоту 3000 МГц, модель характеризуется пропускной способностью, равной 24000 МБ/с. При этом вы сможете извлечь преимущества из поддержки технологии Intel XMP, поддержку которой имеет память. Владельцы материнских плат, рассчитанных на использование памяти, работающей на других, более низких частотах, также смогут использовать устройство, ведь память может функционировать на частотах от 1600 МГц.\r\nПамять Kingston HyperX Predator [HX430C15PB3K2/16] соответствует таймингам 15-17-17-32. Высота модулей, обусловленная наличием радиаторов, равна 42.2 мм. Напряжение питания памяти – 1.35 В.', '797944610237.jpg'),
(44, '117371730028', 'Сертификат 80+ STANDART1376584 Блок питания CoolerMaster MWE 650 WHITE - V2 [MPE-6501-ACABW-EU] [650 Вт, EPS12V, APFC, 20+4 pin, 1x 4+4 pin, 1x 8 pin CPU, 6 шт SATA, 4x 6+2 pin PCI-E]', 4499.00, 5, 5, 'Блок питания CoolerMaster MWE 650 WHITE - V2 [MPE-6501-ACABW-EU], номинальная выходная мощность которого равна 650 Вт, способен обеспечить электропитание компонентов компьютера высокого класса. Вы сможете использовать мощный процессор, производительный видеоадаптер (или несколько видеоадаптеров), а также значительное количество плат расширения и накопителей. Форм-фактор устройства – ATX. Это значит, что блок питания обладает совместимостью с подавляющим большинством корпусов. Энергоэффективность модели превышает средний уровень: об этом свидетельствует соответствие источника питания сертификату 80 PLUS Standart.\r\nБлок питания CoolerMaster MWE 650 WHITE - V2 [MPE-6501-ACABW-EU] рассчитан на работу в условиях наличия входного напряжения от 200 до 240 В. Охлаждение устройства осуществляет малошумный, но производительный вентилятор 120-миллиметрового форм-фактора. В комплект поставки входят крепежные винты, документация и сетевой кабель питания. Длина, ширина и высота корпуса блока питания равны 140, 150 и 86 мм соответственно. Это стандартные размеры для источников питания ATX.', '117371730028.jpg'),
(45, '513298590034', '480 ГБ SSD-накопитель Kingston A400 [SA400S37/480G] [SATA III, чтение - 500 Мбайт/сек, запись - 450 Мбайт/сек, Phison PS3111-S11, 3D NAND 3 бит TLC]', 4799.00, 19, 1, '480-гигабайтный SSD-накопитель Kingston A400 [SA400S37/480G], соответствующий 2.5-дюймовому форм-фактору, оптимален для использования в качестве системного диска в производительных мобильных или стационарных компьютерах. Модель изготовлена на базе контроллера Phison PS3111-S11, и характеризуется максимальными скоростями чтения и записи 500 и 450 МБ/с соответственно. Kingston A400 [SA400S37/480G] надежен: его ожидаемый срок службы составляет 1 миллион часов. Габаритные размеры устройства, корпус которого окрашен в серый цвет, составляют 100x69.9x7 мм.', '513298590034.jpg'),
(47, '358188142760', 'Корпус Deepcool Tesseract SW-RD [DP-ATX-TSRBKRD] красный [Mid-Tower, Micro-ATX, Mini-ITX, Standard-ATX, 1x USB 3.2 Gen1 Type-A, 1x USB 2.0 Type-A]', 4050.00, 6, 2, 'Перед Вами ультрастильный игровой корпус Deepcool Tesseract SW-RD. Представленная модель станет настоящей находкой для геймера, который желает, чтобы все комплектующие его компьютера находились не только в красивом, но и эффективном стальном корпусе. Тщательно продуманная архитектура Deepcool Tesseract SW-RD предусматривает наличие ножек, компенсирующих неровности пола и не позволяющих днищу перегреваться, а также специального окна в боковой стенке, которое позволяет визуально наблюдать за работающей системой. Встроенная красная подсветка придаст игре в ночное время атмосферу таинственности.\r\nКорпус поставляется совместно с набором крепежных элементов и стяжками для кабеля. Предусмотрена качественная система охлаждения, выполненная в виде двух вентиляторов диаметром в 12 см. Также предусмотрены дополнительные места для еще двух аналогичных вентиляторов. Также имеется возможность установки системы жидкостного охлаждения. Для размещения блока отведена нижняя часть корпуса.', '358188142760.jpg');

-- 
-- Вывод данных для таблицы user
--
INSERT INTO user VALUES
(1, 'erius', 'Roge2003', 'Ерог', 'Капралов', '89052592189', 'egor_kapralov2003@mail.ru', 'ул. Рогожский Поселок, д. 113', 1, '_.43', 1),
(2, 'WalrusYT', 'LubluMamy2003', 'Илья', 'Тат', '89630899425', 'taytsev@mail.ru', 'ул. Дружбы, д. 7', 0, '_', 0),
(3, 'arcwarden', 'pudgemom', 'Стэко', 'Слэйв', '89577366567', 'xrenxrenxrenxren@mail.ru', 'ул. Ращупкина, д. 21', 0, '_', 0),
(4, 'pupkin', 'vasya123', 'Вася', 'Пупкин', '89113451232', 'vasya_pupkin@mail.ru', 'ул. Ясеневая, д. 77', 0, '_', 0),
(5, 'erius1', 'wasd123', 'egor', 'karpov', '89052592169', 'wasd@mail.ru', 'ул. Пушкина, д. 1', 0, '_', 0),
(6, 'black', 'bigpig', 'слэкос', 'на бабках', '822813371488', 'xrenxrenxrenxren@yandex.dot', 'не скажу', 0, '_', 0),
(7, 'ernest', 'wasd', 'Ерог', 'Карпов', '89052592117', 'egor_kapralov1993@mail.ru', 'нет', 0, '_', 0),
(9, 'elka', '123', 'Елена', 'Комарова', '1111111111', 'ekom@yandex.ru', 'не скажу', 0, '_', 0),
(10, 'erius123', 'wasd', 'Егор', 'Капралов', '8888888888', 'egor_kapralov321312@mail.ru', 'не скажу', 0, '_', 0),
(11, 'kirill19072003', 'amosus228', 'Кирилл', 'Евграфов', '79119720686', 'kirill.evgrafov.19@mail.ru', '[eq', 1, '_.45', 0),
(12, 'test', 'test', 'test', 'test', '123', 'test', 'test', 0, '_.43', 1);

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
(49, 39, 1, 3),
(50, 39, 2, 2),
(51, 40, 1, 5),
(52, 40, 2, 1),
(53, 41, 1, 0),
(54, 41, 2, 0),
(55, 42, 1, 0),
(56, 42, 2, 0),
(57, 43, 1, 4),
(58, 43, 2, 3),
(59, 44, 1, 0),
(60, 44, 2, 3),
(61, 45, 1, 4),
(62, 45, 2, 3),
(65, 47, 1, 0),
(66, 47, 2, 0);

-- 
-- Вывод данных для таблицы order_info
--
-- Таблица pc_parts_new.order_info не содержит данных

-- 
-- Вывод данных для таблицы ord
--
-- Таблица pc_parts_new.ord не содержит данных

-- 
-- Восстановить предыдущий режим SQL (SQL mode)
-- 
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

-- 
-- Включение внешних ключей
-- 
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;