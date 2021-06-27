DROP VIEW IF EXISTS get_shops;

CREATE VIEW get_shops
AS
SELECT
  s.id,
  s.name
FROM shop s
ORDER BY s.id ASC;





DROP VIEW IF EXISTS get_status;

CREATE VIEW get_status
AS
SELECT
  s.id,
  s.name
FROM status s
ORDER BY s.id ASC;





DROP VIEW IF EXISTS get_categories;

CREATE VIEW get_categories
AS
SELECT
  c.id,
  c.name
FROM category c
ORDER BY c.id ASC;





DROP VIEW IF EXISTS get_suppliers;

CREATE VIEW get_suppliers
AS
SELECT
  s.id,
  s.name
FROM supplier s
ORDER BY s.id ASC;