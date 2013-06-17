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
$ PATH=/nfs/users/nfs_f/fy2/software/ncbi-blast-2.2.28+/bin:$PATH
$ PATH=/nfs/users/nfs_f/fy2/bin:$PATH
$ PATH=/nfs/users/nfs_f/fy2/software/CoreGenome/script:$PATH

#descend into the test directory and create empty DB
$ cd testdata
$ sqlite3 seq.db < /nfs/users/nfs_f/fy2/software/CoreGenome/config/core.sql

#get lanes' protein and nucleotide annotations, e.g. for two lanes:
$ /nfs/users/nfs_f/fy2/script/annotationfind -t lane -id 8786_8#49 -s -f ffn
$ /nfs/users/nfs_f/fy2/script/annotationfind -t lane -id 8786_8#49 -s -f faa
$ /nfs/users/nfs_f/fy2/script/annotationfind -t lane -id 8786_8#50 -s -f ffn
$ /nfs/users/nfs_f/fy2/script/annotationfind -t lane -id 8786_8#50 -s -f faa

#load the isolates and their sequences into the datrabase
$ db_load_isolates.pl -remark CSF_Blood_etc ../seq.db *
$ bsubber.py -e ../berr -o ../bout -m 1 db_load_sequences.pl ../seq.db *

#Nucleotide Analysis
mkdir set_dna && cd set_dna
bsubber.py -e berr -o bout db_unload_dna.pl ../seq.db
bsubber.py -e berr -o bout makeblastdb -in dna.txt -input_type fasta -parse_seqids -dbtype nucl
bsubber.py -e berr -o bout split -l 10000 dna.txt chunk.
ls chunk* | xargs -n 1 -P 1 -t -I {} bsubber.py -q basement -o {}.bout -e {}.berr -m 2 blastn -query {} -db dna.txt -evalue 1E-5 -out {}.blast -parse_deflines -outfmt 6
cut -f 1,2,11 *.blast > seq.abc
cat *berr
rm chunk* *.blast
bsubber.py -e berr -o bout -m 0.8 mcxload -abc seq.abc -write-tab seq.dict -o seq.mci --stream-mirror --stream-neg-log10 -stream-tf 'ceil(200)'
bsubber.py -e berr -o bout -m 1 mcl seq.mci -I 4
bsubber.py -e berr -o bout mcxdump -icl out.seq.mci.I40 -o dump.seq.mci.I140 -tabr seq.dict
#make sure the last argument is 'dna' in the command below
bsubber.py -e berr -o bout db_load_groups.pl ../seq.db dump.seq.mci.I140 dna

#Many queries possible (See core.sql)
$ sqlite3 seq.db 'select dna_group_id, dna_id, product, isolate_id, seq from genes, dna where dna.id = genes.dna_id order by dna_group_id;' | less



#Protein Analysis
mkdir set_prot && cd set_prot
bsubber.py -e berr -o bout db_unload_protein.pl ../seq.db
bsubber.py -e berr -o bout makeblastdb -in protein.txt  -input_type fasta -parse_seqids -dbtype prot
bsubber.py -e berr -o bout split -l 10000 protein.txt chunk.
ls chunk* | xargs -n 1 -P 1 -t -I {} bsubber.py -q basement -o {}.bout -e {}.berr -m 2 blastp  -query {} -db protein.txt -evalue 1E-5 -matrix BLOSUM90 -out {}.blast -parse_deflines -outfmt 6
cut -f 1,2,11 *.blast > seq.abc
cat *berr
rm chunk* *.blast
bsubber.py -e berr -o bout -m 0.8 mcxload -abc seq.abc -write-tab seq.dict -o seq.mci --stream-mirror --stream-neg-log10 -stream-tf 'ceil(200)'
bsubber.py -e berr -o bout -m 1 mcl seq.mci -I 4
mcxdump -icl out.seq.mci.I40 -o dump.seq.mci.I140 -tabr seq.dict
#make sure the last argument is 'protein' in the command below
bsubber.py -e berr -o bout db_load_groups.pl ../seq.db dump.seq.mci.I140 protein

#Many queries possible (See core.sql)
$ sqlite3 seq.test.db 'select protein_group_id, dna_id, product, isolate_id, seq from genes, dna where dna.id = genes.dna_id order by protein_group_id;' | less
