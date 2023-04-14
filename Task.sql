SELECT * FROM pages;
SELECT * FROM roles;   --application code
SELECT * FROM user_roles;
SELECT * FROM page_action_permissions;
SELECT * FROM page_actions;


select table_name from information_schema.columns where column_name = 'action_name';
select table_name from information_schema.columns where column_name = 'page_action_id';

select table_name from information_schema.columns where column_name = 'application_code';


input parameter: user_id, application_code
output: application_code, user_id, page_name, permission, page_action

SELECT user_roles.user_id, role_id, application_code, page_name, permission_value, action_name FROM roles
INNER JOIN user_roles USING(role_id)
INNER JOIN page_action_permissions USING(role_id)
INNER JOIN page_actions USING(page_action_id)
INNER JOIN pages USING(page_code) WHERE user_roles.user_id = 4 AND application_code = '*COMMON*';


DROP FUNCTION IF EXISTS getDetails;

CREATE OR REPLACE FUNCTION getDetails(user_id_ INT, application_code_ VARCHAR)
RETURNS TABLE(
	user_id INT,
	role_id INT,
	application_code VARCHAR(50),
	page_name VARCHAR(50),
	permission_values VARCHAR(50),
	action_name VARCHAR(50)
)
LANGUAGE PLPGSQL
AS
$$
	BEGIN
	RETURN
		QUERY
			SELECT 
				user_roles.user_id, user_roles.role_id, roles.application_code, pages.page_name, permission_value, page_actions.action_name 
			FROM roles
			INNER JOIN user_roles USING(role_id)
			INNER JOIN page_action_permissions USING(role_id)
			INNER JOIN page_actions USING(page_action_id)
			INNER JOIN pages USING(page_code) 
			WHERE user_roles.user_id = user_id_ AND roles.application_code = application_code_;
END;
$$ ;

SELECT * FROM getDetails(4, '*COMMON*');




