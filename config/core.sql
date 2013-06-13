-- -----------------------------------------------------
-- Table isolates
-- -----------------------------------------------------
DROP TABLE IF EXISTS isolates ;

CREATE TABLE IF NOT EXISTS isolates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    remarks text,
    sanger_id text
);

-- -----------------------------------------------------
-- Table proteins
-- -----------------------------------------------------
DROP TABLE IF EXISTS proteins ;

CREATE  TABLE IF NOT EXISTS proteins (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    seq TEXT
);

-- -----------------------------------------------------
-- Table dna
-- -----------------------------------------------------
DROP TABLE IF EXISTS dna ;

CREATE  TABLE IF NOT EXISTS dna (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    seq TEXT
);

-- -----------------------------------------------------
-- Table genes
-- -----------------------------------------------------
DROP TABLE IF EXISTS genes ;

CREATE  TABLE IF NOT EXISTS genes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dna_id INTEGER,
    protein_id INTEGER,
    isolate_id INTEGER,
    product TEXT,
    protein_group_id INTEGER,
    dna_group_id INTEGER

);

CREATE INDEX protein_idx ON genes (protein_id);
CREATE INDEX dna_idx ON genes (dna_id);
CREATE INDEX pgroup_idx ON genes (protein_group_id);
CREATE INDEX dgroup_idx ON genes (dna_group_id);

