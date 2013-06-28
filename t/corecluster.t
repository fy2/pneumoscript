use strict;
use warnings;
use Test::More;

BEGIN { use_ok( 'Cluster' ); }


my $clt = Cluster->new() ;
ok( defined($clt) && ref $clt eq 'Cluster', 'New worked.' );



done_testing();
