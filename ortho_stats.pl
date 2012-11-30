#!/usr/bin/env perl

use strict;
use warnings;

#ORTHOMCL164(40 genes,40 taxa):   3850_8#7_1080_INV10411190_colour_13(3850_8#7) 4350_6#3_1147_INV10411190_colour_13(4350_6#3)
my $gene_cluster = 1;
while(<>) {
    s/^(.+:\s+)//;
    chomp;
    my @group = split /\s+/, $_;
    foreach my $gene (@group) {
        my ($isolate, undef, $rest)
            = $gene =~ /^(.+?_.+?)_(\d+)_(.+?)\(/;
                       #4525_1#9_1_INV10400140_colour_11(4525_1#9) 
        my ($gene_name, $colour_code) = split /colour_/, $rest;
        $colour_code = 8 unless defined $colour_code;
        #print join "\t" , 'GeneCluster' . $gene_cluster
        print join "\t" , $gene_cluster
                        , $isolate
                        , $gene_name
                        , $colour_code;
        print "\n";
    }

    $gene_cluster++;
}
