#!/usr/bin/env perl
use strict;
use warnings;

use Homolog::Schema;

my $ps = <STDIN>;
chomp $ps;
my $schema = Homolog::Schema->connect('dbi:mysql:pathogen_fy2_test:mcs6:3346', 'fy2', $ps);

# or retrieve them as a result set object.
# $schema->resultset returns a DBIx::Class::ResultSet
my @isolates = $schema->resultset('HomIsolates')->all;

foreach $isolate (@isolates) {
    print $isolate->id, "\n";
}

