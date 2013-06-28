use strict;
use warnings;
use Test::More;
use Data::Dumper;

BEGIN { use_ok( 'CoreDB' ); }

my $db = '/nfs/users/nfs_f/fy2/software/CoreGenome/t/data/seq.db';

my $coredb = CoreDB->new(db => $db) ;

ok( defined($coredb) && ref $coredb eq 'CoreDB', 'New worked and returned a CoreDB object.' );

ok( $coredb->db eq '/nfs/users/nfs_f/fy2/software/CoreGenome/t/data/seq.db', 'DB method was set.');

is( ref $coredb->load_clusters_protein, 'ARRAY', 'Gene (dna) clusters loaded.');
is( ref $coredb->load_clusters_dna, 'ARRAY', 'Gene (protein) clusters loaded.');

ok( ref $coredb->load_isolates eq 'ARRAY', 'Isolates loaded.');

is( scalar @{$coredb->isolates}, 18, 'Num isolates is correct.');

is( ref $coredb->get_type_counts_for_dna_clusters, 'HASH', 'Got the type counts for DNA.');

is( scalar keys %{ $coredb->get_type_counts_for_dna_clusters}, 5, 'Cluster count for DNA is right.');

done_testing();
