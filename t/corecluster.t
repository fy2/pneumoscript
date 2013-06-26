use strict;
use warnings;
use Test::More;

BEGIN { use_ok( 'CoreCluster' ); }


my $clt = CoreCluster->new() ;
ok( defined($clt) && ref $clt eq 'CoreCluster', 'New worked and returned a CoreStatistics object.' );



done_testing();
