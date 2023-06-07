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
