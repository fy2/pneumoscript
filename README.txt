#An Example Run:

#0 We work in Bourne Shell, type:
bash

#1 Set the environment:
source /nfs/users/nfs_f/fy2/software/CoreGenome/config/setup_pipeline.sh

#2 Create the empty DB schema:
run_core.pl -t db -s db -d seq.db

#3 Create a dir for the annotated genomes and enter it:
mkdir testdata && cd testdata

#4 softlink the annotations for two test lanes (8786_8#49 and  8786_8#50):
annotationfind -t lane -id 8786_8#49 -s -f ffn
annotationfind -t lane -id 8786_8#49 -s -f faa
annotationfind -t lane -id 8786_8#50 -s -f ffn
annotationfind -t lane -id 8786_8#50 -s -f faa

#5 load the isolates and their annotations into DB:
run_core.pl -t db -s load -m bac -d ../seq.db *

#6 Go back up to the main dir:
cd ..

#7 Run the steps before BLAST (replace 'dna' below with 'protein')
#for a protein analysis:
run_core.pl -t dna -s preblast -d seq.db

#8 Go into this directory, created by the last command.
#(It will be 'set_prot' if running protein analysis):
cd set_dna

#8 Run Dna blast (parallelise this if necessary, and cat the files into one file)
blastn -query dna.fasta -db dna.fasta -evalue 1E-15 -out out.blast -parse_deflines -outfmt 6

# For Protein blast:
#blastp -query protein.fasta -db protein.fasta -evalue 1E-15 -matrix BLOSUM90 -out out.blast -parse_deflines -outfmt 6

#9 This will cluster and place the results of blast output
#IMPORTANT: Replace 'dna' below with 'protein' if running protein analysis:
run_core.pl -t dna -s postblast -d ../seq.db -b out.blast



#10 Querying general:
sqlite3 seq.db < /nfs/users/nfs_f/fy2/software/CoreGenome/queries/MemberStats.sql | less -S
sqlite3 seq.db < /nfs/users/nfs_f/fy2/software/CoreGenome/queries/MemberAnnotations.sql | less -S
#11 Querying Homology Groups based on Protein analysis (replace 'protein' with 'dna' in the path below to get dna related stats:
sqlite3 seq.db < /nfs/users/nfs_f/fy2/software/CoreGenome/queries/protein/MemberCountPerGroup.sql | less -S
sqlite3 seq.db < /nfs/users/nfs_f/fy2/software/CoreGenome/queries/protein/MemberNamesPerGroup.sql | less -S
sqlite3 seq.db < /nfs/users/nfs_f/fy2/software/CoreGenome/queries/protein/MemberTypeCountPerGroup.sql | less -S
sqlite3 seq.db < /nfs/users/nfs_f/fy2/software/CoreGenome/queries/protein/MemberTypeNamesPerGroup.sql | less -S
