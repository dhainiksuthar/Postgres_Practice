SELECT * FROM film;
SELECT * FROM payment;
-- Querying data  

SELECT * FROM address;
SELECT a.address FROM address AS a;
SELECT * FROM address ORDER BY last_update;
SELECT DISTINCT first_name FROM actor; 


-- Filtering data
SELECT * FROM actor WHERE first_name LIKE 'J%';
SELECT * FROM actor LIMIT 10;
SELECT * FROM payment ORDER BY amount DESC LIMIT 2 OFFSET 1 ;
SELECT * FROM payment ORDER BY amount DESC FETCH FIRST ROW ONLY;
SELECT * FROM ACTOR WHERE first_name IN ('Johnny', 'Christian');
SELECT * FROM payment WHERE amount BETWEEN 1 AND 2;
SELECT * FROM actor WHERE first_name LIKE 'J%';
SELECT * FROM address WHERE address2 IS NULL;

--Joins
SELECT * FROM actor;
SELECT * FROM film_actor;
SELECT * FROM film;
-- inner join
select film.title, actor.first_name, actor.last_name from film
	inner join film_actor on film.film_id = film_actor.film_id
		inner join actor on film_actor.actor_id = actor.actor_id;

-- left join
select * from film 
	left join film_actor on film.film_id = film_actor.film_id;

-- Right join
select * from film 
	right join film_actor on film.film_id = film_actor.film_id;
		
--Group By
SELECT customer_id FROM payment GROUP BY customer_id;

-- Having
SELECT customer_id, COUNT(customer_id) FROM payment GROUP BY customer_id HAVING COUNT(customer_id) > 20;

--Union
SELECT actor_id FROM actor UNION SELECT actor_id FROM film_actor;

--Intersect
SELECT actor_id FROM actor INTERSECT SELECT actor_id FROM film_actor;

--Except
SELECT actor_id FROM actor EXCEPT SELECT actor_id FROM film_actor;

--Grouping sets
SELECT customer_id, staff_id, sum(amount) FROM payment GROUP BY GROUPING SETS ((customer_id), (staff_id), (customer_id, staff_id) );

--Subquery
SELECT film_id, title, rental_rate FROM film WHERE rental_rate > (SELECT AVG (rental_rate) FROM film);

-- Any
SELECT title FROM film WHERE length >= ANY( SELECT MAX( length ) FROM film INNER JOIN film_category USING(film_id) GROUP BY  category_id );

--All
SELECT film_id, title, length FROM film WHERE length > ALL ( SELECT ROUND(AVG (length),2) FROM film GROUP BY rating ) ORDER BY length;

-- Exists
SELECT * FROM actor WHERE NOT EXISTS (SELECT actor_id FROM film_actor);

-- Common table expression
WITH temp_table AS(
SELECT customer_id, store_id, address_id FROM customer WHERE active = 1)
SELECT * FROM temp_table;

-- Insert
INSERT INTO film_actor(actor_id, film_id, last_update)
	VALUES(1000, 10000, '2006-02-15 10:05:03')
	
-- Update
UPDATE film SET release_year = 2007 WHERE film_id = 133;

--Delete
DELETE film_actor WHERE actor_id = 1000 AND film_id = 1000;
 
--Create table
CREATE TABLE accounts (
	user_id serial PRIMARY KEY,   
	username VARCHAR ( 50 ) UNIQUE NOT NULL,
	password VARCHAR ( 50 ) NOT NULL,
	email VARCHAR ( 255 ) UNIQUE NOT NULL,
	created_on TIMESTAMP NOT NULL,
        last_login TIMESTAMP 
);

-- Select into
SELECT id, title INTO book_title
FROM books;
SELECT * FROM book_title;

-- Delete sequence
DROP SEQUENCE my_sequence;

CREATE SEQUENCE my_sequence
START 10
INCREMENT 5
OWNED BY accounts.user_id;

-- Identity Column
CREATE TABLE colour(
colour_id INT GENERATED BY DEFAULT AS IDENTITY,
colour_name VARCHAR NOT NULL);

-- Rename Table
ALTER TABLE colour RENAME TO colours

