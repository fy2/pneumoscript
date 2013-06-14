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
│   │       ├── Gene.pm
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


###########################################################################
##########################Running a test###################################
###########################################################################

#set the environment paths
$ bash
$ export PERL5LIB=/nfs/pathogen002/fy2/perllib
$ PERL5LIB=/nfs/users/nfs_f/fy2/software/CoreGenome:$PERL5LIB
$ PATH=/nfs/users/nfs_f/fy2/local/bin:$PATH
$ PATH=/nfs/users/nfs_f/fy2/software/CoreGenome/script:$PATH

#descend into the test directory and create empty DB
$ cd testdata
$ sqlite3 seq.db < ../config/core.sql

#get two lanes' annotations:
$ /nfs/users/nfs_f/fy2/script/annotationfind -t lane -id 8786_8#49 -s -f ffn
$ /nfs/users/nfs_f/fy2/script/annotationfind -t lane -id 8786_8#49 -s -f ffa
$ /nfs/users/nfs_f/fy2/script/annotationfind -t lane -id 8786_8#50 -s -f ffn
$ /nfs/users/nfs_f/fy2/script/annotationfind -t lane -id 8786_8#50 -s -f ffa

#load the isolates and their sequences into the datrabase
$ db_load_isolates.pl -remark CSF seq.db *
$ db_load_sequences.pl seq.db *

#Protein
$ db_unload_protein.pl seq.db
$ makeblastdb -in protein.txt -input_type fasta -parse_seqids -dbtype prot
$ split -l 10000 protein.txt chunk.
$ ls chunk.* | xargs -n 1 -P 1 -t -I {} bsubber.py -q basement -o {}.bout -m 2 -e {}.berr blastp -query {} -db protein.txt -out {}.blast -evalue 1E-15 -parse_deflines -outfmt 6
$ cat *.blast > all.together.blast
$ cut -f 1,2,11 all.together.blast > seq.abc
$ mcxload -abc seq.abc -write-tab seq.dict -o seq.mci --stream-mirror --stream-neg-log10 -stream-tf 'ceil(200)'
$ mcl seq.mci -I 4
$ mcxdump -icl out.seq.mci.I40 -o dump.seq.mci.I140 -tabr seq.dict
$ db_load_groups.pl seq.test.db dump.seq.mci.I140 protein
sqlite3 seq.test.db 'select protein_group_id, dna_id, product, isolate_id, seq from genes, dna where dna.id = genes.dna_id order by protein_group_id;' | less

#Nucleotide
$ db_unload_dna.pl seq.db
$ makeblastdb -in protein.txt -input_type fasta -parse_seqids -dbtype dna
$ split -l 10000 dna.txt chunk.
$ ls chunk.* | xargs -n 1 -P 1 -t -I {} bsubber.py -q basement -o {}.bout -m 2 -e {}.berr blastn -query {} -db dna.txt -out {}.blast -evalue 1E-15 -parse_deflines -outfmt 6
$ cat *.blast > all.together.blast
$ cut -f 1,2,11 all.together.blast > seq.abc
$ mcxload -abc seq.abc -write-tab seq.dict -o seq.mci --stream-mirror --stream-neg-log10 -stream-tf 'ceil(200)'
$ mcl seq.mci -I 4
$ mcxdump -icl out.seq.mci.I40 -o dump.seq.mci.I140 -tabr seq.dict
$ db_load_groups.pl seq.test.db dump.seq.mci.I140 dna
sqlite3 seq.test.db 'select dna_group_id, dna_id, product, isolate_id, seq from genes, dna where dna.id = genes.dna_id order by dna_group_id;' | less
