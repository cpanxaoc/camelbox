CREATE TABLE install_type (
	type_num 			    INTEGER,
	type_desc 			    TEXT
);
-- CREATE TABLE install_type

CREATE TABLE base_urls (
	url					    TEXT
); 
-- CREATE TABLE base_urls

CREATE TABLE manifest (
	manifest_num 		    INTEGER PRIMARY KEY AUTOINCREMENT,
	manifest_pkg_id		    INTEGER
); 
-- CREATE TABLE manifest

CREATE TABLE groups (
    group_id                TEXT,
    group-desc              TEXT,
    expanded_flag           INTEGER
);
-- CREATE TABLE groups

CREATE TABLE groups-selections (
    group_id                TEXT,
    package_id              TEXT
);
-- CREATE TABLE groups-selections

CREATE TABLE packages (
    package_id              TEXT,
    package_desc            TEXT
);
-- CREATE TABLE packages

CREATE TABLE package_install_type (
    package_id              TEXT,
    install_type.type_num   INTEGER
);
-- CREATE TABLE package_install_type


