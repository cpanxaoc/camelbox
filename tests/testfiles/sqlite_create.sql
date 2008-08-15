CREATE TABLE install_type (
	type_num 			INTEGER,
	type_desc 			TEXT
); -- install_type

CREATE TABLE base_urls (
	url					TEXT
); -- base_urls

CREATE TABLE manifest (
	manifest_num 		PRIMARY KEY AUTOINCREMENT,
	manifest_pkg_id		INTEGER
); -- manifest

.q
