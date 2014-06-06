DROP TABLE IF EXISTS state_category_amount CASCADE;
DROP TABLE IF EXISTS user_category_amount CASCADE;
DROP TABLE IF EXISTS state_product_amount CASCADE;
DROP TABLE IF EXISTS user_product_amount CASCADE;

CREATE TABLE user_product_amount AS
(
  SELECT s.uid,s.pid,sum(s.price*s.quantity) AS amount
  FROM sales s
  GROUP BY s.uid,s.pid
);

CREATE TABLE state_product_amount AS
(
  SELECT u.state,s.pid,sum(s.amount) AS amount
  FROM users u,user_product_amount s
  WHERE u.id=s.uid
  GROUP BY u.state,s.pid
);


CREATE TABLE user_category_amount AS
(
  SELECT s.uid,p.cid,sum(s.amount) AS amount
  FROM user_product_amount s, products p
  WHERE p.id=s.pid
  GROUP BY s.uid,p.cid
);


CREATE TABLE state_category_amount AS
(
  SELECT u.state,s.cid,sum(s.amount) AS amount
  FROM users u,user_category_amount s
  WHERE u.id=s.uid
  GROUP BY u.state,s.cid
);