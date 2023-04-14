SELECT * FROM accounts;

SELECT E'\'Hi';

SELECT $$This '  is / phadmin$$;

SELECT $tag$This '  is / pg admin$tag$;

-- Block
do
	$$
		DECLARE
			film_count INTEGER;
		BEGIN
			SELECT COUNT(*) INTO film_count FROM actor;
			RAISE NOTICE E'Count : %', film_count;
		END; 
	$$

-- Time
DO
	$$
		DECLARE
			created_at TIME = clock_timestamp();
		BEGIN
			RAISE NOTICE E'Created Time : %', created_at;
			PERFORM PG_SLEEP(5);
			RAISE NOTICE 'clock_timestamp() : %', clock_timestamp();
			RAISE NOTICE E'DIfferet between time : %', EXTRACT(SECOND FROM (clock_timestamp() - created_at));
		END;
	$$


-- %type
DO
	$$
		DECLARE 
			actor_first_name actor.first_name%type;
		BEGIN
			SELECT first_name INTO actor_first_name FROM actor;
			RAISE NOTICE '%', actor_first_name;
		END;
	$$

-- Subblock
do $$
<<outer_block>>
	
		DECLARE
			counter INTEGER = 0;
		BEGIN
			counter = counter + 1;
			RAISE NOTICE 'Counter variable current value is : %', counter;
			DECLARE
				counter INT = 0;
				BEGIN
					RAISE NOTICE E'Counter variable in subblock is : %', counter;
					RAISE NOTICE 'Counter block value in outer block is : %', outer_block.counter;
				END;
			RAISE NOTICE 'Counter in the outer block is %', counter;
		END; 
	$$ 

-- Row types
DO
	$$
		DECLARE 
			rec actor%ROWTYPE;
		BEGIN
			SELECT * INTO rec FROM actor;
			RAISE NOTICE '%', rec;
		END;
	$$

-- Record variable
DO
	$$
		DECLARE 
			rec RECORD;
		BEGIN
			SELECT * INTO rec FROM actor;
			RAISE NOTICE '%', rec;
		END;
	$$

-- Record variable in loop
DO
	$$
		DECLARE 
			rec RECORD;
		BEGIN
			FOR rec in SELECT * FROM actor
			LOOP
			RAISE NOTICE '%', rec;
			END LOOP;
		END;
	$$
;

select * from actor;
-- Assert
DO
	$$
		DECLARE 
			film_count INT;
		BEGIN
			select count(*) into film_count from film;
			RAISE NOTICE '%', film_count;
			ASSERT film_count > 0 , 'Film not found';
		END;
	$$


DO
	$$
		DECLARE 
			film_count INT;
		BEGIN
			select count(*) into film_count from film;
			RAISE NOTICE '%', film_count;
			ASSERT film_count > 1000 , 'Not more than 100 record found';
		END;
	$$


-- If else
DO
	$$
	DECLARE
		num INTEGER = 0;
	BEGIN
		IF num = 0 THEN RAISE NOTICE 'Number is 0';
		ELSIF num < 0 THEN RAISE NOTICE 'Number is less than 0';
		ELSE RAISE NOTICE 'Number is greater than 0';
		END IF;
	END
	$$

-- Case
CREATE TABLE student_marks(
	student_id INT PRIMARY KEY,
	marks INT
);
INSERT INTO student_marks(student_id, marks) VALUES(1, 95), (2, 75), (3, 45);
SELECT * FROM student_marks;

DO
$$
	DECLARE 
		rec student_marks.marks%type;
		ans VARCHAR(10);
	BEGIN
		FOR rec in SELECT marks FROM student_marks
		LOOP
			CASE 
				WHEN rec > 90 THEN ans = 'a+';
				WHEN rec > 80 THEN ans = 'a';
				WHEN rec > 70 THEN ans = 'b';
				WHEN rec > 60 THEN ans = 'b+';
				WHEN rec > 50 THEN ans = 'c';
				WHEN rec > 40 THEN ans = 'd';
				ELSE ans = 'fail';
			END CASE;
			RAISE NOTICE 'Marks : %, Grade : %', rec, ans;
		END LOOP;

	END;
$$

-- Loop
DO
	$$
	DECLARE 
		n INTEGER = 5;
	BEGIN
		LOOP
			EXIT WHEN n = 0;
			RAISE NOTICE '%', n;
			n = n - 1;
		END LOOP;
	END;
	$$

