-- 1. CREATE DAABASE SYNTAX
CREATE DATABASE Exercise;

-- 2. CREATE SCHEMA SYNTAX
CREATE SCHEMA system;

-- 3. create table name test and test1 (with column id,  first_name, last_name, school, percentage, status (pass or fail),pin, created_date, updated_date)
-- define constraints in it such as Primary Key, Foreign Key, Noit Null...
-- apart from this take default value for some column such as cretaed_date

SELECT current_database();

CREATE TABLE test (
	column_id INT PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
	school VARCHAR(100) NOT NULL,
	percentage NUMERIC(5, 2) NOT NULL,
	status VARCHAR(10) NOT NULL,
	pin VARCHAR(10) NOT NULL,
	created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_date DATE
);


SELECT * INTO test1 FROM test;
SELECT * FROM test;

-- 4. Create film_cast table with film_id,title,first_name and last_name of the actor.. (create table from other table)
SELECT * FROM film;
SELECT * FROM actor;
SELECT * FROM film_actor;


SELECT film_actor.film_id, title, first_name, last_name
INTO film_cast
FROM actor 
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id;

SELECT * FROM film_cast;

-- 5. drop table test1
DROP TABLE test1;

-- 6. what is temproray table ? what is the purpose of temp table ? create one temp table 
CREATE TEMP TABLE temp_table(
	id INT,
	data_ VARCHAR(50)
);

-- 7	difference between delete and truncate ? 
-- The DELETE command is used to delete particular records from a table. The TRUNCATE command is used to delete the complete data from the table.


-- 8. rename test table to student table
ALTER TABLE test
RENAME TO student_table;

-- 9. add column in test table named city 
ALTER TABLE student_table
ADD COLUMN city VARCHAR(50);

-- 10. change data type of one of the column of test table
ALTER TABLE student_table
ALTER COLUMN pin SET DATA TYPE INT USING pin :: INTEGER;

-- 11. drop column pin from test table 
ALTER TABLE student_table
DROP COLUMN pin;

-- 12.  rename column city to location in test table
ALTER TABLE student_table
RENAME COLUMN city TO location;

-- 13. Create a Role with read only rights on the database.
CREATE ROLE test 
LOGIN
PASSWORD 'root';

SET ROLE postgres;
SELECT * FROM student_table;

GRANT SELECT 
ON student_table
TO test;

-- 14. Create a role with all the write permission on the database.
CREATE ROLE test2
LOGIN
PASSWORD 'root';

GRANT INSERT, UPDATE 
ON ALL TABLES
IN SCHEMA PUBLIC
TO test2;

-- 15.Create a database user who can only read the data from the database.
CREATE ROLE test11;
GRANT SELECT ON ALL TABLES IN SCHEMA public To test11;

-- 16	Create a database user who can read as well as write data into database.
CREATE ROLE test22;
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA public To test22;

-- 17	Create an admin role who is not superuser but can create database and  manage roles.
CREATE ROLE test33 WITH NOSUPERUSER CREATEDB;

-- 18	Create user whoes login credentials can last until 1st June 2023
CREATE ROLE test44 WITH
LOGIN
PASSWORD 'root'
VALID UNTIL '2023-03-21';

-- 19. List all unique film’s name. 
SELECT DISTINCT title 
FROM film;

-- 20. List top 100 customers details.
SELECT * 
FROM customer 
LIMIT 100;

-- 21. List top 10 inventory details starting from the 5th one.
SELECT * 
FROM inventory 
LIMIT 10 OFFSET 4;

-- 22. find the customer's name who paid an amount between 1.99 and 5.99.
SELECT 
	first_name, last_name 
FROM customer 
INNER JOIN payment USING(customer_id) 
WHERE amount BETWEEN 1.99 AND 5.99;

--  23. List film's name which is staring from the A.
SELECT 
	title 
FROM film 
WHERE title LIKE 'A%';

-- 24. List film's name which is end with "a"
SELECT 
	title 
