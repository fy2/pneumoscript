#!/usr/bin/env perl

use strict;
use warnings;
use lib qw(/nfs/users/nfs_f/fy2/software/CoreGenome/lib /nfs/users/nfs_f/fy2/software/CoreGenome);
use Data::Dumper;
use Getopt::Long;
use Pod::Usage;
use File::Spec;
use CoreStats;
use CoreDB;

my ($opt_help, $opt_type, $opt_db);

GetOptions(
  'help|h'        => \$opt_help,
  'type|t=s'      => \$opt_type,
  'database|d=s'  => \$opt_db,
) or pod2usage(-verbose => 1) && exit;

pod2usage(-verbose => 1) && exit if defined $opt_help;
pod2usage(-verbose => 1) && exit unless defined $opt_db;



if (not -e $opt_db) {
    print STDERR "Database does not exist\n";
    return 0;
}
$opt_db = File::Spec->rel2abs($opt_db);

my $coredb = CoreDB->new(db=>$opt_db);
my $stats = CoreStats->new();

#load from db into the object:
$coredb->load_isolates;
$coredb->load_clusters;

#fille data structures:
my $all_isolates_array      = $coredb->isolates;
my $all_clusters_array      = $coredb->clusters;

# Get growing (1..70) random subsamples of isolates:
# and show their clusters. Do this 100 times for each
# subsample size (1..100):
for my $memcount (1..70) { 
    for my $iter (1..100) {
        my $random_isolates_array   = $stats->get_random_isolates($all_isolates_array, $memcount);
        my $involved_cluster_arrays = $stats->get_associated_clusters($random_isolates_array, $all_clusters_array);
        print "Random members: $memcount, clusters found: ", scalar @{$involved_cluster_arrays}, " Iteration: $iter\n";
    }
}

__END__

=head1 NAME

=head1 SYNOPSIS

B<core_exponential.pl> -d seq.db 

 Options:
   -help|h        brief help message
   -database|d    path the to database

=head1 DESCRIPTION

=over 8

=item B<-help>

Print a brief help message and exit.

=back

=head1 VERSION

Version 0.01

=cut
