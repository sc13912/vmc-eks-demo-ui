-- psql -h localhost -U postgres -f initDB.sql 
CREATE DATABASE guestdb;
CREATE USER guestdba WITH PASSWORD 'guest123';
GRANT ALL PRIVILEGES ON DATABASE guestdb TO guestdba;