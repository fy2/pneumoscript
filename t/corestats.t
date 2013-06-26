use strict;
use warnings;
use Test::More;

BEGIN { use_ok( 'CoreStatistics' ); }

my $stats = CoreStatistics->new;
ok( defined($stats) && ref $stats eq 'CoreStatistics',     'new worked and returned a CoreStatistics object' );


done_testing();
