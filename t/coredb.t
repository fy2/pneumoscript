use strict;
use warnings;
use Test::More;
use Data::Dumper;

BEGIN { use_ok( 'CoreDB' ); }

my $db = './t/data/seq.db';

my $coredb = CoreDB->new(db => $db) ;

ok( defined($coredb) && ref $coredb eq 'CoreDB', 'New worked and returned a CoreDB object.' );

ok( $coredb->db eq './t/data/seq.db', 'DB method was set.');

is( ref $coredb->load_clusters, 'ARRAY', 'Gene clusters loaded.');

ok( ref $coredb->load_isolates eq 'ARRAY', 'Isolates loaded.');

is( scalar @{$coredb->isolates}, 18, 'Num isolates is correct.');

is( ref $coredb->get_type_counts_for_clusters, 'HASH', 'Got the type counts.');





can_ok($coredb, qw(get_distinct_types));
my @distinct_types;
@distinct_types = sort $coredb->get_distinct_types;
is( scalar @distinct_types, 2, "Two isolate types received");

is( $distinct_types[0], 'bac', 'First type is "bac" if lexical sorting in place');
is( $distinct_types[1], 'men', 'Second type is "men" if lexical sorting in place');


my @got = $coredb->get_group_ids;
my @expected = (31, 42, 44, 47, 48);
is_deeply( \@got, \@expected,  'successfully retrieved the cluster ids');

@expected = (617,617,319,235,235,617,622,622,402,196,319,235,235,617,235,319,128,182,194,235,319,235,345,92,235,127,617,380,238);
@got = $coredb->get_clustered_protein_lengths_by_group_id(31);
is_deeply( \@got, \@expected,  'successfully retrieved the cluster ids');

#Really, need more test coverage on this!
can_ok($coredb, qw(get_elements_by_group_id));
#my @elements = $coredb->get_elements_by_group_id(42);



my $coredbMen = CoreDB->new(db => $db); 
is( ref $coredbMen->load_clusters('men'), 'ARRAY', 'Gene clusters loaded.');
ok( ref $coredbMen->load_isolates('men') eq 'ARRAY', 'Isolates loaded.');
is( scalar @{$coredbMen->isolates}, 9, 'Num men isolates is correct.');
is( scalar @{$coredbMen->clusters}, 4, 'Num men clusters is correct.');

my $coredbBac = CoreDB->new(db => $db); 
is( ref $coredbBac->load_clusters('bac'), 'ARRAY', 'Gene clusters loaded.');
ok( ref $coredbBac->load_isolates('bac') eq 'ARRAY', 'Isolates loaded.');
is( scalar @{$coredbBac->isolates}, 9, 'Num bac isolates is correct.');
is( scalar @{$coredbBac->clusters}, 5, 'Num bac clusters is correct.');

done_testing();
