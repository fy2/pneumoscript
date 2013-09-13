####################################
# Running An Analysis
####################################

#1 Set the environment:
    source /nfs/users/nfs_f/fy2/software/CoreGenomeUnofficial/config/setup_pipeline.sh

#2 Create the empty DB schema:
    run_core.pl -stage db -database seq.db

#3 Create a dir for the annotated genomes and enter it:
    mkdir testdata && cd testdata

#4 Softlink the annotations for two test lanes (8786_8#49 and  8786_8#50):
    annotationfind -t lane -id 8786_8#49 -s -f ffn
    annotationfind -t lane -id 8786_8#49 -s -f faa
    annotationfind -t lane -id 8786_8#50 -s -f ffn
    annotationfind -t lane -id 8786_8#50 -s -f faa

#5 Load the isolates and their annotations into DB:
    #  You can designate your isolates with the -m option.
    run_core.pl -stage load -metainfo MyBadPathogens -database ../seq.db *

    #Back one higher in directory hierarchy:
    cd ..

#6 Prepare the directories and files for sequence comparison step:
    run_core.pl -stage preblast -database seq.db

#7 The last command creates two dirs: "set_prot" and "set_dna". You can base the rest of your analysis on proteins or dna. 
#  Follow the steps below for a protein type of analysis. For DNA, change to a blastn type of search.

    # Choose an appropriate BLOSUM matrix and e-value level.
        cd set_prot
        blastp -query protein.fasta -db protein.fasta -evalue 1E-5 -matrix BLOSUM90 -out out.blast -parse_deflines -outfmt 6

#8 Start clustering (while still in the "set_prot" dir)
    run_core.pl -stage postblast -database ../seq.db -blastfile out.blast

#9 Run queries to inspect the results. See "Queries.sql" for examples.
