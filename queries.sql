-- Find all animals whose name ends in "mon".
SELECT * FROM animals WHERE name LIKE '%mon';
-- List the name of all animals born between 2016 and 2019.
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
-- List the date of birth of all animals named either "Agumon" or "Pikachu.
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
-- List name and escape attempts of animals that weigh more than 10.5kg.
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
-- Find all animals that are neutered.
SELECT * FROM animals WHERE neutered = true;
-- Find all animals not named "Gabumon".
SELECT * FROM animals WHERE name != 'Gabumon';
-- Find all animals with a weight between 10.4kg and 17.3kg (inclusive).
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- add-query-update branch
-- Update the "species" column for all rows in the "animals" table to "unspecified".
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
-- Update the "species" column to "digimon" for animals with names ending in "mon".
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
-- Update the "species" column to "pokemon" for animals that don't have a species already .
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals;
-- Commit the transaction to persist the changes.
COMMIT;
SELECT * FROM animals;

BEGIN;
-- Delete all records in the "animals" table.
DELETE FROM animals;
-- Roll back the transaction to undo the deletions.
ROLLBACK;
SELECT * FROM animals;


BEGIN;
-- Delete all animals born after Jan 1st, 2022.
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
-- Create a savepoint for the transaction.
SAVEPOINT my_savepoint;
-- Update all animals' weight to be their weight multiplied by -1.
UPDATE animals SET weight_kg = weight_kg * -1;
-- Roll back to the savepoint
ROLLBACK TO SAVEPOINT my_savepoint;
-- Update all animals' weights that are negative to be their weight multiplied by -1.
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
-- Commit the transaction to persist the changes.
COMMIT;

-- How many animals are there?
SELECT COUNT(*) FROM animals;
-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;
-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, COUNT(*) AS escape_count
FROM animals
GROUP BY neutered
ORDER BY escape_count DESC
LIMIT 1;
-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;
-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) AS avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

-- query-multiple-tables branch
-- What animals belong to Melody Pond?
SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';
-- List of all animals that are pokemon (their type is Pokemon).
SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';
-- List all owners and their animals, including those who don't own any animals.
SELECT o.full_name, a.name
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;
-- How many animals are there per species?
SELECT s.name, COUNT(*) AS animal_count
FROM animals a
JOIN species s ON a.species_id = s.id
GROUP BY s.name;
-- List all Digimon owned by Jennifer Orwell.
SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
JOIN owners o ON a.owner_id = o.id
WHERE s.name = 'Digimon' AND o.full_name = 'Jennifer Orwell';
-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;
-- Who owns the most animals?
SELECT o.full_name, COUNT(*) AS animal_count
FROM owners o
JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY animal_count DESC
LIMIT 1;

-- add-join-table branch
-- Who was the last animal seen by William Tatcher?
SELECT a.name
FROM animals AS a
JOIN visits AS v ON v.animal_id = a.id
JOIN vets AS vt ON vt.id = v.vet_id
WHERE vt.name = 'William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;
-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT v.animal_id)
FROM visits AS v
JOIN vets AS vt ON vt.id = v.vet_id
WHERE vt.name = 'Stephanie Mendez';
-- List all vets and their specialties, including vets with no specialties.
SELECT v.name, s.name AS specialty
FROM vets AS v
LEFT JOIN specializations AS sp ON sp.vet_id = v.id
LEFT JOIN species AS s ON s.id = sp.species_id;
-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name
FROM animals AS a
JOIN visits AS v ON v.animal_id = a.id
JOIN vets AS vt ON vt.id = v.vet_id
WHERE vt.name = 'Stephanie Mendez'
  AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';
-- What animal has the most visits to vets?
SELECT a.name, COUNT(*) AS visit_count
FROM animals AS a
JOIN visits AS v ON v.animal_id = a.id
GROUP BY a.name
ORDER BY visit_count DESC
LIMIT 1;
-- Who was Maisy Smith's first visit?
SELECT a.name
FROM animals AS a
JOIN visits AS v ON v.animal_id = a.id
JOIN vets AS vt ON vt.id = v.vet_id
WHERE vt.name = 'Maisy Smith'
ORDER BY v.visit_date
LIMIT 1;
-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS animal_name, v.name AS vet_name, v.visit_date
FROM visits AS v
JOIN animals AS a ON a.id = v.animal_id
JOIN vets AS vt ON vt.id = v.vet_id
ORDER BY v.visit_date DESC
LIMIT 1;
-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*)
FROM visits AS v
JOIN animals AS a ON a.id = v.animal_id
JOIN vets AS vt ON vt.id = v.vet_id
LEFT JOIN specializations AS sp ON sp.vet_id = vt.id AND sp.species_id = a.species_id
WHERE sp.vet_id IS NULL;
-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT s.name AS specialty
FROM visits AS v
JOIN animals AS a ON a.id = v.animal_id
JOIN vets AS vt ON vt.id = v.vet_id
JOIN specializations AS sp ON sp.vet_id = vt.id
JOIN species AS s ON s.id = sp.species_id
WHERE a.owner_id = (SELECT id FROM owners WHERE full_name = 'Maisy Smith')
GROUP BY s.name
ORDER BY COUNT(*) DESC
LIMIT 1;



