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
$coredb->load_clusters_protein;
$coredb->load_clusters_dna;
my $all_isolates_arr = $coredb->isolates;
my $all_prot_clusters_arr = $coredb->clusters_protein;
my $all_dna_clusters_arr = $coredb->clusters_dna;

my @bac_only_isolates = grep { $_->remark eq 'bac' } @{ $all_isolates_arr };
my @men_only_isolates = grep { $_->remark eq 'men' } @{ $all_isolates_arr };


print "BAC ISOLATES PROTEIN-BASED CLUSTER\n";
dump_exponential(\@bac_only_isolates, $all_prot_clusters_arr, 100);
print "MEN ISOLATES PROTEIN-BASED CLUSTER\n";
dump_exponential(\@men_only_isolates, $all_prot_clusters_arr, 100);

print "BAC ISOLATES DNA-BASED CLUSTER\n";
dump_exponential(\@bac_only_isolates, $all_dna_clusters_arr, 100);
print "MEN ISOLATES DNA-BASED CLUSTER\n";
dump_exponential(\@men_only_isolates, $all_dna_clusters_arr, 100);



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

B<exponential.pl> -d seq.db 

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
