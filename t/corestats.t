use strict;
use warnings;
use Test::More;
use CoreDB;
use Data::Dumper;

BEGIN { use_ok( 'CoreStats' ); }

my $stats = CoreStats->new() ;

is( ref $stats, 'CoreStats', 'New works.' );

my $db = './data/seq.db';

my $coredb = CoreDB->new(db=>$db);

$coredb->load_clusters;
$coredb->load_isolates;

$stats->isolates($coredb->isolates);
$stats->clusters($coredb->clusters);

is($stats->count_isolates, 18, 'got 18 isolates');

my $isolate_arr = $stats->get_random_isolates(1); 
is( ref $isolate_arr, 'ARRAY', 'Got an array ref to random isolate');
is( scalar @{ $isolate_arr }, 1, 'Array has a single random isolate');

$isolate_arr = $stats->get_random_isolates(5); 
is( ref $isolate_arr, 'ARRAY', 'Got an array ref to random isolates');
is( scalar @{ $isolate_arr }, 5, 'Array has five random isolates');
#warn Dumper $isolate_arr;


$isolate_arr = $stats->get_random_isolates(10); 
is( ref $isolate_arr, 'ARRAY', 'Got an array ref to random isolates');
is( scalar @{ $isolate_arr }, 10, 'Array has ten random isolates');
#warn Dumper $isolate_arr;

my $associated_clust_arr = $stats->get_associated_clusters($isolate_arr); 
is( ref $associated_clust_arr, 'ARRAY', 'Got an array ref to associated clusters of random isolates');

done_testing();
