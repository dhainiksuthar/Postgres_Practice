-- Table adp planogram

DROP TABLE IF EXISTS adp_planogram;

CREATE TABLE adp_planogram(
	pkey SERIAL PRIMARY KEY,
	branch VARCHAR(100),
	route VARCHAR(30),
	location VARCHAR(100),
	place VARCHAR(100),
	telemetry_id VARCHAR(100),
	asset_id VARCHAR,
	asset_type VARCHAR(150),
	asset_class VARCHAR,
	selection VARCHAR,
	group_ VARCHAR,
	item VARCHAR(150),
	item_code VARCHAR,
	current_level VARCHAR(20),
	par VARCHAR(10),
	depletion_limit VARCHAR(30),
	capacity VARCHAR(30),
	price VARCHAR(10),
	desired_price VARCHAR(30),
	has_price_mismatch VARCHAR(30),
	avg_weekly_vends VARCHAR(30),
	days_since_last_sale VARCHAR(30),
	has_pending_planogram_change VARCHAR(30),
	column_number VARCHAR(30),
	quantity VARCHAR(30)
);

\COPY adp_planogram(Branch, Route, Location, Place, telemetry_id, asset_id, asset_type, asset_class, selection, group_, item, item_code, current_level, 
   par, depletion_limit, capacity, price, desired_price, has_price_mismatch, avg_weekly_vends, days_since_last_sale, 
   has_pending_planogram_change, column_number, quantity) 
FROM '/home/dhainik/ConnectHQ/csv/ADP - Current Planogram Selection Quality 2023-04-06 0748.csv' DELIMITER ',' CSV;

SELECT * FROM adp_planogram





-- Table daily sales

DROP TABLE IF EXISTS adp_daily_sales;

CREATE TABLE adp_daily_sales(
	pkey SERIAL PRIMARY KEY,
	asset_id VARCHAR,
	customer VARCHAR,
	customer_code VARCHAR,
	location VARCHAR(150),
	location_code VARCHAR,
	place VARCHAR,
	asset_type VARCHAR,
	route VARCHAR(30),
	asset_class	VARCHAR(30),
	item_code VARCHAR,
	item VARCHAR(150),
	spoiled_qty VARCHAR(30),
	inventory_over_short_qty VARCHAR(30),
	sold_qty VARCHAR(30),
	total_revenue VARCHAR(20),
	sales_tax VARCHAR(20)
);
SELECT * FROM adp_daily_sales

\COPY adp_daily_sales(asset_id, customer, customer_code, location, location_code, place, asset_type, route, asset_class, item_code, item, spoiled_qty, inventory_over_short_qty, sold_qty,total_revenue, sales_tax) FROM '/home/dhainik/ConnectHQ/csv/ADP - Daily Sales 2023-03-28 0945 (1).csv' DELIMITER ',' CSV;




-- Table assets

DROP TABLE IF EXISTS adp_assets;

CREATE TABLE adp_assets (
	pkey SERIAL PRIMARY KEY,
	asset_id VARCHAR(50),
	customer VARCHAR(300),
	location VARCHAR(300),
	place VARCHAR(300),
	asset_type	VARCHAR(200),
	route	VARCHAR(200),
	asset_class	VARCHAR(200),
	address_1 VARCHAR(200),
	address_2 VARCHAR(200),
	city VARCHAR(50),
	state VARCHAR(50),
	zip VARCHAR(40),
	phone VARCHAR(100),
	asset_family VARCHAR(200),
	asset_make VARCHAR(100),
	asset_model	VARCHAR(100),
	asset_serial_number	VARCHAR(200),
	branch VARCHAR(200),
	commission_plan VARCHAR(200),
	contact_name VARCHAR(250),
	dynamic_schedule VARCHAR(300),
	email VARCHAR,
	interval_schedule VARCHAR(200),
	inventory_interval VARCHAR(100),
	line_of_business VARCHAR,
	payment_terms VARCHAR,
	route2 VARCHAR,
	static_schedule VARCHAR(200),
	subroute VARCHAR(200),
	tax_jurisdiction VARCHAR(150),
	telemetry_device_id VARCHAR(50),
	telemetry_supplier VARCHAR,
	is_deployed VARCHAR
);

SELECT * FROM adp_assets

\COPY adp_assets(asset_id ,customer, customer_code, location, location_code, place ,asset_type, route, asset_class,address_1, address_2 , city, state, zip , phone, asset_family, asset_make, asset_model, asset_serial_number, branch, commission_plan, contact_name, dynamic_schedule, schedule_type, email ,interval_schedule ,inventory_interval ,line_of_business ,payment_terms ,static_schedule ,subroute ,tax_jurisdiction ,telemetry_device_id ,telemetry_supplier ,is_deployed) FROM '/home/dhainik/ConnectHQ/csv/ADP - Assets Quality 2023-04-04 0954.csv' DELIMITER ',' CSV; 




-- Table adp items
DROP TABLE IF EXISTS adp_items;


CREATE TABLE adp_items (
	item_code VARCHAR,
	name VARCHAR(200),
	category VARCHAR,
	finance_category VARCHAR,
	commission_category VARCHAR,
	tax_category VARCHAR,
	deposit_category VARCHAR,
	manufacturer VARCHAR,
	size VARCHAR,
	count VARCHAR(30),
	default_unit_cost VARCHAR,
	unit_cost_k_r_vending VARCHAR(200),
	pick_order VARCHAR(250),
	case_count VARCHAR(30),
	case_barcode TEXT,
	box_count VARCHAR(30),
	box_barcode TEXT,
	each_barcode TEXT,
	custom_pack VARCHAR,
	custom_count VARCHAR,
	custom_barcode TEXT,
	auto_transfer VARCHAR(15),
	invoice_only VARCHAR(15),
	receive_pack VARCHAR(15),
	transfer_pack VARCHAR(15),
	delivery_pack VARCHAR(15),
	supplier_coke VARCHAR(15),
	supplier_code_coke VARCHAR(25),
	supplier_ellis VARCHAR(25),
	supplier_code_ellis VARCHAR(25),
	supplier_pepsi_bottling_group VARCHAR(100),
	supplier_code_pepsi_bottling_group VARCHAR(100),
	supplier_tri_city VARCHAR(100),
	supplier_code_tri_city VARCHAR(100),
	supplier_vistar_mid_atlantic VARCHAR(100),
	supplier_code_vistar_mid_atlantic VARCHAR(100),
	cf_eatwell VARCHAR(100),
	cf_nuts VARCHAR(100)
);

\COPY adp_items FROM '/home/dhainik/ConnectHQ/csv/ADP-All Items K&R.csv' DELIMITER ',' CSV; 

ALTER TABLE adp_items ADD COLUMN pkey SERIAL PRIMARY KEY;

SELECT * FROM adp_items;