-- IF Database Already Exists
DROP DATABASE IF EXISTS "RPL_2012";
     
CREATE DATABASE "RPL_2012"
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'English_Australia.1252'
       LC_CTYPE = 'English_Australia.1252'
       CONNECTION LIMIT = -1;

-- IF you get this error:
-- ERROR:  new collation (English_Australia.1252) is incompatible with the collation of the template database (English_United States.1252)
-- Use the United States version below.

--CREATE DATABASE "RPL_2012"
--  WITH OWNER = postgres
--       ENCODING = 'UTF8'
--       TABLESPACE = pg_default
--       LC_COLLATE = 'English_United States.1252'
--       LC_CTYPE = 'English_United States.1252'
--       CONNECTION LIMIT = -1;

------------------------------------------------------------
-- Exit Postgres DB, enter RPL_2012 DB (SQL Query screen) --
------------------------------------------------------------
SET standard_conforming_strings = off;
SET escape_string_warning = off;

----------------------------------
-- Roles (Created by 2012 Team) --
----------------------------------
CREATE ROLE admin;
CREATE ROLE clerical;
CREATE ROLE student;
CREATE ROLE teacher;

ALTER ROLE admin WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN CONNECTION LIMIT 1 PASSWORD 'md5d1f44e0806dd0f196156fd384e7ee84d' VALID UNTIL 'infinity';
ALTER ROLE clerical WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN CONNECTION LIMIT 1 PASSWORD 'md502cbc711824af4d16d0d35c7dc0fa578' VALID UNTIL 'infinity';
ALTER ROLE student WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN CONNECTION LIMIT 1 PASSWORD 'md548ac9412341a96e8157fec8f4384e3f4' VALID UNTIL 'infinity';
ALTER ROLE teacher WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN CONNECTION LIMIT 1 PASSWORD 'md599db6ef4103993c52e380b58981ed232' VALID UNTIL 'infinity';




-------------------------------------------------------
-- Not sure if these are needed (was auto generated) --
-------------------------------------------------------
/*
ALTER DEFAULT PRIVILEGES 
    GRANT INSERT, SELECT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES
    TO postgres;

ALTER DEFAULT PRIVILEGES 
    GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES
    TO admin;

ALTER DEFAULT PRIVILEGES 
    GRANT EXECUTE ON FUNCTIONS
    TO postgres;

ALTER DEFAULT PRIVILEGES 
    GRANT EXECUTE ON FUNCTIONS
    TO admin;

ALTER DEFAULT PRIVILEGES 
    GRANT EXECUTE ON FUNCTIONS
    TO clerical;

ALTER DEFAULT PRIVILEGES 
    GRANT EXECUTE ON FUNCTIONS
    TO student;

ALTER DEFAULT PRIVILEGES 
    GRANT EXECUTE ON FUNCTIONS
    TO teacher;
*/