FROM film 
WHERE title LIKE '%a';

-- 25. List film's name which is start with "M" and ends with "a"
SELECT title 
FROM film 
WHERE title LIKE 'M%a';

-- 26. List all customer details which payment amount is greater than 40. (USING EXISTs)
SELECT * 
FROM customer 
WHERE EXISTS (
	SELECT customer_id 
	FROM payment 
	WHERE amount > 40
);

-- 27. List Staff details order by first_name.
SELECT * 
FROM staff 
ORDER BY first_name;

-- 28. List customer's payment details (customer_id,payment_id,first_name,last_name,payment_date)
SELECT 
	c.customer_id, p.payment_id, c.first_name, c.last_name, p.payment_date 
FROM payment AS p 
INNER JOIN customer AS c USING(customer_id);

-- 29. Display title and it's actor name.
SELECT 
	title, first_name, last_name 
FROM film 
INNER JOIN film_actor USING(film_id)
INNER JOIN actor USING(actor_id);

-- 30. List all actor name and find corresponding film id
SELECT 
	first_name, last_name, film_id 
FROM actor 
INNER JOIN film_actor USING(actor_id)

-- 31. List all addresses and find corresponding customer's name and phone.
SELECT 
	first_name, last_name,address, phone 
FROM address INNER JOIN customer USING(address_id);

-- 32. Find Customer's payment (include null values if not matched from both tables)(customer_id,payment_id,first_name,last_name,payment_date)
SELECT 
	customer_id, payment_id, first_name, last_name, payment_date 
FROM customer 
FULL OUTER JOIN payment USING(customer_id);

-- 33. List customer's address_id. (Not include duplicate id )
SELECT DISTINCT address_id 
FROM address;

-- 34. List customer's address_id. (Include duplicate id )
SELECT address_id 
FROM address;

-- 35. List Individual Customers' Payment total.
SELECT 
	customer_id, first_name, last_name, SUM(amount) 
FROM customer 
INNER JOIN payment USING(customer_id) 
GROUP BY customer_id;

-- 36. List Customer whose payment is greater than 80.

SELECT 
	customer_id, first_name, last_name, SUM(amount) 
FROM customer 
INNER JOIN payment USING(customer_id) 
GROUP BY customer_id 
HAVING(SUM(amount) > 80);

-- 37. Shop owners decided to give  5 extra days to keep  their dvds to all the rentees who rent the movie before June 15th 2005 make according changes in db
UPDATE rental 
SET return_date = return_date + INTERVAL '5 day' 
WHERE rental_date < '2005-06-15';

-- 38. Remove the records of all the inactive customers from the Database

SELECT constraint_name FROM information_schema.table_constraints
    WHERE table_name='payment';

ALTER TABLE payment
DROP CONSTRAINT payment_customer_id_fkey;
ALTER TABLE rental
DROP CONSTRAINT rental_customer_id_fkey;

