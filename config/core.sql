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
DROP TABLE IF EXISTS sequences ;

CREATE  TABLE IF NOT EXISTS sequences (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dna_id INTEGER,
    protein_id INTEGER,
    isolate_id INTEGER,
    product TEXT,
    group_id INTEGER
);

CREATE INDEX protein_idx ON sequences (protein_id);
CREATE INDEX dna_idx ON sequences (dna_id);
CREATE INDEX group_idx ON sequences (group_id);
