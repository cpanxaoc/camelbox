-- drop all of the tables
DROP TABLE IF EXISTS install_type;
DROP TABLE IF EXISTS base_urls;
DROP TABLE IF EXISTS manifest;
DROP TABLE IF EXISTS groups;
DROP TABLE IF EXISTS groups_sections;
DROP TABLE IF EXISTS packages;
DROP TABLE IF EXISTS package_install_type;
-- clean up the database file
VACUUM;
