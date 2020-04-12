# Create president table for U.S. Historical League

DROP TABLE IF EXISTS president;
#@ _CREATE_TABLE_
CREATE TABLE president
(
  last_name  VARCHAR(15) NOT NULL,
  first_name VARCHAR(15) NOT NULL,
  suffix     VARCHAR(5) NULL,
  city       VARCHAR(20) NOT NULL,
  state      VARCHAR(2) NOT NULL,
  birth      DATE NOT NULL,
  death      DATE NULL
);
#@ _CREATE_TABLE_
