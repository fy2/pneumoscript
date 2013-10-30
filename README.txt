####################################
# Running An Analysis
####################################

Run this pipeline ONLY on "farm3". 

#1 Set the environment and prepare input data (no need to bsub):
    source ~fy2/software/CoreGenomeUnofficial/config/setup_pipeline.sh

 # Create the empty Database (DB) schema called 'seq.db':
    run_core.pl -stage db -database seq.db

 # Create a dir for the annotated genomes and enter it:
    mkdir MyData 
    cd MyData

 # Let's softlink annotations for just two test isolates. 
 # (Talk to Feyruz Yalcin for advice if you are working with > 100 isolates).
 # We will need both 'ffn' and 'faa' for each. I am using "8786_8#49" and "8786_8#50"
 # isolates for this example run.

    annotationfind -t lane -id 8786_8#49 -s -f ffn
    annotationfind -t lane -id 8786_8#49 -s -f faa

    annotationfind -t lane -id 8786_8#50 -s -f ffn
    annotationfind -t lane -id 8786_8#50 -s -f faa

#2 Load the isolates and their annotations into your DB (bsub this command):
 # Note: It is possible to run the loading stage multiple times in different directories which 
 # contain different isolate 'types'. You can designate the 'type' for a group of 
 # isolates by providing a single word description to the -m option (e.g. "MyBadPathogens",
 # "BloodIsolate", "CSF", etc...). 
 # Make sure that you only have "ffn" and "faa" files in the directory where you run the command below.
 # and also that the path to your "seq.db" is correct.
 
    run_core.pl -stage load -metainfo MyBadPathogens -database ../seq.db *
 #Back one higher in directory hierarchy:
    cd ..

#3 Prepare the directories and files for sequence comparison step (bsub this command with low memory < 0.5Gb):
    run_core.pl -stage preblast -database seq.db

#4 The last command creates two dirs: "set_prot" and "set_dna". You can base the rest of your analysis on proteins or dna. 
 # Follow the steps below for a protein type of analysis. For DNA, change to a blastn type of search.
 # Choose an appropriate BLOSUM matrix and e-value level (bsub this command).
 # if you have many tens of thousands of protein sequences in the "protein.fasta" file, the blastp will take a long time.
 # Talk to Feyruz Yalcin for advice if you are working with > 100 isolates.

    cd set_prot
    blastp -query protein.fasta -db protein.fasta -evalue 1E-5 -matrix BLOSUM90 -out out.blast -parse_deflines -outfmt 6

#5 Start clustering (bsub this command, usually a low memory command)
    run_core.pl -stage postblast -database ../seq.db -blastfile out.blast


#Now you can run queries or scripts to inspect the results. seq.db serves as the single central access point. See "Queries.sql" for examples.