-- Add column to table
ALTER TABLE colours ADD COLUMN test_column VARCHAR;

--Rename Column
ALTER TABLE colours
RENAME COLUMN test_column TO renamed_column;

--Drop Column
ALTER TABLE colours DROP COLUMN renamed_column;

--Truncate Table
TRUNCATE TABLE colours;

--Drop Table
DROP TABLE colours;

--Create temprary table
CREATE TEMP TABLE customers(customer_id INT);

--Drop temporary table
DROP TABLE customers;

--Create new table from existing table/ Copy table
CREATE TABLE new_table AS
SELECT actor_id FROM actor;

-- Primary Key
CREATE TABLE primary_table(
	id INTEGER PRIMARY KEY,
	data VARCHAR(50)
);

-- Add primary key in existing table
DROP TABLE primary_table;
CREATE TABLE primary_table(
id INTEGER,
data VARCHAR(20));

ALTER TABLE primary_table
ADD PRIMARY KEY (id);

-- Drop primary key
ALTER TABLE primary_table DROP CONSTRAINT primary_table_pkey;  

-- Create table with foreign key
CREATE TABLE foreign_table(
	fk_id INT,
	constraint foriegn_table_fkey
	FOREIGN KEY(fk_id) REFERENCES primary_table(id),
	details VARCHAR(20)
); 
DROP TABLE foreign_table

-- Alter foreign key
CREATE TABLE foreign_table(
	fk_id INT,
	details VARCHAR(10)
);
ALTER TABLE foreign_table
ADD CONSTRAINT
foreign_table_fkey
FOREIGN KEY(fk_id) REFERENCES primary_table(id);

-- Check constraints
CREATE TABLE temp(
	id INTEGER PRIMARY KEY,
	age INTEGER CHECK(age > 18)
);

-- Unique Constraints ???
CREATE TABLE equipment (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	equip_id VARCHAR(16) NOT NULL
 );
SELECT * FROM equipment;
CREATE UNIQUE INDEX CONCURRENTLY equipment_equip_id
ON equipment (equip_id);

ALTER TABLE equipment 
ADD CONSTRAINT unique_equip_id
UNIQUE USING INDEX equipment_equip_id;

-- Not null constraints
CREATE TABLE temp_1(
	id INTEGER PRIMARY KEY,
	data VARCHAR
);

ALTER TABLE temp_1
ALTER COLUMN data SET NOT NULL;

ALTER TABLE temp_1
ALTER COLUMN data DROP NOT NULL;

-- Numeric
CREATE TABLE numeric_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(5,2)
);

-- Date
CREATE TABLE documents(
	document_id SERIAL PRIMARY KEY,
	header_text VARCHAR(50) NOT NULL,
	Joining_date DATE DEFAULT CURRENT_DATE
);

INSERT INTO documents(header_text)
VALUES('Details');

SELECT * FROM documents;

DELETE FROM documents;

SELECT CURRENT_DATE;

SELECT NOW() :: DATE;

SELECT TO_CHAR(NOW() :: DATE, 'dd');

SELECT EXTRACT(YEAR FROM CURRENT_DATE);

-- Timestamp
SELECT CURRENT_TIMESTAMP;

--Interval
SELECT INTERVAL '6 years 5 months 4 days 3 hours 2 minutes';

SELECT EXTRACT (MINUTE FROM INTERVAL '6 years 5 months 4 days 3 hours 2 minutes');


-- Time
CREATE TABLE shifts (
	id SERIAL PRIMARY KEY,
	shift_name VARCHAR NOT NULL,
	start_at TIME NOT NULL,
	end_at TIME NOT NULL
);

INSERT INTO shifts(shift_name, start_at, end_at)
VALUES ('Morning', '08:00:00', '12:00:00'),
	   ('Night', '20:00:00', '24:00:00');
	   
SELECT * FROM shifts;
SELECT CURRENT_TIME, LOCALTIME;


-- UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
SELECT uuid_generate_v1(), uuid_generate_v1(), uuid_generate_v4(), uuid_generate_v4();

CREATE TABLE contacts(
	contact_id uuid DEFAULT uuid_generate_v4(),
	contact VARCHAR(10)
);

