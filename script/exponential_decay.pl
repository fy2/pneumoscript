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
my $all_isolates_arr = $coredb->isolates;
my $all_clusters_arr = $coredb->clusters;


if ( scalar @{$all_clusters_arr} == 0 ) {
    print "No clusters found, skipping.\n";
}
else {
    dump_exponential($all_isolates_arr, $all_clusters_arr, 100);
}


sub dump_exponential {
    my ($selected_isolates, $clusters, $iterations) = @_; 
    
    my $member_count = scalar @{ $selected_isolates };

    # Get growing random subsamples of isolates:
    # and show their clusters. Do this $iterations times.
    for my $memcount (1..$member_count) {
        my @cluster_counts; 
        for my $iter (1..$iterations) {
            my $random_isolates_array   = $stats->get_random_isolates($selected_isolates, $memcount);
            my $involved_cluster_array = $stats->get_associated_clusters($random_isolates_array, $clusters);
            push @cluster_counts, scalar @{$involved_cluster_array};
        }
        print join ',', ('Members_'.$memcount, @cluster_counts);
        print "\n";
    }
}

__END__

=head1 NAME

=head1 SYNOPSIS

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
