DROP TABLE IF EXISTS student_data;

CREATE TABLE student_data(
	id INT,
	first_name VARCHAR,
	last_name VARCHAR,
	class_name VARCHAR
);



INSERT INTO student_data(id, first_name, last_name, class_name)
VALUES(1, 'Dhainik', 'Suthar', 'A'),
	  (2, 'Dev', 'Maheta', 'B'),
	  (3, 'Sagar', 'Patel', 'C'),
	  (1, 'Dhainik', 'Suthar', 'A');
	  
INSERT INTO student_data(first_name, last_name, class_name)
VALUES('Dhainik', 'Suthar', 'A');
	  
SELECT * from student_data;

DELETE FROM student_data WHERE id NOT IN (
SELECT max(id) FROM student_data GROUP BY (id));

SELECT * FROM student_data s1 INNER JOIN student_data s2 ON s1.first_name = s2.first_name AND s1.last_name = s2.last_name;


DELETE FROM student_data WHERE id IN(
SELECT s1.id FROM student_data s1 INNER JOIN student_data s2 ON s1.first_name = s2.first_name AND s1.last_name = s2.last_name WHERE s1.id < s2.id);

SELECT *, ROW_NUMBER() OVER(PARTITION BY id) INTO  FROM student_data ;

SELECT * FROM student_data s1 inner join student_data s2 using (id);
WHERE s1.id < s2.id;




DROP TABLE IF EXISTS student_data_back ;
CREATE TABLE student_data_back AS SELECT DISTINCT * FROM student_data; 
SELECT * FROM student_data_back;
DROP TABLE student_data;
ALTER TABLE student_data_back RENAME TO student_data; 

SELECT * FROM student_data;
SELECT *, ctid FROM student_data;


DELETE FROM student_data WHERE ctid IN (
SELECT s1.ctid FROM student_data s1, student_data s2 
WHERE s1.ctid < s2.ctid AND
	  s1.id = s2.id AND
	  s1.first_name = s2.first_name AND
	  s1.last_name = s2.last_name AND
	  s1.class_name = s2.class_name);
	  
	  
	  
DELETE FROM student_data WHERE ctid NOT IN (
	SELECT max(ctid) FROM student_data GROUP BY id, first_name, last_name, class_name  
)


ALTER TABLE student_data ADD COLUMN row_num INT;
UPDATE student_data SET row_num = t.col_ FROM (SELECT ROW_NUMBER() OVER(PARTITION BY id, first_name, last_name) as col_ FROM student_data) t;














CREATE TABLE t1(id INT, first_name VARCHAR);
CREATE TABLE t2(id INT, first_name VARCHAR);

INSERT INTO t1 VALUES(1, 'dhainik'), (1, 'dhainik'), (2, 'dev');
INSERT INTO t2 VALUES(1, 'dhainik'), (1, 'dhainik'), (2, 'sagar');

SELECT * FROM t1;
SELECT * FROM t2;

SELECT * FROM t1 JOIN t2 USING(id, first_name);