INSERT INTO contacts(contact)
VALUES(1234567890)
RETURNing *;
DROP TABLE IF EXISTS contacts;

-- Arrays
CREATE TABLE contacts(
	contact_id uuid DEFAULT uuid_generate_v4(),
	phones text []
);

INSERT INTO contacts(phones)
VALUES(ARRAY ['12', '40'])
RETURNING *;

SELECT * FROM contacts
WHERE phones[2] = '40';

--hstore
CREATE EXTENSION IF NOT EXISTS hstore;
CREATE TABLE books(
	id SERIAL PRIMARY KEY,
	title VARCHAR(100),
	attr hstore
);

INSERT INTO books(title, attr)
VALUES('Postgre tutorial',
	   ' 
	   "Key 3" => "Val 3",
	   "Key 2" => "Val 2"
	   '
	  )
RETURNING *;
SELECT * FROM books;

SELECT * FROM books
WHERE attr -> 'Key 3' = 'Val 3'

SELECT attr->'Key 3' FROM books;

-- Json
CREATE TABLE orders(
	id SERIAL NOT NULL PRIMARY KEY,
	info JSON NOT NULL
);
INSERT INTO orders(info)
VALUES('{"key" : "Val"}');

SELECT * FROM orders;

-- Case
SELECT * FROM film;

SELECT title,
	length,
	CASE
		WHEN length <= 50 THEN 'Short'
		WHEN length >= 50 AND length <= 120 THEN 'Medium'
		WHEN length > 120 THEN 'Long'
	END duration
	FROM film
	ORDER BY title;
	
-- Coalesce
SELECT COALESCE(NULL, NULL, 1, 2);

CREATE TABLE items_ (
	ID serial PRIMARY KEY,
	product VARCHAR (100) NOT NULL,
	price NUMERIC NOT NULL,
	discount NUMERIC
);
INSERT INTO items_ (product, price, discount)
VALUES
	('A', 1000 ,10),
	('B', 1500 ,20),
	('C', 800 ,5),
	('D', 500, NULL);
SELECT
	product,
	(price - COALESCE(discount,0)) AS net_price
FROM
	items_;

-- Null if 
SELECT NULLIF(10, 10);
SELECT NULLIF(10, 1); 
SELECT NULLIF(1, 10); 

-- Cast
SELECT CAST('100' AS INT);
SELECT CAST ('10.2' AS DOUBLE PRECISION);

-- Remove duplicate value from table
SELECT * FROM book_title;
SELECT title, COUNT(title) FROM book_title GROUP BY title HAVING COUNT(title) > 1;

DELETE FROM book_title a USING book_title b WHERE a.id < b.id AND a.title = b.title;

DROP TABLE IF EXISTS cars;
CREATE TABLE cars(
	id SERIAL PRIMARY KEY,
	model VARCHAR,
	brand VARCHAR
);

INSERT INTO cars(model, brand)
VALUES('EQS', 'Mercedes-Benz'),
	('Ioniq 5', 'Hyundai'),
	('Ioniq 5', 'Hyundai'),
	('Model S', 'Tesla'),
	('Model S', 'Tesla');

SELECT * FROM cars ORDER BY model, brand;

INSERT INTO cars(model, brand) VALUES('Ioniq 5', 'Hyundai'),
									 ('Model S', 'Tesla');

-- Delete using unique identifier
DELETE FROM cars WHERE id IN (
	SELECT max(id) FROM cars
	GROUP BY model, brand HAVING COUNT(*) > 1);
	
-- Delete using self join
DELETE FROM cars WHERE id in(
SELECT c1.id FROM cars c1 JOIN cars c2 ON c1.model = c2.model AND c1.brand = c2.brand AND c1.id < c2.id);

--Delete using min
DELETE FROM cars WHERE id NOT IN (
SELECT min(id) as id FROM cars GROUP BY model,brand);


-- Generate random number
SELECT RANDOM();
SELECT floor(RANDOM()*10 + 1);
-- Random number between 10 and 100
SELECT FLOOR(RANDOM()*(100-10+1) + 10);

