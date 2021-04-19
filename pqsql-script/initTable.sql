--  psql -h localhost -U guestdba -d guestdb  -f initTable.sql
CREATE TABLE IF NOT EXISTS guest (
   id Integer PRIMARY KEY ,
   name VARCHAR,
   message VARCHAR,
   created_on timestamp
);