ALTER TABLE payment
ADD CONSTRAINT payment_customer_id_fkey FOREIGN KEY(customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE;

ALTER TABLE rental
ADD CONSTRAINT rental_customer_id_fkey FOREIGN KEY(customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE;

DELETE FROM customer WHERE active = 0;

-- 39. count the number of special_features category wise.... total no.of deleted scenes, Trailers etc....

SELECT name, UNNEST(special_features), COUNT(*) FROM film
JOIN film_category USING(film_id)
JOIN category USING(category_id)
GROUP BY name, UNNEST(special_features)
ORDER BY name;

SELECT DISTINCT special_features FROM film;

-- 40. count the numbers of records in film table
SELECT COUNT(*) FROM film;

-- 41	count the no.of special fetures which have Trailers alone, Trailers and Deleted Scened both etc....
SELECT special_features, COUNT(*) FROM film GROUP BY special_features;

-- 42. use CASE expression with the SUM function to calculate the number of films in each rating:
SELECT DISTINCT rating FROM film;

SELECT 
	SUM(CASE WHEN rating = 'R' THEN 1 ELSE 0 END) AS R,
	SUM(CASE WHEN rating = 'NC-17' THEN 1 ELSE 0 END) AS NC_17,
	SUM(CASE WHEN rating = 'G' THEN 1 ELSE 0 END) AS G,
	SUM(CASE WHEN rating = 'PG' THEN 1 ELSE 0 END) AS PG,
	SUM(CASE WHEN rating = 'PG-13' THEN 1 ELSE 0 END) AS PG_13
FROM film;

-- 43. Display the discount on each product, if there is no discount on product Return 0
SELECT id, product, price, COALESCE(discount, 0) 
FROM items;

-- 44. Return title and it's excerpt, if excerpt is empty or null display last 6 letters of respective body from posts table
SELECT title,  
CASE
	WHEN excerpt <> '' THEN excerpt
	ELSE RIGHT(body, 6)
END
FROM posts;

-- 45. Can we know how many distinct users have rented each genre? if yes, name a category with highest and lowest rented number  ..

SELECT 
	name, COUNT(DISTINCT customer_id) 
FROM rental
JOIN payment USING(customer_id)
JOIN inventory USING(inventory_id)
JOIN film USING(film_id)
JOIN film_category USING(film_id)
JOIN category USING(category_id)
GROUP BY name;


-- 46. "Return film_id,title,rental_date and rental_duration according to rental_rate need to define rental_duration such as 
-- rental rate  = 0.99 --> rental_duration = 3
-- rental rate  = 2.99 --> rental_duration = 4
-- rental rate  = 4.99 --> rental_duration = 5
-- otherwise  6"
SELECT 
	film_id, title, rental_date, 
	CASE 
		WHEN rental_rate = 0.99 THEN 3
		WHEN rental_rate = 2.99 THEN 4
		WHEN rental_rate = 4.99 THEN 5
		ELSE 6
	END AS rental_duration
FROM rental
JOIN inventory USING(inventory_id)
JOIN film USING(film_id);


-- 47. Find customers and their email that have rented movies at priced $9.99.
SELECT customer.customer_id, customer.email, payment.amount FROM rental
JOIN payment USING(rental_id)
JOIN customer ON payment.customer_id = customer.customer_id
WHERE payment.amount = 9.99;

-- 48. Find customers in store #1 that spent less than $2.99 on individual rentals, but have spent a total higher than $5.
SELECT customer_id, first_name, last_name, SUM(amount) 
FROM payment
JOIN customer USING(customer_id)
WHERE amount < 2.99 AND customer.store_id = 1
GROUP BY customer_id
HAVING(SUM(amount) > 5);

-- 49. Select the titles of the movies that have the highest replacement cost.
SELECT title, replacement_cost FROM film WHERE replacement_cost = (
SELECT max(replacement_cost) FROM film);

-- 50. list the cutomer who have rented maximum time movie and also display the count of that... (we can add limit here too---> list top 5 customer who rented maximum time)
SELECT 
	customer_id, first_name, last_name, AGE(return_date, rental_date) AS rented_time 
FROM 
	rental 
JOIN 
	customer USING(customer_id) 
ORDER BY 
	rented_time DESC NULLS LAST
LIMIT 5;



SELECT 
	customer_id, first_name, last_name, SUM(AGE(return_date, rental_date)) AS total_rented_time
FROM 
	rental
JOIN 
	customer USING(customer_id)
GROUP BY 
	customer_id
ORDER BY 
	total_rented_time DESC NULLS LAST
LIMIT 5;

-- 51. Display the max salary for each department
SELECT dept_name, max(salary) FROM employee GROUP BY dept_name;
SELECT * FROM employee;

-- 52. "Display all the details of employee and add one extra column name max_salary (which shows max_salary dept wise) 

/*
emp_id	 emp_name   dept_name	salary   max_salary
120	     ""Monica""	""Admin""		5000	 5000
101		 ""Mohan""	""Admin""		4000	 5000
116		 ""Satya""	""Finance""	6500	 6500
118		 ""Tejaswi""	""Finance""	5500	 6500

--> like this way if emp is from admin dept then , max salary of admin dept is 5000, then in the max salary column 5000 will be shown for dept admin
*/"

SELECT emp_name, dept_name, salary, max(salary) OVER(PARTITION BY dept_name) AS max_salary FROM employee;

/* 53. "Assign a number to the all the employee department wise  
such as if admin dept have 8 emp then no. goes from 1 to 8, then if finance have 3 then it goes to 1 to 3

emp_id   emp_name       dept_name   salary  no_of_emp_dept_wsie
120		""Monica""		""Admin""		5000	1
101		""Mohan""		    ""Admin""		4000	2
113		""Gautham""		""Admin""		2000	3
108		""Maryam""		""Admin""		4000	4
113		""Gautham""		""Admin""		2000	5
120		""Monica""		""Admin""		5000	6
101		""Mohan""		    ""Admin""		4000	7
108		""Maryam""	    ""Admin""		4000	8
116		""Satya""	      	""Finance""	6500	1
118		""Tejaswi""		""Finance""	5500	2
104		""Dorvin""		""Finance""	6500	3
106		""Rajesh""		""Finance""	5000	4
104		""Dorvin""		""Finance""	6500	5
118		""Tejaswi""		""Finance""	5500	6" */

SELECT 
	emp_id, 
	emp_name, 
	dept_name, 
	salary, 
	ROW_NUMBER() OVER(PARTITION BY dept_name) AS no_of_emp_dept_wise 
FROM employee;

-- 54. Fetch the first 2 employees from each department to join the company. (assume that emp_id assign in the order of joining)
SELECT * FROM (
				SELECT 
					emp_id, 
					emp_name, 
					dept_name, 
					ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY emp_id) 
				FROM employee
			) as a
		WHERE row_number <= 2;

-- 55. Fetch the top 3 employees in each department earning the max salary.
SELECT * FROM (
				SELECT 
					emp_id, 
					emp_name, 
					dept_name, 
					salary,
					ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY salary DESC) 
				FROM employee
			) as a
		WHERE row_number <= 3;
		
