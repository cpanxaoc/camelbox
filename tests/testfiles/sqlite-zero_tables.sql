-- drop all of the tables
DROP TABLE IF EXISTS install_type;
DROP TABLE IF EXISTS base_urls;
DROP TABLE IF EXISTS manifest;
-- clean up the database file
-- NOTE: you can get rid of this if you end up deleting the file
VACUUM;
