-- psql -h dbaddress -U postgres -f initDB.sql 
CREATE DATABASE vmcdb;
CREATE USER vmcdba WITH PASSWORD 'vmc123';
GRANT ALL PRIVILEGES ON DATABASE vmcdb TO vmcdba;