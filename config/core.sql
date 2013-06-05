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
-- Table features
-- -----------------------------------------------------
DROP TABLE IF EXISTS features;

CREATE  TABLE IF NOT EXISTS features (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    isolate_id INTEGER,
    product TEXT
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
-- Table feature_sequences
-- -----------------------------------------------------
DROP TABLE IF EXISTS feature_sequences ;

CREATE  TABLE IF NOT EXISTS feature_sequences (
    dna_id INTEGER,
    proteins_id INTEGER,
    features_id INTEGER
);