-- 56. write a query to display if the salary of an employee is higher, lower or equal to the previous employee.
SELECT emp_id, emp_name, dept_name, salary, lag,
	CASE
		WHEN salary = lag THEN 'Equal'
		WHEN salary > lag THEN 'Higher'
		WHEN salary < lag THEN 'Lower'
	END AS compare_with_previous
	FROM
	(SELECT emp_id, emp_name, dept_name, salary, 
	LAG(salary, 1) OVER(ORDER BY emp_id) 
	FROM employee ) a;
	
-- 57. Get all title names those are released on may DATE
SELECT title
FROM film
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id) 
WHERE EXTRACT(MONTH FROM rental_date) = 5;


-- 58. get all Payments Related Details from Previous week
SELECT * 
FROM payment 
WHERE EXTRACT(WEEK FROM payment_date) = (
	SELECT 
	EXTRACT(WEEK FROM max(payment_date))-1 
	FROM payment
);

-- 59. Get all customer related Information from Previous Year
SELECT * 
FROM customer 
WHERE EXTRACT(YEAR FROM create_date) = (
	SELECT 
	EXTRACT(YEAR FROM MAX(create_date))-1 
	FROM customer
);

-- 60. What is the number of rentals per month for each store?
SELECT 
	store_id, EXTRACT(MONTH FROM rental_date) AS month,  EXTRACT(YEAR FROM rental_date) AS Year, COUNT(*) 
FROM 
	rental 
JOIN 
	staff USING(staff_id)
JOIN 
	store USING(store_id)
GROUP BY 
	store_id, EXTRACT(MONTH FROM rental_date), EXTRACT(YEAR FROM rental_date)
ORDER BY 
	store_id, month;
	
