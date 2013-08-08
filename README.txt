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

#8a Go into this directory, created by the last command.
 cd set_dna
    #  Note: the dir will be named 'set_prot' if running protein analysis:
    #  Run Dna blast (see 'miscellaneous' section below if you want to parallelise)
    blastn -query dna.fasta -db dna.fasta -evalue 1E-5 -out out.blast -parse_deflines -outfmt 6

   -ALTERNATIVE- If running protein analysis: use blastp. Choose lower BLOSUM matrices if you are 
    # working with very diverse organisms.
    blastp -query protein.fasta -db protein.fasta -evalue 1E-5 -matrix BLOSUM90 -out out.blast -parse_deflines -outfmt 6

#9 This will cluster and place the results of this analysis into db
    #  IMPORTANT: Replace 'dna' below with 'protein' if running protein analysis:
    run_core.pl -t dna -s postblast -d ../seq.db -b out.blast

#10 Run queries to inspect the results of the analysis in database (See the
    file "Queries.sql".)

####################################
# Miscellaneous: Parallelised BLAST
####################################

#1 Split your input 'dna.fasta' or 'protein.'fasta' into chunks:
    # If you have a 'dna.fasta' with 100,000 reads and you want
    # chunks of 10,000 line (This works because sequences are in one line and
    # division by an even number wont split any entry in half):
    split -l 10000 dna.fasta chunk.

#2 Blast the individual chunk files:
    for i in chunk.*; do bsub -o $i.bout -e $i.berr blastn -query $i -db dna.fasta -evalue 1E-5 -out $i.blast -parse_deflines -outfmt 6; done

#3 Check for errors:
    cat *berr
    cat *bout | grep -E -i "(exited|terminated)"

#4 Merge results:
    cat chunk*.blast > out.blast
