#!/usr/bin/env perl
use strict;
use warnings;

while(<>) {
    if ( /\/.+orthologue=.+/) {
         s/["']//g;
         s/\/(.+)/\/note="$1"/;
    }
    s/citation=.*?(\d+)/citation=\[$1\]/;
    print;
}

