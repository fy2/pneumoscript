#!/usr/bin/env perl

use strict;
use warnings;

#ORTHOMCL164(40 genes,40 taxa):   3850_8#7_1080_INV10411190_colour_13(3850_8#7) 4350_6#3_1147_INV10411190_colour_13(4350_6#3)
while(<>) {
    s/^(.+:\s+)//;
    chomp;
    my @group = split /\s+/, $_;
    print join "\n", @group;
    exit 0;
}