-- While Loop
Do
	$$
		DECLARE
			n INTEGER = 0;
		BEGIN
			WHILE n < 5 LOOP
				RAISE NOTICE '%', n;
				n = n + 1;
			END LOOP;
		END;
	$$

-- For Loop
DO
	$$
		BEGIN
			FOR n in REVERSE 5..1 LOOP
				RAISE NOTICE '%', n;
			END LOOP;
		END;
	$$

DO
	$$
		BEGIN
			FOR n in REVERSE 10..1 BY 2 LOOP
				RAISE NOTICE '%', n;
			END LOOP;
		END;
	$$

DO
	$$
		DECLARE 
			n RECORD;
			query text;
		BEGIN
-- 			query = 'SELECT * FROM category';
-- 			FOR n in EXECUTE query LOOP
			FOR n in SELECT * FROM category LOOP
				RAISE NOTICE '%', n;
			END LOOP;
		END;
	$$
	
-- Exit
DO
	$$
		DECLARE
			n INTEGER = 1;
		BEGIN
			WHILE n < 10 LOOP
				RAISE NOTICE '%', n;
				EXIT WHEN n = 5;
				n = n + 1;
			END LOOP;
		END;
	$$

-- Continue
DO
	$$
		DECLARE
			n INTEGER = 1;
		BEGIN
			WHILE n < 10 LOOP
				n = n + 1;
				CONTINUE WHEN mod(n, 2) = 0;
				RAISE NOTICE '%', n;
			END LOOP;
		END;
	$$
	
	
--Create function with different way
CREATE OR REPLACE FUNCTION add(a int,b int) RETURNS VOID AS
'
	DECLARE 
		ans INT;
	BEGIN
		ans := a + b;
		RAISE NOTICE ''First number is : %'',a;
		RAISE NOTICE ''Second number is : %'',b;
		RAISE NOTICE ''Answer is : %'',ans;
	END;
' LANGUAGE plpgsql;

SELECT add(10, 20);

--Function that return two value
CREATE OR REPLACE FUNCTION sumproduct(a int, b int, OUT c int, OUT d int) AS
$$
	BEGIN
		c = a + b;
		d = a * b;
	END;
$$ LANGUAGE plpgsql;

-- Drop function 
DROP FUNCTION add(int, int);

-- Function call
SELECT add(10, 20);
SELECT sumproduct(10, 20);

--Rename variable in function
a alias for $1;

--If Else
CREATE OR REPLACE FUNCTION ispositive(a INT, OUT ans TEXT) AS
$$
	BEGIN
		IF a > 0 THEN ans = 'Positive';
		ELSEIF a < 0 THEN ans = 'Negative';
		ELSE ans = "Zero";
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

SELECT ispositive(24), ispositive(-23);

-- Function in pl/pqsql
CREATE OR REPLACE FUNCTION add(int, int) RETURNS INT AS
'
	DECLARE  
		ans INT;
	BEGIN
		ans := $1 + $2;
		RETURN ans;
	END;
' LANGUAGE plpgsql;

-- Inout
CREATE OR REPLACE FUNCTION swap(INOUT x INT, INOUT y INT) AS
$$
	BEGIN
		SELECT x,y INTO y,x;
	END;
$$ LANGUAGE PLPGSQL;
SELECT * FROM swap(10, 20);

--Function for finding factorial number
CREATE OR REPLACE FUNCTION fact(n INT) RETURNS INT AS
'
	DECLARE 
		ans int := 1;
	BEGIN
		while n > 0 LOOP
			ans = ans * n;
			n = n - 1;
		END LOOP;
	
		FOR i in 0 .. n LOOP
			ans = ans * i;
			i = i + 1;
	    END LOOP;
	RETURN ans;
	END;
' LANGUAGE PLPGSQL;

SELECT fact(5);
DROP FUNCTION fact(int);

--Function for finding factorial number FOR LOOP
CREATE OR REPLACE FUNCTION fact(n INT) RETURNS INT AS
'
	DECLARE 
		ans int := 1;
	BEGIN 
		FOR i in 1 .. n LOOP
			ans = ans * i;
	    END LOOP;
	RETURN ans;
	END;
