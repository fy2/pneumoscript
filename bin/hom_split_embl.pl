#!/usr/bin/env perl
use strict;
use warnings;
use Bio::SeqIO;
use Data::Dumper;

my $file = $ARGV[0]; 
my $seqio = Bio::SeqIO->new(-file => $file);

while ( my $seq = $seqio->next_seq ) {

    print $seq->accession_number(), "\n";
    my $out = Bio::SeqIO->new(-file => ">". $seq->accession_number() . ".embl", -format => 'EMBL');
    
    $seq->id($seq->accession_number());

    $out->write_seq($seq);

}
