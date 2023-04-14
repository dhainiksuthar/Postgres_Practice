
-- CHAT TABLE: users can show interest in Notebooks by responding to an Intercom chat. Those responses are logged in the chat table.  

create table chat ( 
  	id serial primary key,
  	email varchar,
    nb_interest timestamp
);
    
insert into chat(email, nb_interest)
values 	('tom@gmail.com', '2019-09-22 11:57:12 UTC'),
		('tom@gmail.com', '2019-09-28 04:23:34 UTC'),
		('bridgette@gs.com', '2019-08-29 12:45:29 UTC'),
		('jd@ey.com', '2019-08-27 10:15:55 UTC'),
		('clarke@alpha.com', '2019-09-06 08:09:51 UTC')
        ;

-- EMAIL TABLE: users can also show interest by responding to promotional emails from Hubspot. Responses related to Notebooks are tagged nb_interest.

create table email ( 
  	email_id serial primary key,
  	hs_email varchar,
    created_at timestamp,
	tags varchar (512)
);
    
insert into email(hs_email, created_at, tags)
values 	('jon@gmail.com', '2019-10-06 07:15:29 UTC', 'nb_interest'),
		('tom@gmail.com', '2019-09-25 00:04:50 UTC','support'),
		('josh@alpha.com', '2019-09-16 01:04:25 UTC', 'renewal'),
        ('clarke@alpha.com', '2019-09-16 01:04:25 UTC', 'nb_interest'),
		('jide@google.com', '2019-09-03 00:13:59 UTC','pricing'),
		('will@nb.com', '2019-08-22 02:54:33 UTC', 'nb_interest'),
        ('chad@fda.gov', '2019-08-22 02:54:33 UTC', 'nb_interest')
        ;

-- CLIENT TABLE: Paid subscriptions are marked by client_start and client_end. Users with nulls for both values are assumed to be trial users. 

create table client_dates ( 
  	id serial primary key,
  	contact_email varchar,
	client_start timestamp,
    client_end timestamp
  );
  
insert into client_dates(contact_email, client_start, client_end)
values 	('jon@gmail.com', '2019-08-06 09:15:29 UTC',null),
		('kristie@gmail.com', '2019-06-25 00:04:50 UTC',null),
		('stephanie@test.com', '2018-11-16 01:04:25 UTC','2019-10-06 01:04:25 UTC'),
		('jide@google.com', '2019-09-03 00:13:59 UTC',null),
		('will@nb.com', '2019-08-22 02:54:33 UTC',null),
        ('laila@ucs.com', '2019-03-22 06:54:33 UTC',null),
        ('tom@gmail.com', '2019-07-09 11:32:44 UTC',null),
        ('chad@fda.gov', null, null),
        ('bridgette@gs.com', null, null),
        ('jd@ey.com', '2017-09-03 09:03:41 UTC','2019-10-01 05:56:27 UTC'),
		('clarke@alpha.com', null, null);
  
  
  
-- Your task: 
-- 1) Fork this fiddle.
-- 2) Write a SQL query (Postgres preferred but any dialect is fine) that combines data from the 3 tables below.  
      -- List everyone who has shown interest in using our new Notebooks feature, and channel of the two requests (chat, email, or both). 
	  -- Each user should have only one row. Include a column indicating if the user was a client at the time of any of the requests.   
-- The final table should have a single row per user, with the following columns: 
--   email | most_recent_request_timestamp | previous_request_timestamp | channel | is_client


SELECT * FROM chat;
SELECT * FROM email;
SELECT * FROM client_dates;
SELECT * FROM 


WITH cte1 AS(
SELECT email, 'chat' AS channel, nb_interest FROM chat
UNION ALL
SELECT hs_email, 'email' AS email, created_at FROM email WHERE tags = 'nb_interest'),

cte2 AS
(SELECT email,
	CASE
		WHEN
			STRING_AGG(channel, ',') LIKE '%chat%' AND STRING_AGG(channel, ',') LIKE '%email%' THEN 'both'
		WHEN 
			STRING_AGG(channel, ',') LIKE '%chat%' THEN 'chat'
		ELSE 'email'
	END AS channel1,
	MAX(nb_interest) AS most_recent_request_timestamp,
	MIN(nb_interest) AS previous_request_timestamp
FROM cte1 LEFT JOIN client_dates ON cte1.email = client_dates.contact_email GROUP BY email)

SELECT 
	email, channel1 AS channel, most_recent_request_timestamp, previous_request_timestamp,
	CASE
		WHEN cte2.email = client_dates.contact_email THEN 'Yes'
		ELSE 'No'
	END AS is_client
	FROM cte2 LEFT JOIN client_dates ON cte2.email = client_dates.contact_email;

