#!/usr/bin/env perl

use strict;
use warnings;
use lib qw(/Users/fy2/software/pneumoscript/lib /Users/fy2/software/pneumoscript);
use Data::Dumper;
use Getopt::Long;
use Pod::Usage;
use File::Spec;
use CoreUtil;
use CoreDB;
use feature qw/switch/;



my ($opt_help, $opt_man, $opt_cmd, $opt_db);

GetOptions(
  'help|h'     => \$opt_help,
  'man|m'      => \$opt_man,
  'database|d=s'  => \$opt_db,
  'command|c=s'   => \$opt_cmd,
) or pod2usage(-verbose => 1) && exit;

pod2usage(-verbose => 1) && exit if defined $opt_help;
pod2usage(-verbose => 2) && exit if defined $opt_man;
pod2usage(-verbose => 1) && exit unless ( (defined $opt_db) and (defined $opt_cmd) );

if (not -e $opt_db) {
    print STDERR "Database does not exist\n";
    return 0;
}
$opt_db = File::Spec->rel2abs($opt_db);

my $util = CoreUtil->new(db => CoreDB->new(db=>$opt_db) );

given ($opt_cmd) {
    when( 'prot_mtx')       { $util->make_protein_seqlen_matrix }
    when( 'prot_seq_by_id') { $util->seq_by_protein_group_id  }
    when( 'dna_seq_by_id')  { continue }
    default                 { die "unknown command: '$opt_cmd'" }
}



__END__

=head1 NAME

=head1 SYNOPSIS

 Options:
   -help|h        brief help message
   -database|d    path the to database
   -command|c     command to execute (see -man for more details)

=head1 DESCRIPTION

=over 8

=item B<-help>

Print a brief help message and exit.

=item B<-man>

Print the manual page and exit.

=back

=head1 VERSION

Version 0.01

=cut
