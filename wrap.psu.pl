#!/usr/bin/env perl

use strict;
use warnings;


open(FH, '<'. $ARGV[0]) or die $!;

my @ids;
while(<FH>) {
    chomp;
    if (/^>(\S+)\s/) {
        push(@ids, 'ratt_out.' .  $1 . '.final.embl');
    }
}
close FH;
my $str = join (" ", @ids);
my $cmd = "psu_union.pl $str > psu.union.embl";
print `$cmd`;
