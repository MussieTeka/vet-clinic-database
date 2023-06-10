CREATE TABLE animals (
  id serial PRIMARY KEY,
  name varchar(100),
  date_of_birth date,
  escape_attempts integer,
  neutered boolean,
  weight_kg decimal
);

-- add-query-update branch

ALTER TABLE animals ADD COLUMN species varchar(100);

-- query-multiple-tables branch

-- Create the "owners" table with the specified columns
CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(255),
  age INTEGER
);
-- Create the "species" table with the specified columns
CREATE TABLE species (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);
-- Modify the "animals" table to set the "id" column as auto-incremented primary key
ALTER TABLE animals
ALTER COLUMN id SET DATA TYPE SERIAL PRIMARY KEY;
