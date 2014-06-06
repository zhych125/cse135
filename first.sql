DROP INDEX IF EXISTS sales_uid CASCADE;
DROP INDEX IF EXISTS sales_pid CASCADE;
DROP INDEX IF EXISTS user_product_amount_uid CASCADE;
DROP INDEX IF EXISTS user_product_amount_pid CASCADE;
DROP INDEX IF EXISTS state_product_amount_pid CASCADE;
DROP INDEX IF EXISTS user_category_amount_uid CASCADE;
DROP TABLE IF EXISTS state_category_amount CASCADE;
DROP TABLE IF EXISTS user_category_amount CASCADE;
DROP TABLE IF EXISTS state_product_amount CASCADE;
DROP TABLE IF EXISTS user_product_amount CASCADE;
CREATE INDEX sales_uid ON sales(uid);
CREATE INDEX sales_pid ON sales(pid);

CREATE TABLE user_product_amount AS
(
  SELECT s.uid,s.pid,sum(s.price*s.quantity) AS amount
  FROM sales s
  GROUP BY s.uid,s.pid
);
CREATE INDEX user_product_amount_uid ON user_product_amount(uid);
CREATE INDEX user_product_amount_pid ON user_product_amount(pid);

CREATE TABLE state_product_amount AS
(
  SELECT u.state,s.pid,sum(s.amount) AS amount
  FROM users u,user_product_amount s
  WHERE u.id=s.uid
  GROUP BY u.state,s.pid
);
CREATE INDEX state_product_amount_pid ON state_product_amount(pid);

CREATE TABLE user_category_amount AS
(
  SELECT s.uid,p.cid,sum(s.amount) AS amount
  FROM user_product_amount s, products p
  WHERE p.id=s.pid
  GROUP BY s.uid,p.cid
);

CREATE INDEX user_category_amount_uid ON user_category_amount(uid);


CREATE TABLE state_category_amount AS
(
  SELECT u.state,s.cid,sum(s.amount) AS amount
  FROM users u,user_category_amount s
  WHERE u.id=s.uid
  GROUP BY u.state,s.cid
);

