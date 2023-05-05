DROP TABLE IF EXISTS user_details, api_log, api_error;

CREATE TABLE user_details(
	user_id BIGINT PRIMARY KEY,
	user_name VARCHAR(200),
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	password VARCHAR(256)
);


CREATE TABLE api_log(
	api_call_id BIGSERIAL PRIMARY KEY,
	api_name VARCHAR(200),
	user_id BIGINT,
	api_call_start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	api_call_end_time TIMESTAMP,
	status VARCHAR(10),
	downloaded VARCHAR(10), 
	api_category VARCHAR(200),
	FOREIGN KEY(user_id) REFERENCES user_details(user_id)
); 

CREATE TABLE api_error(
	api_call_id BIGINT,
	error VARCHAR(512),
	FOREIGN KEY(api_call_id) REFERENCES api_log(api_call_id)
);