' LANGUAGE PLPGSQL;
SELECT fact(5);

-- Function Overloading
CREATE OR REPLACE FUNCTION actor_details(a_actor_id INT, OUT a_first_name TEXT) AS
$$
	BEGIN
		SELECT first_name INTO a_first_name FROM actor WHERE actor_id = a_actor_id;
	END;
$$ LANGUAGE PLPGSQL;

CREATE FUNCTION actor_details(a_actor_id INT, OUT a_first_name TEXT, a_last_name TEXT) AS
$$
	BEGIN
		SELECT first_name, last_name INTO a_first_name, a_last_name FROM actor WHERE actor_id = a_actor_id AND last_name = a_last_name;
	END;
$$ LANGUAGE PLPGSQL; 
SELECT * FROM actor_details(10);
SELECT * FROM actor_details(10, 'Gable');

select * from actor where actor_id = 10;

-- Return table in query
CREATE OR REPLACE FUNCTION get_film(p_pattern VARCHAR) 
RETURNS table(film_title VARCHAR,
			  film_release_year INT
			 ) LANGUAGE PLPGSQL AS
$$
	BEGIN
	RETURN QUERY  
			SELECT 
				title, release_year :: INT FROM film WHERE title LIKE p_pattern;
	END;
$$
SELECT * FROM get_film('Gl%');
SELECT * FROM film;

-- Exception no data
DO
	$$
	DECLARE 
		rec record;
	BEGIN
		SELECT * INTO STRICT rec FROM accounts;
		
		EXCEPTION
		WHEN no_data_found THEN
			RAISE EXCEPTION 'No data found';
	END;
	$$
	
	
-- Exception too many rows
-- If it is more than one than it is too many
DO
	$$
	DECLARE 
		rec record;
	BEGIN
		SELECT * INTO STRICT rec FROM actor WHERE actor_id <= 2;
		
		EXCEPTION
		WHEN TOO_MANY_ROWS THEN
			RAISE EXCEPTION 'To many rows';
	END;
	$$


-- Procedures
CREATE TABLE accounts_details(
	id SERIAL PRIMARY KEY,
	name VARCHAR,
	amount INT
);
INSERT INTO accounts_details(name, amount)
	VALUES('alex', 10000),
		  ('costa', 10000);	
SELECT * FROM accounts_details;

DROP PROCEDURE IF EXISTS transfer;
CREATE OR REPLACE PROCEDURE transfer(sender INT, receiver INT, balance INT)
AS
$$
	DECLARE
		sender_amount INT;
		receiver_amount INT;
	BEGIN
-- 	sender_amount = SELECT amount FROM accounts_details WHERE id = sender;
-- 	receiver_amount = SELECT amount FROM accounts_details WHERE id = receiver;
	
	SELECT amount INTO sender_amount FROM accounts_details WHERE id = sender;
	SELECT amount INTO receiver_amount FROM accounts_details WHERE id = receiver;
	
	UPDATE accounts_details SET amount = sender_amount - balance WHERE id = sender;
	UPDATE accounts_details SET amount = receiver_amount + balance WHERE id = receiver;
	
	COMMIT;
	
	END;
$$ LANGUAGE PLPGSQL;

CALL transfer(1, 2, 100);
SELECT * FROM accounts_details;

-- Split part
SELECT SPLIT_PART('account details', ' ',1);
SELECT SPLIT_PART('account details', ' ',2);

-- Cursor

open my_cursor for 
	select * from city ;
	
CREATE OR REPLACE FUNCTION get_film_titles(p_year INTEGER)
	RETURNS TEXT AS
	$$
		DECLARE 
			rec_film RECORD;
			titles TEXT = '';
			cur_films CURSOR
				FOR SELECT title, release_year FROM film WHERE release_year = p_year;
		BEGIN
			OPEN cur_films;
			
			LOOP
				FETCH cur_films INTO rec_film;
				EXIT WHEN NOT FOUND;
				IF rec_film.title LIKE 'Gr%' THEN 
					RAISE NOTICE '%', rec_film; 
					titles := titles || ',' || rec_film.title || ':' || rec_film.release_year;
				END IF;
			END LOOP;
			
			CLOSE cur_films;
			RETURN titles;
	END;
	$$ LANGUAGE PLPGSQL;
	
select get_film_titles(2006);

