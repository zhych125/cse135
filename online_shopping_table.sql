--Drop all tables
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS carts CASCADE;
DROP TABLE IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS states CASCADE;

--Create tables

CREATE TABLE states (
    id SERIAL PRIMARY KEY,
    state TEXT NOT NULL UNIQUE
);

INSERT INTO states(state) VALUES('Alabama');
INSERT INTO states(state) VALUES('Alaska');
INSERT INTO states(state) VALUES('Arizona');
INSERT INTO states(state) VALUES('Arkansas');
INSERT INTO states(state) VALUES('California');
INSERT INTO states(state) VALUES('Colorado');
INSERT INTO states(state) VALUES('Connecticut');
INSERT INTO states(state) VALUES('Delaware');
INSERT INTO states(state) VALUES('Florida');
INSERT INTO states(state) VALUES('Georgia');
INSERT INTO states(state) VALUES('Hawaii');
INSERT INTO states(state) VALUES('Idaho');
INSERT INTO states(state) VALUES('Illinois');
INSERT INTO states(state) VALUES('Indiana');
INSERT INTO states(state) VALUES('Iowa');
INSERT INTO states(state) VALUES('Kansas');
INSERT INTO states(state) VALUES('Kentucky');
INSERT INTO states(state) VALUES('Louisiana');
INSERT INTO states(state) VALUES('Maine');
INSERT INTO states(state) VALUES('Maryland');
INSERT INTO states(state) VALUES('Massachusetts');
INSERT INTO states(state) VALUES('Michigan');
INSERT INTO states(state) VALUES('Minnesota');
INSERT INTO states(state) VALUES('Mississippi');
INSERT INTO states(state) VALUES('Missouri');
INSERT INTO states(state) VALUES('Montana');
INSERT INTO states(state) VALUES('Nebraska');
INSERT INTO states(state) VALUES('Nevada');
INSERT INTO states(state) VALUES('New Hampshire');
INSERT INTO states(state) VALUES('New Jersey');
INSERT INTO states(state) VALUES('New Mexico');
INSERT INTO states(state) VALUES('New York');
INSERT INTO states(state) VALUES('North Carolina');
INSERT INTO states(state) VALUES('North Dakota');
INSERT INTO states(state) VALUES('Ohio');
INSERT INTO states(state) VALUES('Oklahoma');
INSERT INTO states(state) VALUES('Oregon');
INSERT INTO states(state) VALUES('Pennsylvania');
INSERT INTO states(state) VALUES('Rhode Island');
INSERT INTO states(state) VALUES('South Carolina');
INSERT INTO states(state) VALUES('South Dakota');
INSERT INTO states(state) VALUES('Tennessee');
INSERT INTO states(state) VALUES('Texas');
INSERT INTO states(state) VALUES('Utah');
INSERT INTO states(state) VALUES('Vermont');
INSERT INTO states(state) VALUES('Virginia');
INSERT INTO states(state) VALUES('Washington');
INSERT INTO states(state) VALUES('West Virginia');
INSERT INTO states(state) VALUES('Wisconsin');
INSERT INTO states(state) VALUES('Wyoming');

SELECT * FROM STATES ORDER BY state asc;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  role  TEXT NOT NULL,
  age INTEGER NOT NULL,
  state TEXT NOT NULL
  
);

INSERT INTO users (name, role, age, state) VALUES('CSE','owner',35,'california');
INSERT INTO users (name, role, age, state) VALUES('David','customer',33,'New York');
INSERT INTO users (name, role, age, state) VALUES('Floyd','customer',27,'Florida');
INSERT INTO users (name, role, age, state) VALUES('James','customer',55,'Texas');
INSERT INTO users (name, role, age, state) VALUES('Ross','customer',24,'Arizona');
SELECT * FROM  users  order by id asc limit 5;

CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  description TEXT
);

INSERT INTO categories (name, description) VALUES('Computers','A computer is a general purpose device that can be programmed to carry out a set of arithmetic or logical operations automatically. Since a sequence of operations can be readily changed, the computer can solve more than one kind of problem.');
INSERT INTO categories (name, description) VALUES('Cell Phones','A mobile phone (also known as a cellular phone, cell phone, and a hand phone) is a phone that can make and receive telephone calls over a radio link while moving around a wide geographic area. It does so by connecting to a cellular network provided by a mobile phone operator, allowing access to the public telephone network.');
INSERT INTO categories (name, description) VALUES('Cameras','A camera is an optical instrument that records images that can be stored directly, transmitted to another location, or both. These images may be still photographs or moving images such as videos or movies.');
INSERT INTO categories (name, description) VALUES('Video Games','A video game is an electronic game that involves human interaction with a user interface to generate visual feedback on a video device..');
SELECT * FROM categories order by id asc;

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  cid INTEGER REFERENCES categories(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  SKU TEXT NOT NULL UNIQUE,
  price INTEGER NOT NULL CHECK (price>0)
);

INSERT INTO products (cid, name, SKU, price) VALUES(1, 'Apple MacBook',     '103001',   1200); /**1**/
INSERT INTO products (cid, name, SKU, price) VALUES(1, 'HP Laptop',         '106044',   480);
INSERT INTO products (cid, name, SKU, price) VALUES(1, 'Dell Laptop',       '109023',   399);/**3**/
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'Iphone 5s',         '200101',   709);
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'Samsung Galaxy S4', '208809',   488);/**5**/
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'LG Optimus g',       '209937',  375);
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'Sony DSC-RX100M',   '301211',   689);/**7**/
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'Canon EOS Rebel T3',     '304545',  449);
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'Nikon D3100',       '308898',   520);
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'Xbox 360',          '405065',   249);/**10**/
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'Nintendo Wii U ',    '407033',  430);
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'Nintendo Wii',      '408076',   232);
SELECT * FROM products order by id asc limit 10;


CREATE TABLE carts (
  id SERIAL PRIMARY KEY,  
  uid INTEGER REFERENCES users(id) ON DELETE CASCADE,
  pid INTEGER REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL CHECK(quantity>0),
  price INTEGER NOT NULL CHECK(price>0)
);

INSERT INTO carts (uid, pid, quantity, price) VALUES(3, 1 , 2, 1200);
INSERT INTO carts (uid, pid, quantity, price) VALUES(3, 2 , 1, 480);
INSERT INTO carts (uid, pid, quantity, price) VALUES(4, 10, 4, 249);
INSERT INTO carts (uid, pid, quantity, price) VALUES(5, 12, 2, 232);
INSERT INTO carts (uid, pid, quantity, price) VALUES(5, 9 , 5, 520);
INSERT INTO carts (uid, pid, quantity, price) VALUES(5, 5 , 3, 488);
INSERT INTO carts (uid, pid, quantity, price) VALUES(5, 1, 1, 1200);

SELECT * FROM carts order by id desc;

CREATE TABLE sales (
  id SERIAL PRIMARY KEY,
  uid INTEGER REFERENCES users(id) ON DELETE CASCADE,
  pid INTEGER REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL CHECK (quantity>0),
  price INTEGER NOT NULL CHECK(price>0)
);

SELECT * FROM sales order by id desc;
