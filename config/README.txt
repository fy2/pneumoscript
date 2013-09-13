###########################################################################
##########################Configuration (for developers####################
###########################################################################
$ sqlite3 seq.db < config/core.sql
$ dbicdump -o dump_directory=./ Genome::Schema 'dbi:SQLite:./seq.db'
#Dir tree
├── config
│   ├── core.sql
│   └── README.txt
├── Genome
│   ├── Schema
│   │   └── Result
│   │       ├── Dna.pm
│   │       ├── Sequence.pm
│   │       ├── Isolate.pm
│   │       └── Protein.pm
│   └── Schema.pm
├── seq.db
├── README.txt
├── script
│   ├── db_load_groups.pl
│   ├── db_load_isolates.pl
│   ├── db_load_sequences.pl
│   ├── db_unload_dna.pl
│   └── db_unload_protein.pl
└── testdata
    ├── 8786_8#49.faa
    ├── 8786_8#49.ffn
    ├── 8786_8#50.faa
    └── 8786_8#50.ffn

6 directories, 18 files

#SQL structure:
See config/core.sql

