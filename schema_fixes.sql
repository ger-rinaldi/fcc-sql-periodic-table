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
