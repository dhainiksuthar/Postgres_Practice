CREATE TABLE emp_json(
	ID INT PRIMARY KEY,
	data JSONB
);

INSERT INTO 
	emp_json
VALUES
	(1, '{"name" : "Dhainik", "Hobbies" : ["Reading", "Chess", "Movies"]}'),
	(2, '{"name" : "Sagar", "Hobbies" : ["Reading", "Playing", "Listening"]}');
	
SELECT * FROM emp_json;

SELECT data FROM emp_json;

SELECT data->'name' FROM emp_json;

SELECT * FROM emp_json WHERE data->'name' = '"Dhainik"';

SELECT JSONB_ARRAY_ELEMENTS_TEXT(data->'Hobbies') FROM emp_json;

SELECT data->'name', JSONB_ARRAY_ELEMENTS_TEXT(data->'Hobbies') FROM emp_json;

SELECT DISTINCT(JSONB_ARRAY_ELEMENTS_TEXT(data->'Hobbies')) FROM emp_json;

SELECT * FROM emp_json WHERE data->'Hobbies' @> '["Playing"]';

SELECT * FROM emp_json WHERE data->'Hobbies' @> '["Playing"]' :: JSONB;

SELECT to_json('Fred said "Hi."'::text)

SELECT '[{"a":"1"}, {"b":"2"}, {"c":"3"}]' :: JSON -> 2;
SELECT '{"a":"1", "b":"2", "c":"3"}' :: JSON -> 2;

SELECT '{"a":"1"}' :: JSON -> 'a';

SELECT '[1,2,3]' :: JSON ->> 2;

SELECT '{"a":"1", "b":"2", "c":"3"}' :: JSON #> '{a}';

SELECT '{"a":[1,2,3,4], "b":"2", "c":"3"}' :: JSON #>> '{a, 2}';

SELECT ARRAY_TO_JSON('{{1,2,3}, {4,5,6}}' :: INT[])

SELECT ROW_TO_JSON(ROW(1, 'Hi'));

SELECT JSON_ARRAY_LENGTH('[1,2,3,4,5]')


-- Work with array in postgres
CREATE TABLE contacts(
	id INT PRIMARY KEY,
	name VARCHAR,
	phones TEXT []
);

INSERT INTO 
	contacts
VALUES
	(1, 'dhainik', ARRAY
						['12344433', '23423123', '1232332']
	);

INSERT INTO
	contacts
VALUES
	(2, 'sagar', '{"123456", "234567", "345678"}');

SELECT * FROM contacts;

SELECT name, phones[1] FROM contacts;

SELECT * FROM contacts WHERE phones[2] = '234567';

SELECT * FROM contacts WHERE '1232332' = ANY(phones);

SELECT name, UNNEST(phones) FROM contacts;


-- Upsert
SELECT constraint_name FROM information_schema.table_constraints
    WHERE table_name='upsert_test'

DROP TABLE IF EXISTS upsert_test;
CREATE TABLE upsert_test(
	id INT,
	data TEXT,
	PRIMARY KEY(id)
);
 
INSERT INTO upsert_test
	VALUES
		(1, 'one'),
		(2, 'two');
SELECT * FROM upsert_test;

INSERT INTO upsert_test
VALUES (2, 'Two')
ON CONFLICT ON CONSTRAINT upsert_test_pkey
DO UPDATE
	SET data = excluded.data;


-- Index
EXPLAIN
SELECT 
	* 
FROM 
	customer
WHERE
	address_id = 530;
	            
CREATE INDEX idx_email
ON customer(email);

DROP INDEX idx_email;

SELECT *
FROM 
	pg_indexes
WHERE tablename = 'address';


-- Partial Index
EXPLAIN SELECT * FROM customer WHERE active = 1;

DROP INDEX idx_customer_active;

CREATE INDEX idx_customer_active
ON customer(active)
WHERE active = 1;

EXPLAIN SELECT * FROM customer WHERE active = 1;


