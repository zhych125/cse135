--Drop all tables
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS purchase CASCADE;

--Create tables
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  age INTEGER,
  state TEXT,
  role  TEXT NOT NULL
);

CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  description TEXT
);

CREATE TABLE products (
  SKU TEXT NOT NULL PRIMARY KEY,
  name TEXT NOT NULL,
  category_id INTEGER REFERENCES categories(id) NOT NULL,
  price INTEGER NOT NULL CHECK (price>0)
);

CREATE TABLE cart (
  id SERIAL PRIMARY KEY,  
  user_id INTEGER NOT NULL REFERENCES users(id),
  SKU TEXT NOT NULL UNIQUE REFERENCES products(SKU),
  amount INTEGER NOT NULL CHECK(amount>0)  
);

CREATE TABLE purchase (
  id SERIAL PRIMARY KEY,
  customer_id INTEGER REFERENCES users(id) NOT NULL,
  SKU TEXT NOT NULL,
  price INTEGER NOT NULL CHECK(price>0),
  amount INTEGER NOT NULL CHECK (amount>0),
  credit_card VARCHAR(16) NOT NULL,
  timeStamp timestamp NOT NULL
);