-- Refcursor
CREATE OR REPLACE FUNCTION showtable() RETURNS VOID AS
$$
	DECLARE
		rec RECORD;
		c1 REFCURSOR;
	BEGIN
		OPEN c1 FOR SELECT * FROM cars;
-- 		MOVE RELATIVE 3 FROM c1;
		FETCH NEXT FROM c1 INTO rec;
		RAISE NOTICE 'Id -> % Model -> % Brand -> %', rec.Id, rec.model, rec.brand;
		CLOSE c1;
	END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM showtable();

SELECT * FROM film WHERE release_year = 2006;
-- Create trigger function
DROP TABLE IF EXISTS employees;

CREATE TABLE employees(
   id INT GENERATED ALWAYS AS IDENTITY,
   first_name VARCHAR(40) NOT NULL,
   last_name VARCHAR(40) NOT NULL,
   PRIMARY KEY(id)
);
CREATE TABLE employee_audits (
   id INT GENERATED ALWAYS AS IDENTITY,
   employee_id INT NOT NULL,
   last_name VARCHAR(40) NOT NULL,
   changed_on TIMESTAMP(6) NOT NULL
);
 
CREATE OR REPLACE FUNCTION log_last_name_changes()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
	$$
		BEGIN
			RAISE NOTICE 'NEW : %, OLD : %', NEW.last_name, OLD.last_name;
			INSERT INTO employee_audits(employee_id, last_name, changed_on)
						VALUES(OLD.id, OLD.last_name, CURRENT_TIMESTAMP);
		    RETURN NEW;
		END;
	$$
	
CREATE OR REPLACE TRIGGER log_last_name_changes
	BEFORE UPDATE
	ON employees
	FOR EACH ROW
	EXECUTE PROCEDURE log_last_name_changes();
	
INSERT INTO employees(first_name, last_name)
			VALUES('John', 'Doe'),
				  ('Lily', 'Bush'); 

UPDATE employees SET last_name = 'Wick' WHERE id = 2;

SELECT * FROM employees;
SELECT * FROM employee_audits;

-- Drop Trigger
DROP TRIGGER IF EXISTS log_last_name_changes ON employees CASCADE;

-- Rename Trigger
ALTER TRIGGER log_last_name_changes ON employees
RENAME TO last_log_name_changes;

-- Disable specific trigger
ALTER TABLE employees
DISABLE TRIGGER last_log_name_changes;

-- Disable all triggers
ALTER TABLE employees
DISABLE TRIGGER ALL;

-- Enable trigger
ALTER TABLE employees
ENABLE TRIGGER last_log_name_changes;

-- Aggregate Functions

-- Count films who belongs to category 6;
SELECT COUNT(*) FROM film INNER JOIN film_category ON film.film_id = film_category.film_id WHERE category_id = 6;

-- Average 
SELECT AVG(rental_duration) FROM film WHERE rating = 'R';

-- Max
SELECT MAX(rental_duration) FROM film WHERE rating = 'R';

-- Min
SELECT MIN(rental_duration), rating FROM film GROUP BY rating;

-- Windows Function
DROP TABLE IF EXISTS product_groups CASCADE;
DROP TABLE IF EXISTS products;
CREATE TABLE product_groups (
	group_id serial PRIMARY KEY,
	group_name VARCHAR (255) NOT NULL
);

CREATE TABLE products (
	product_id serial PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	price DECIMAL (11, 2),
	group_id INT NOT NULL,
	FOREIGN KEY (group_id) REFERENCES product_groups (group_id)
);
INSERT INTO product_groups (group_name)
VALUES
	('Smartphone'),
	('Laptop'),
	('Tablet');

INSERT INTO products (product_name, group_id,price)
VALUES
	('Microsoft Lumia', 1, 200),
	('HTC One', 1, 400),
	('Nexus', 1, 500),
	('iPhone', 1, 900),
	('HP Elite', 2, 1200),
	('Lenovo Thinkpad', 2, 700),
	('Sony VAIO', 2, 700),
	('Dell Vostro', 2, 800),
	('iPad', 3, 700),
	('Kindle Fire', 3, 150),
	('Apple', 2, 600),
	('Samsung Galaxy Tab', 3, 200);
	

-- Over
SELECT product_name, group_name, AVG(price) OVER(PARTITION BY group_name) FROM products INNER JOIN product_groups USING(group_id);

