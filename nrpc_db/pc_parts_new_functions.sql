DROP FUNCTION IF EXISTS addNewPart;

CREATE FUNCTION addNewPart (upc varchar(255) CHARSET utf8, name varchar(255) CHARSET utf8, price dec(19, 2), category_id int, supplier_id int, description text CHARSET utf8, image varchar(255) CHARSET utf8)

RETURNS int

SQL SECURITY INVOKER

BEGIN
  DECLARE part_id int;
  DECLARE shop_id int;
  DECLARE n int;
  DECLARE i int;
  DECLARE part_count int;

  SELECT
    COUNT(*) INTO part_count
  FROM part p
  WHERE p.upc LIKE upc;

  IF (part_count > 0) THEN
    RETURN 0;
  END IF;

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
END;





DROP FUNCTION IF EXISTS addNewUser;

CREATE FUNCTION addNewUser (login varchar(255) CHARSET utf8, password varchar(255) CHARSET utf8, name varchar(255) CHARSET utf8, surname varchar(255) CHARSET utf8, phone varchar(255) CHARSET utf8, email varchar(255) CHARSET utf8, address varchar(255) CHARSET utf8)

RETURNS int

SQL SECURITY INVOKER

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
END;





DROP FUNCTION IF EXISTS createNewOrd;

CREATE FUNCTION createNewOrd (login varchar(255) CHARSET utf8)

RETURNS int

SQL SECURITY INVOKER

BEGIN
  DECLARE user_id int;
  DECLARE shop_id int;

  SELECT
    u.id INTO user_id
  FROM user u
  WHERE u.login = login;

  SELECT
    u.pref_shop_id INTO shop_id
  FROM user u
  WHERE u.id = user_id;

  INSERT IGNORE INTO ord
    VALUES (NULL, user_id, shop_id, 2, CURDATE());

  RETURN LAST_INSERT_ID();
END;





DROP FUNCTION IF EXISTS modifyOrder;

CREATE FUNCTION modifyOrder (ord_id int, part_id int, ord_count int)

RETURNS int

SQL SECURITY INVOKER

BEGIN
  DECLARE supply int;
  DECLARE shop_id int;

  SELECT
    o.id_shop INTO shop_id
  FROM ord o
  WHERE o.id = ord_id;

  SELECT
    ps.count INTO supply
  FROM part_shop ps
  WHERE ps.id_part = part_id
  AND ps.id_shop = shop_id;

  IF (supply >= ord_count) THEN
    UPDATE part_shop ps
    SET ps.count = ps.count - ord_count
    WHERE ps.id_part = part_id
    AND ps.id_shop = shop_id;

    INSERT IGNORE INTO order_part
      VALUES (NULL, ord_id, part_id, ord_count);
    RETURN 1;
  END IF;

  RETURN 0;
END;





DROP FUNCTION IF EXISTS modifySupply;

CREATE FUNCTION modifySupply (part_id int, shop_id int, supply int)

RETURNS int

SQL SECURITY INVOKER

BEGIN
  UPDATE part_shop ps
  SET ps.count = supply
  WHERE ps.id_part = part_id
  AND ps.id_shop = shop_id;


  RETURN 1;
END;





DROP FUNCTION IF EXISTS handleLogin;

CREATE FUNCTION handleLogin (login varchar(255) CHARSET utf8, password varchar(255) CHARSET utf8)

RETURNS varchar(255) CHARSET utf8

SQL SECURITY INVOKER

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
END;





DROP FUNCTION IF EXISTS isUserAdmin;

CREATE FUNCTION isUserAdmin (login varchar(255) CHARSET utf8)

RETURNS bool

SQL SECURITY INVOKER

BEGIN
  DECLARE is_user_admin bool;
  SELECT
    is_admin INTO is_user_admin
  FROM user u
  WHERE u.login = login;
  RETURN is_user_admin;
END;





DROP FUNCTION IF EXISTS modifyPart;

CREATE FUNCTION modifyPart (id int, upc varchar(255) CHARSET utf8, name varchar(255) CHARSET utf8, price dec(19, 2), category_id int, supplier_id int, description text CHARSET utf8, image varchar(255) CHARSET utf8)

RETURNS int

SQL SECURITY INVOKER

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
END;





DROP FUNCTION IF EXISTS saveCart;

CREATE FUNCTION saveCart (login varchar(255) CHARSET utf8, cart varchar(255) CHARSET utf8)

RETURNS int

SQL SECURITY INVOKER

BEGIN
  UPDATE user u
  SET u.cart = cart
  WHERE u.login = login;

  RETURN 1;
END;





DROP FUNCTION IF EXISTS modifyUser;

CREATE FUNCTION modifyUser (login varchar(255) CHARSET utf8, name varchar(255) CHARSET utf8, surname varchar(255) CHARSET utf8, phone varchar(255) CHARSET utf8, email varchar(255) CHARSET utf8, address varchar(255) CHARSET utf8, shop int)

RETURNS int

SQL SECURITY INVOKER

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
END;





DROP FUNCTION IF EXISTS getUserShop;

CREATE FUNCTION getUserShop (login varchar(255) CHARSET utf8)

RETURNS int

SQL SECURITY INVOKER

BEGIN
  DECLARE id_shop int;

  SELECT
    u.pref_shop_id INTO id_shop
  FROM user u
  WHERE u.login = login;

  RETURN id_shop;
END;





DROP FUNCTION IF EXISTS getEmail;

CREATE FUNCTION getEmail (login varchar(255) CHARSET utf8)

RETURNS varchar(255) CHARSET utf8

SQL SECURITY INVOKER

BEGIN
  DECLARE email varchar(255) CHARSET utf8;

  SELECT
    u.email INTO email
  FROM user u
  WHERE u.login = login;

  RETURN email;
END;





DROP FUNCTION IF EXISTS ordStatus;

CREATE FUNCTION ordStatus (ord_id int, status_id int)

RETURNS int

SQL SECURITY INVOKER

BEGIN
  UPDATE ord o
  SET o.id_status = status_id
  WHERE o.id = ord_id;

  RETURN 1;
END;





DROP FUNCTION IF EXISTS changeAdmin;

CREATE FUNCTION changeAdmin (user_id int)

RETURNS int

SQL SECURITY INVOKER

BEGIN
  UPDATE user u
  SET u.is_admin = !u.is_admin
  WHERE u.id = user_id;

  RETURN 1;
END;