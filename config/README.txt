1-Make the DB:
sqlite3 mydatabase.db < core.sql

2-Dump with schemaloader:
dbicdump -o dump_directory=./ Genome::Schema 'dbi:SQLite:./mydatabase.db'

