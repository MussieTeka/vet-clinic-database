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
-- Alter the "animals" table to add an auto-incremented primary key "id" column
ALTER TABLE animals ADD COLUMN id SERIAL PRIMARY KEY;
-- Remove the existing "species" column from the "animals" table
ALTER TABLE animals DROP COLUMN species;
-- Add a new column "species_id" as a foreign key referencing the "species" table
ALTER TABLE animals ADD COLUMN species_id INTEGER REFERENCES species;
-- Add a new column "owner_id" as a foreign key referencing the "owners" table
ALTER TABLE animals ADD COLUMN owner_id INTEGER REFERENCES owners;

-- add-join-table branch
-- Create the "vets" table
CREATE TABLE vets (
    id SERIAL PRIMARY KEY,
    name VARCHAR,
    age INTEGER,
    date_of_graduation DATE
);
-- Create the "specializations" join table
CREATE TABLE specializations (
    vet_id INTEGER REFERENCES vets (id),
    species_id INTEGER REFERENCES species (id),
    PRIMARY KEY (vet_id, species_id)
);
-- Create the "visits" join table
CREATE TABLE visits (
    vet_id INTEGER REFERENCES vets (id),
    animal_id INTEGER REFERENCES animals (id),
    visit_date DATE,
    PRIMARY KEY (vet_id, animal_id)
);
