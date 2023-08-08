ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;

ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;

ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;
ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;

ALTER TABLE elements ADD CONSTRAINT uniq_symbol UNIQUE (symbol);
ALTER TABLE elements ADD CONSTRAINT uniq_name UNIQUE (name);

ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;
ALTER TABLE elements ALTER COLUMN name SET NOT NULL;

ALTER TABLE properties ADD CONSTRAINT elmnt_prop_atomnum_fk
FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number);

CREATE TABLE types(
  type_id SERIAL PRIMARY KEY,
  type VARCHAR(60) NOT NULL 
);

INSERT INTO types(type) SELECT DISTINCT(type) FROM properties;
INSERT INTO types(type) VALUES ('halogens'), ('noble gases'), ('alkali metals');

ALTER TABLE properties ADD COLUMN type_id INT;
ALTER TABLE properties ADD CONSTRAINT prop_type_dk FOREIGN KEY (type_id) REFERENCES types(type_id);

UPDATE properties AS p SET type_id = t.type_id
FROM types AS t
WHERE p.type = t.type;

ALTER TABLE properties DROP COLUMN type;
ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;

INSERT INTO elements(atomic_number, name, symbol) VALUES (9, 'Fluorine', 'F'), (10, 'Neon', 'Ne');
INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) 
VALUES (9, 18.998, -220, -188.1, 3), (10, 20.18, -248.6, -246.1, 3);

ALTER TABLE properties ALTER COLUMN atomic_mass TYPE REAL;

DELETE FROM elements WHERE atomic_number = 1000;
DELETE FROM properties WHERE atomic_number = 1000;