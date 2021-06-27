DROP PROCEDURE IF EXISTS selectParts;

CREATE PROCEDURE selectParts (upc varchar(255) CHARSET utf8, name varchar(255) CHARSET utf8, price_bottom dec(19, 2), price_upper dec(19, 2), category int, supplier int)

SQL SECURITY INVOKER

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
END;





DROP PROCEDURE IF EXISTS partInfo;

CREATE PROCEDURE partInfo (id int, shop int)

SQL SECURITY INVOKER

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
  AND (s1.id = shop
  OR shop = 0);
END;





DROP PROCEDURE IF EXISTS partStock;

CREATE PROCEDURE partStock (id int)

SQL SECURITY INVOKER

BEGIN
  SELECT
    s.id,
    s.name,
    s.address,
    ps.count
  FROM part p
    JOIN part_shop ps
      ON p.id = ps.id_part
    JOIN shop s
      ON ps.id_shop = s.id
  WHERE ps.id_part = id;
END;





DROP PROCEDURE IF EXISTS selectPartsShopping;

CREATE PROCEDURE selectPartsShopping (name varchar(255) CHARSET utf8, price_bottom dec(19, 2), price_upper dec(19, 2), category int, sort int, show_absent bool, shop_id int)

SQL SECURITY INVOKER

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
END;





DROP PROCEDURE IF EXISTS userInfo;

CREATE PROCEDURE userInfo (login varchar(255) CHARSET utf8, user_id int)

SQL SECURITY INVOKER

BEGIN
  SELECT
    u.login,
    u.name,
    u.surname,
    u.phone,
    u.email,
    u.address,
    u.pref_shop_id,
    u.is_admin
  FROM user u
  WHERE u.login = login
  OR u.id = user_id;
END;





DROP PROCEDURE IF EXISTS ordInfo;

CREATE PROCEDURE ordInfo (ord_id int)

SQL SECURITY INVOKER

BEGIN
  SELECT
    u.login,
    s.name AS 'shop',
    s.address,
    s1.name AS 'status',
    o.date
  FROM ord o
    JOIN shop s
      ON o.id_shop = s.id
    JOIN user u
      ON o.id_user = u.id
    JOIN status s1
      ON o.id_status = s1.id
  WHERE o.id = ord_id;
END;





DROP PROCEDURE IF EXISTS selectOrds;

CREATE PROCEDURE selectOrds (ord_id varchar(255) CHARSET utf8, login varchar(255) CHARSET utf8, shop_id int, status_id int)

SQL SECURITY INVOKER

BEGIN
  SELECT
    o.id,
    u.login,
    s1.name AS 'shop',
    o.date,
    s.name AS 'status'
  FROM ord o
    JOIN user u
      ON o.id_user = u.id
    JOIN status s
      ON o.id_status = s.id
    JOIN shop s1
      ON o.id_shop = s1.id
  WHERE (CONVERT(o.id, char) LIKE CONCAT('%', ord_id, '%')
  OR ord_id = ''
  OR ord_id IS NULL)
  AND (login = ''
  OR login IS NULL
  OR u.login LIKE CONCAT('%', login, '%'))
  AND (shop_id = 0
  OR shop_id IS NULL
  OR o.id_shop = shop_id)
  AND (o.id_status = status_id
  OR status_id = 0)
  ORDER BY o.id DESC;
END;





DROP PROCEDURE IF EXISTS userOrds;

CREATE PROCEDURE userOrds (login varchar(255) CHARSET utf8, user_id int)

SQL SECURITY INVOKER

BEGIN
  SELECT
    o.id,
    s.name AS 'shop',
    o.date,
    s1.name AS 'status'
  FROM ord o
    JOIN user u
      ON o.id_user = u.id
    JOIN shop s
      ON o.id_shop = s.id
    JOIN status s1
      ON o.id_status = s1.id
  WHERE u.login = login
  OR u.id = user_id
  ORDER BY o.id DESC;
END;





DROP PROCEDURE IF EXISTS ordGetParts;

CREATE PROCEDURE ordGetParts (ord_id int)

SQL SECURITY INVOKER

BEGIN
  SELECT
    p.id,
    p.upc,
    p.name,
    p.price,
    op.count
  FROM order_part op
    JOIN ord o
      ON op.id_order = o.id
    JOIN part p
      ON op.id_part = p.id
  WHERE o.id = ord_id;
END;





DROP PROCEDURE IF EXISTS selectUsers;

CREATE PROCEDURE selectUsers (login varchar(255) CHARSET utf8, phone varchar(255) CHARSET utf8, email varchar(255) CHARSET utf8, is_admin int)

SQL SECURITY INVOKER

BEGIN
  SELECT
    u.id,
    u.login,
    u.name,
    u.surname,
    u.phone,
    u.email,
    u.address,
    u.is_admin
  FROM user u
  WHERE (u.login LIKE CONCAT('%', login, '%')
  OR login = ''
  OR login IS NULL)
  AND (u.phone LIKE CONCAT('%', phone, '%')
  OR phone = ''
  OR phone IS NULL)
  AND (u.email LIKE CONCAT('%', email, '%')
  OR email = ''
  OR email IS NULL)
  AND (u.is_admin = is_admin
  OR is_admin = -1);
END;