-- 61. Replace Title 'Date speed' to 'Data speed' whose Language 'English'
UPDATE film 
SET title = 'Data speed'
FROM language
WHERE film.language_id = language.language_id AND title = 'Date Speed' AND name = 'English'	

-- 62. Remove Starting Character "A" from Description Of film
UPDATE film
SET description = RIGHT(description, length(description)-1) 
WHERE description LIKE 'A %';

--  63. if end Of string is 'Italian'then Remove word from Description of Title
UPDATE film
SET description = OVERLAY(description placing '' from LENGTH(description) for LENGTH(description) - 7)
WHERE description LIKE '%italian';

SELECT OVERLAY('description' placing '' from LENGTH('description')-7 for LENGTH('description'))


-- 64. Who are the top 5 customers with email details per total sales
SELECT email, SUM(amount) AS total_sales FROM payment
JOIN customer USING(customer_id)
GROUP BY customer_id ORDER BY SUM(amount) DESC 
LIMIT 5;

-- 65. Display the movie titles of those movies offered in both stores at the same time.
SELECT 
	title 
FROM film 
WHERE film_id IN (
		SELECT DISTINCT film_id 
		FROM inventory i1
		INNER JOIN inventory i2 USING(film_id)
		WHERE i1.store_id = 1 AND i2.store_id = 2 
	  		AND i1.last_update = i2.last_update
);

-- 66. Display the movies offered for rent in store_id 1 and not offered in store_id 2.
SELECT DISTINCT film_id
FROM inventory
WHERE store_id = 1
EXCEPT
SELECT DISTINCT film_id
FROM inventory
WHERE store_id = 2
ORDER BY film_id;

-- 67. Show the number of movies each actor acted in
SELECT 
	actor.first_name, actor.last_name, COUNT(*) 
FROM actor 
JOIN film_actor USING(actor_id) 
GROUP BY actor_id;

-- 68. Find all customers with at least three payments whose amount is greater than 9 dollars
SELECT 
	customer_id, first_name, last_name, COUNT(*) 
FROM payment
JOIN customer USING(customer_id)
WHERE amount > 9 
GROUP BY customer_id 
HAVING(COUNT(*) > 3);

-- 69. find out the lastest payment date of each customer
SELECT 
	customer_id, first_name, last_name, max(payment_date) 
FROM payment
JOIN customer USING(customer_id)
GROUP BY customer_id 
ORDER BY customer_id;

-- 70. Create a trigger that will delete a customer’s reservation record once the customer’s rents the DVD
CREATE OR REPLACE FUNCTION drop_reservation_record()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$
	BEGIN
		DELETE FROM reservation 
		USING inventory 
		WHERE OLD.film_id = inventory.film_id AND OLD.customer_id = customer_id;
		RETURN NULL;
	END;
$$;

CREATE OR REPLACE TRIGGER trigger_drop_reservation_record
ON rental
BEFORE INSERT
FOR EACH ROW
EXECUTE PROCEDURE drop_reservation_record;

SELECT * FROM rental;
SELECT * FROM reservation;
INSERT INTO reservation VALUES(6, )
SELECT * FROM inventory;

INSERT INTO rental VALUES()


-- 71. Create a trigger that will help me keep track of all operations performed on the reservation table. 
-- I want to record whether an insert, delete or update occurred on the reservation table and store that log in reservation_audit table.

CREATE OR REPLACE FUNCTION insert_reservation()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$
	BEGIN
		INSERT INTO reservation_audit
		VALUES('I', CURRENT_TIMESTAMP, NEW.customer_id, NEW.inventory_id, NEW.reserve_date);
	RETURN NULL;
	END;
$$;

CREATE OR REPLACE FUNCTION delete_reservation()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$
	BEGIN
		INSERT INTO reservation_audit
		VALUES('D', CURRENT_TIMESTAMP, OLD.customer_id, OLD.inventory_id, OLD.reserve_date);
	RETURN NULL;
	END;
