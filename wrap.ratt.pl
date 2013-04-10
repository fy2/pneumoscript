#!/usr/bin/env perl
use strict;
use warnings;

chdir $ARGV[0];
mkdir 'RATT';
chdir './RATT';
`cat ../abacas.MULTIFASTA.fa ../abacas.contigsInbin.fas > abacas.multifasta.and.contigsInBin.fasta`;
my $cmd = "bsub -M2000000 -R 'select[mem>2000] rusage[mem=2000]' -o ratt.out -e ratt.err /lustre/scratch108/pathogen/fy2/page/analysis_assembly/script/RATT_fix/start.ratt.sh /lustre/scratch108/pathogen/fy2/page/analysis_assembly/data/annotation_modified abacas.multifasta.and.contigsInBin.fasta ratt_out Strain";
print `$cmd`;

