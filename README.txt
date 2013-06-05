#load schema (Don't run this)
$ sqlite3 mydatabase.db < config/core.sql
$ dbicdump -o dump_directory=./ Genome::Schema 'dbi:SQLite:./mydatabase.db'

#DIR STRUCTURE
.
├── Genome
│   ├── Schema
│   │   └── Result
│   │       ├── Dna.pm
│   │       ├── Feature.pm
│   │       ├── FeatureSequence.pm
│   │       ├── Isolate.pm
│   │       └── Protein.pm
│   └── Schema.pm
├── README.txt
├── config
│   ├── README.txt
│   └── core.sql
├── script
│   ├── db_load_isolates.pl
│   └── db_load_sequences.pl
└── testdata
    ├── 8786_8#49.faa
    ├── 8786_8#49.ffn
    ├── 8786_8#50.faa
    └── 8786_8#50.ffn

6 directories, 15 files


#Running a test:
$ cd testdata
#in the testdata dir
$ db_load_isolates.pl -remark CSF ../mydatabase.db *
$ db_load_sequences.pl ../mydatabase.db *