$$;

CREATE OR REPLACE FUNCTION update_reservation()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$
	BEGIN
		INSERT INTO reservation_audit
		VALUES('U', CURRENT_TIMESTAMP, OLD.customer_id, OLD.inventory_id, OLD.reserve_date);
	RETURN NULL;
	END;
$$;

CREATE OR REPLACE TRIGGER trigger_insert_reservation
AFTER INSERT
ON reservation
FOR EACH ROW
EXECUTE PROCEDURE insert_reservation();

CREATE OR REPLACE TRIGGER trigger_delete_reservation
BEFORE DELETE
ON reservation
FOR EACH ROW
EXECUTE PROCEDURE delete_reservation();

CREATE OR REPLACE TRIGGER trigger_update_reservation
BEFORE UPDATE
ON reservation
FOR EACH ROW
EXECUTE PROCEDURE update_reservation();

SELECT * FROM reservation;
SELECT * FROM reservation_audit;
INSERT INTO reservation
VALUES(5, 55, '2025-5-25');

UPDATE reservation
SET inventory_id = 65 WHERE customer_id = 5;

DELETE FROM reservation WHERE inventory_id = 55;

-- 72. Create trigger to prevent a customer for reserving more than 3 DVD’s.
CREATE OR REPLACE FUNCTION dvd_max()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$ 

BEGIN
	IF (
		SELECT COUNT(customer_id)
	   	FROM reservation
		WHERE NEW.customer_id = reservation.customer_id
		) = 3
	THEN
		RAISE NOTICE 'Customer Can''t Rent More Than 3 DVD''s At a Time';
	ELSE
		RETURN NEW;
	END IF;
END $$;

CREATE TRIGGER max_dvd
BEFORE INSERT
ON reservation
FOR EACH ROW
EXECUTE PROCEDURE dvd_max();

INSERT INTO reservation(customer_id, inventory_id, reserve_date)
VALUES(2, 14, CURRENT_DATE);

-- 73. create a function which takes year as a argument and return the concatenated result of title which contain 'ful' in it and release year like this (title:release_year) --> use cursor in function
CREATE OR REPLACE FUNCTION get_film_titles(p_year INTEGER)
	RETURNS TEXT
	AS
$$
	DECLARE
		titles TEXT DEFAULT '';
		rec_films RECORD;
		cur_films cursor
			FOR SELECT title, release_year
			FROM film
			WHERE release_year = p_year;
	BEGIN
		OPEN cur_films;
		
		LOOP
			FETCH cur_films INTO rec_films;
			EXIT WHEN NOT FOUND;
			IF rec_films.title LIKE '%ful%' 
				THEN 
					titles = titles || ',' || rec_films.title || ',' || rec_films.release_year;
			END IF;
		END LOOP;
		RETURN titles;
	END;
$$
LANGUAGE PLPGSQL;

SELECT get_film_titles(2006);


-- 74. Find top 10 shortest movies using for loop
DO
$$
	DECLARE
		n RECORD;
	BEGIN
		FOR n IN SELECT * 
				 FROM film 
				 ORDER BY length DESC 
				 LIMIT 10
		LOOP
			RAISE NOTICE '%', n;
		END LOOP;
	END;
$$;

-- 75. Write a function using for loop to derive value of 6th field in fibonacci series (fibonacci starts like this --> 1,1,.....)
CREATE OR REPLACE FUNCTION fibonacci(n INT)
	RETURNS INT
	LANGUAGE PLPGSQL
	AS
$$
	DECLARE 
		a INT = 1;
		b INT = 1;	        
		c INT ;
	BEGIN
		RAISE NOTICE '%', a;
		RAISE NOTICE '%', b;
		WHILE n-2 > 0
		LOOP
			c = a + b;
			a = b;
			b = c;
		    RAISE NOTICE '%', c;
			n = n - 1;
		END LOOP;
	END;
$$;

SELECT fibonacci(5);