-- Row number
SELECT product_name, group_name, price, ROW_NUMBER() OVER(PARTITION BY group_name ORDER BY price DESC) FROM products INNER JOIN product_groups USING(group_id);

-- Row Number
SELECT product_name, group_name, price, ROW_NUMBER() OVER(PARTITION BY group_name ORDER BY price DESC) FROM products INNER JOIN product_groups USING(group_id);

-- Dense Rank Will not skip number
SELECT product_name, group_name, price, DENSE_RANK() OVER(PARTITION BY group_name ORDER BY price DESC) FROM products INNER JOIN product_groups USING(group_id);

-- Rank Will skip number
SELECT product_name, group_name, price, RANK() OVER(PARTITION BY group_name ORDER BY price DESC) FROM products INNER JOIN product_groups USING(group_id);

-- First Value
SELECT product_name, group_name, price, FIRST_VALUE(price) OVER(PARTITION BY group_name ORDER BY price DESC) AS Highest_price_per_grp FROM products INNER JOIN product_groups USING(group_id);

-- Last Value
SELECT product_name, group_name, price, LAST_VALUE(price) OVER(PARTITION BY group_name ORDER BY price RANGE BETWEEN UNBOUNDED PRECEDING
		AND UNBOUNDED FOLLOWING) AS Highest_price_per_grp FROM products INNER JOIN product_groups USING(group_id);

-- Lag
SELECT product_name, group_name, price, LAG(price, 1) OVER(PARTITION BY group_name ORDER BY price DESC) AS Prev_high_price FROM products INNER JOIN product_groups USING(group_id);

-- Lead
SELECT product_name, group_name, price, LEAD(price, 1) OVER(PARTITION BY group_name ORDER BY price DESC) AS Next_low_price_per_grp FROM products INNER JOIN product_groups USING(group_id);

-- Cum dist
SELECT product_name, group_name, price, CUME_DIST() OVER(PARTITION BY group_name ORDER BY price) FROM products INNER JOIN product_groups USING(group_id); 

-- NTile
SELECT product_name, group_id, NTILE(3) OVER(ORDER BY price) FROM products;

-- nth value
SELECT product_name, group_id, NTH_VALUE(product_name, 2) OVER(PARTITION BY group_name ORDER BY price RANGE BETWEEN UNBOUNDED PRECEDING AND 
            UNBOUNDED FOLLOWING) FROM products INNER JOIN product_groups USING(group_id);

-- Percent_rank
SELECT product_name, price, product_id, PERCENT_RANK() OVER(ORDER BY price) FROM products; 

-- Age
SELECT AGE(CURRENT_DATE, TIMESTAMP '2019-07-04');
SELECT AGE('2017-01-01','2011-06-24');


-- Clock timestamp Return the current date and time which changes during statement execution
SELECT CLOCK_TIMESTAMP();

-- Current timestamp Return the current date and time with time zone at which the current transaction starts
SELECT CURRENT_TIMESTAMP;

-- Current date
SELECT CURRENT_DATE;

-- Current time
SELECT CURRENT_TIME;

-- Date part
SELECT date_part('century',TIMESTAMP '2017-01-01');

SELECT date_part('millennium',now());

-- Extract
SELECT EXTRACT(YEAR FROM TIMESTAMP '2023-12-01');

-- Localtime
SELECT LOCALTIME;
SELECT LOCALTIMESTAMP;

SELECT NOW() + INTERVAL '1 DAY';

SELECT 
    TIMEOFDAY(), 
    pg_sleep(5), 
    TIMEOFDAY();
	
-- to date	
SELECT TO_DATE('2017/02/20', 'YYYY/MM/DD');

-- to timestamp
SELECT TO_TIMESTAMP(
    '2017-03-31 9:30:20',
    'YYYY-MM-DD HH:MI:SS'
);

-- Asci
SELECT ASCII('A'), ASCII('a');

-- Chr
SELECT CHR(65), CHR(97);

-- Concat
SELECT CONCAT('John', ' ' ,'Wick'), CONCAT_WS(',', 'John', 'Wick');

-- Format
SELECT FORMAT('John %s', 'Wick');
SELECT FORMAT('|%s|', 'one'), FORMAT('|%100s|', 'one'), FORMAT('|%-100s|', 'one');