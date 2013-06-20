####################################
# Running An Analysis
####################################

#0 We work in Bourne Shell, type:
bash

#1 Set the environment:
source /nfs/users/nfs_f/fy2/software/CoreGenome/config/setup_pipeline.sh

#2 Create the empty DB schema:
run_core.pl -t db -s db -d seq.db

#3 Create a dir for the annotated genomes and enter it:
mkdir testdata && cd testdata

#4 Softlink the annotations for two test lanes (8786_8#49 and  8786_8#50):
annotationfind -t lane -id 8786_8#49 -s -f ffn
annotationfind -t lane -id 8786_8#49 -s -f faa
annotationfind -t lane -id 8786_8#50 -s -f ffn
annotationfind -t lane -id 8786_8#50 -s -f faa

#5 Load the isolates and their annotations into DB:
#  You can designate your isolates with the -m option.
#  It is possible to run this command successively in different directories 
#  where you might have different types of isolates and their annotations.
run_core.pl -t db -s load -m HIV -d ../seq.db *

#6 Go back up to the main dir:
cd ..

#7 If interested in protein based analysis, replace 'dna' below with 'protein'
run_core.pl -t dna -s preblast -d seq.db

#8 Go into this directory, created by the last command.
#  Note: the dir will be named 'set_prot' if running protein analysis:
cd set_dna

#8 Run Dna blast (see 'miscellaneous' section below if you wann to parallelise)
blastn -query dna.fasta -db dna.fasta -evalue 1E-15 -out out.blast -parse_deflines -outfmt 6

#8 (ALTERNATIVE) If running protein analysis: use blastp. Choose lower BLOSUM matrices if you are 
# working with very diverse organisms (see 'miscellaneous' section below if you wann to parallelise)
blastp -query protein.fasta -db protein.fasta -evalue 1E-15 -matrix BLOSUM90 -out out.blast -parse_deflines -outfmt 6

#9 This will cluster and place the results of blast output
#  IMPORTANT: Replace 'dna' below with 'protein' if running protein analysis:
run_core.pl -t dna -s postblast -d ../seq.db -b out.blast




####################################
# Querying Results
####################################

#10 Querying general metrics ('Member' is a synonym for organism/isolate/strain):
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/MemberStats.sql |less
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/MemberAnnotations.sql |less

#11 Querying gene clusters for 'protein' analysis:
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/protein/MemberCountPerGroup.sql |less
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/protein/MemberNamesPerGroup.sql |less -S
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/protein/MemberTypeCountPerGroup.sql |less
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/protein/MemberTypeNamesPerGroup.sql |less -S

#12 Querying gene clusters for 'dna' analysis:
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/dna/MemberCountPerGroup.sql |less
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/dna/MemberNamesPerGroup.sql |less -S
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/dna/MemberTypeCountPerGroup.sql |less
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/dna/MemberTypeNamesPerGroup.sql |less -S





####################################
# Miscellaneous: Parallelised BLAST
####################################

#1 Split your input 'dna.fasta' or 'protein.'fasta' into chunks:
# If you have a 'dna.fasta' with 100,000 reads and you want
# chunks of 10,000:
split -l 10000 chunk.

#2 Blast the individual chunk files:
for i in chunk.*; do bsub -o $i.bout -e $i.berr blastn -query $i -db dna.fasta -evalue 1E-15 -out $i.blast -parse_deflines -outfmt 6  ; done

#3 Check for errors:
cat *berr

#4 Merge results:
cat chunk*.blast > out.blast



