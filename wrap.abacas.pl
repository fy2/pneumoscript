#!/usr/bin/env perl
use strict;
use warnings;

my $ori = $ARGV[0];
mkdir "$ori.dir";
`mv $ori $ori.dir`;
chdir "$ori.dir";
my $cmd = "bsub -o abacas.out -e abacas.err abacas.pl -p nucmer -m -b -o 'abacas' -q $ori -r /lustre/scratch108/pathogen/fy2/page/analysis_assembly/data/spn1041.reference.fasta";
print `$cmd`;
