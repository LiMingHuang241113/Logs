#create a table 
CREATE TABLE client_data (
  id SERIAL PRIMARY KEY,
  Clientkey INT,
  Clientvoornamen VARCHAR(100),
  ClientTussenvoegsel VARCHAR(50),
  ClientAchternaam VARCHAR(100),
  GeboorteJaar INT,
  ClientGeslacht VARCHAR(10),
  NotaRegelBedrag DECIMAL(10, 2),
  NotaJaar INT,
  NotaKwartaal VARCHAR(10),
  NotaMaand VARCHAR(50),
  Buurtcode VARCHAR(20),
  Buurtnaam VARCHAR(100)
);


#delete the table
DROP TABLE client_data;


#copy information/data from the file persons into the table persons
COPY persons(first_name, last_name, dob, email)
FROM 'C:\Program Files\PostgreSQL\16\data\persons.csv'
DELIMITER ',' 
CSV HEADER;


SELECT * FROM persons;


#import information/data form the file SQL_DDL1_exercise1 into the table client_data
COPY client_data(Clientkey, Clientvoornamen, ClientTussenvoegsel, ClientAchternaam, GeboorteJaar, ClientGeslacht, NotaRegelBedrag, NotaJaar, NotaKwartaal, NotaMaand, BuurtCode, BuurtNaam)
FROM 'C:\Program Files\PostgreSQL\16\data\SQL_DDL1_exercise1.csv'
DELIMITER ','
CSV HEADER;


#change the column clientvoornaam to clientvoornamen
ALTER TABLE client_data
RENAME COLUMN Clientvoornaam TO ClientVoornamen;


COPY client_data
FROM 'C:\Program Files\PostgreSQL\16\data\SQL_DDL1_exercise1.csv'
DELIMITER ','
CSV LOG ERRORS;


SELECT column_name
FROM information_schema.columns
WHERE table_name = 'client_data';


SELECT a.attname AS column_name
FROM pg_index i
JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
WHERE i.indrelid = 'client_data'::regclass AND i.indisprimary;


SELECT clientkey
WHERE clientkey IN (
    SELECT clientkey
    FROM csv_data_to_be_inserted
);


#looks specificly into the mentioned columns
SELECT ClientKey, Clientvoornamen, ClientAchternaam, NotaRegelBedrag
FROM client_data;


#aggregations and summaries, calculates who has the largest total invoice amount
SELECT ClientVoornamen, ClientAchternaam, SUM(NotaRegelBedrag), AVG(NotaRegelBedrag)
FROM client_data
GROUP BY ClientVoornamen, ClientAchternaam;


#the total and average invoices amounts for each person. 
SELECT Clientvoornamen, ClientAchternaam, SUM(NotaRegelBedrag), AVG(NotaRegelBedrag)
FROM client_data
GROUP BY ClientVoornamen, ClientAchternaam
ORDER BY 3 Desc;


#filtering data, these are all the people born before 2007
SELECT ClientVoornamen, ClientAchternaam, GeboorteJaar
FROM client_data
WHERE GeboorteJaar <= 2008;


CREATE TABLE client (
  id serial PRIMARY KEY,
  ClientKey INT,
  ClientVoornamen VARCHAR(100),
  ClientTussenvoegsel VARCHAR(50),
  ClientAchternaam VARCHAR(100),
  GeboorteJaar INT,
  ClientGeslacht VARCHAR(10)
);

COPY client(clientkey, clientvoornamen, ClientTussenvoegsel, ClientAchternaam, GeboorteJaar, ClientGeslacht)
FROM 'C:\Program Files\PostgreSQL\16\data\SQL_DDL1_exercise2.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE invoice (
  id SERIAL PRIMARY KEY,
  ClientKey INT,
  NotaRegelBedrag DECIMAL(10, 2),
  NotaJaar INT,
  NotaKwartaal VARCHAR(10),
  NotaMaand VARCHAR(50),
  Buurtcode VARCHAR(20),
  Buurtnaam VARCHAR(100)
);

COPY invoice(clientkey, NotaRegelBedrag, NotaJaar, NotaKwartaal, NotaMaand, BuurtCode, BuurtNaam)
FROM 'C:\Program Files\PostgreSQL\16\data\SQL_DDL1_exercise3.csv'
DELIMITER ','
CSV HEADER;


#connects the data from the table client and invoice
SELECT c.ClientKey,
       ClientVoornamen,
       ClientTussenvoegsel,
       ClientAchternaam,
       GeboorteJaar,
       ClientGeslacht,
       NotaRegelBedrag,
       NotaJaar,
       NotaKwartaal,
       NotaMaand,
       BuurtCode,
       Buurtnaam
FROM client as c
LEFT JOIN invoice as inv
ON c.clientkey = inv.clientkey





