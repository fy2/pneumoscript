Annotation trans.

bash

#all 448 isolates scaffold .fa files symlinked here 
$ pwd
/lustre/scratch108/pathogen/fy2/page/analysis_assembly/abacas_ratt_09_04_2013_on_scaffolds/results

502  source /lustre/scratch108/pathogen/fy2/page/analysis_assembly/script/sourceme.pagit.fix

515  ls *.fa | xargs -n 1 -P 1 -I {} wrap.abacas.pl {}

514   ls | xargs -n 1 -P 1 -t -I {} wrap.ratt.pl {}

527 @pathinfo-test all_isolates $ grep -i success *dir/RATT/ratt.out | wc -l
448

ls | xargs  -n 1 -P 1 -I {} bsub -o '{}.out' -e '{}.err' wrap.psu.pl {}

605 @pathinfo-test all_isolates $  grep -i success *out | wc -l
448

607 @pathinfo-test all_isolates $ rm *err *out

$ exit

ls | xargs -n 1 -t -P 1 -p -I {} bsub -o \{\}.out -e \{\}.err '/lustre/scratch108/pathogen/fy2/page/analysis_assembly/script/wrap.psu.pl {}'

#clean up
rm *out *err -f
