#!/usr/bin/env perl

use strict;
use warnings;

chdir($ARGV[0]);
chdir('RATT');

open(FH, '<abacas.multifasta.and.contigsInBin.fasta') or die $!;

my @ids;
while(<FH>) {
    chomp;
    if (/^>(.+)/) {
        my $id = $1;
        $id =~ s/\|/_/g;
        push(@ids, 'ratt_out.' .  $id . '.final.embl');
    }
}
close FH;
my $str = join (" ", @ids);
my $cmd = "psu_union.pl $str > ../psu.union.embl";
print `$cmd`;
