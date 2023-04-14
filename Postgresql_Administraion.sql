CREATE DATABASE hr;

SELECT CURRENT_USER;
SET ROLE postgres;
-- Rename database
ALTER DATABASE hr RENAME TO hr_new;

-- Change owner
ALTER DATABASE hr_new OWNER TO postgres;

-- Drop database
DROP DATABASE IF EXISTS hr_new;
 
-- Delete database which session is active
SELECT *
FROM pg_stat_activity
WHERE datname = 'codingpub';

SELECT	pg_terminate_backend (pid)
FROM	pg_stat_activity
WHERE	pg_stat_activity.datname = 'codingpub';

DROP DATABASE codingpub;

-- Copy database
-- CREATEDB -T Practical Practical;
SELECT pg_terminate_backend (pid) FROM pg_stat_activity WHERE datname = 'postgres';
CREATE DATABASE postgres_test WITH TEMPLATE postgres;

-- Create back up file for database
pg_dump -U postgres -h localhost -W -F t Practical > data.tar

-- Copy all database to file
pg_dumpall -U postgres -h localhost > all_database_backup.sql;


-- Copy database to source.sql file
pg_dump -U postgres -h localhost -d Practical -f source.sql

-- Copy from file to database
psql -U postgres -h localhost -d test -f source.sql


SELECT pg_terminate_backend (pid) FROM pg_stat_activity WHERE datname = 'Practical';
CREATE DATABASE Practical_Backup WITH TEMPLATE 'Practical';

DROP DATABASE practical_backup;
-- CREATE DATABASE newdb WITH TEMPLATE Practical;

-- Table size 
-- returns the size of the table only, not included indexes or additional objects.
select pg_relation_size('actor');
SELECT pg_size_pretty (pg_relation_size('actor'));

-- To get the total table size
SELECT pg_size_pretty ( pg_total_relation_size ('actor') );

-- To get size of whole database
SELECT PG_SIZE_PRETTY (PG_DATABASE_SIZE('Practical'));

-- To get size of each database
SELECT datname, PG_SIZE_PRETTY (PG_DATABASE_SIZE(datname)) AS size FROM pg_database;

-- To get total size of all indexes attached to a table
SELECT PG_SIZE_PRETTY(PG_INDEXES_SIZE('actor'));
	
-- Current schema
SELECT CURRENT_SCHEMA();

-- Search path
SHOW SEARCH_PATH;

-- Create new schema
CREATE SCHEMA sales;

-- Set search path to schema
SET SEARCH_PATH TO public;

DROP SCHEMA sales;

CREATE SCHEMA sales AUTHORIZATION postgres;

-- Rename Schema
ALTER SCHEMA sales RENAME to sales_new;

-- Change owner
ALTER SCHEMA sales_new OWNER TO dhainik;

-- Create tablespace
CREATE TABLESPACE ts_primary LOCATION '/home/dhainik/SQL/Tablespace';

-- List all role
SELECT rolname FROM pg_roles;

-- Create role
CREATE ROLE test
SELECT CURRENT_ROLE;
WITH
LOGIN CREATEDB
PASSWORD 'root'
VALID UNTIL '2023-03-08' CONNECTION LIMIT 10;

SET ROLE test;
SET ROLE postgres;
SELECT * FROM actor; 

-- Grant select permission on actor table to test role
GRANT SELECT ON actor TO test;

-- Grant access to all table in schema
GRANT ALL ON ALL TABLES IN SCHEMA "sales_new" TO test;

-- Revoke Privileges
REVOKE SELECT ON actor FROM test;

-- Revoke all privileges
REVOKE ALL ON SCHEMA sales_new FROM test;

-- Alter Role
ALTER ROLE test SUPERUSER VALID UNTIL '2023-03-06';

-- Rename role
ALTER ROLE test RENAME TO test_new;
ALTER ROLE test_new RENAME TO test;


CREATE DATABASE database1 OWNER test;

-- drop all object ownerd by user
DROP OWNED BY test;

REASSIGN OWNED BY test TO postgres;

DROP ROLE test;


CREATE DATABASE test1;

