#!/usr/bin/env perl
use strict;
use warnings;
use Homolog::Schema;
use Bio::SeqIO;
use Getopt::Long;
use Pod::Usage;
use Bio::PrimarySeq;
use Data::Dumper;

my ($opt_help
   , $opt_man
   , $opt_PASSWORD
   , $opt_SANGER_ID
   );
GetOptions(
  'help|h'          => \$opt_help,
  'password|p=s'    => \$opt_PASSWORD,
  'sanger_id|s=s'   => \$opt_SANGER_ID,
) or pod2usage(-verbose => 1) && exit;

pod2usage(-verbose => 1) && exit if defined $opt_help;
pod2usage(-verbose => 1) && exit unless 
                           (
                                defined $opt_PASSWORD
                               and 
                                defined $opt_SANGER_ID
                           );

my $SCHEMA = Homolog::Schema->connect('dbi:mysql:pathogen_fy2_test:mcs6:3346', 'fy2', $opt_PASSWORD);


print get_isolateID_by_sangerID($opt_SANGER_ID), "\n";



sub get_isolateID_by_sangerID {
    my $sanger_id  = shift;

    my $isolate_id;
    #well this will fail if the ID is not there...
    eval {
        $isolate_id = $SCHEMA->resultset('HomIsolates')->search({ sanger_id => $sanger_id })->first->id;
    }; 
    if ($@) {
        die "No such isolate ID in DB: '$sanger_id'. Forgot to create an entry in hom_isolates table?";
    }
    
    return $isolate_id;
}


__END__

=head1 NAME

=head1 SYNOPSIS

B<$0>  options ...
   
 Options:
   -help|h                  brief help message
   -dbpassword|p=s'     => \$opt_PASSWORD,
   -sanger_id|s=s'      => \$opt_SANGER_ID

=head1 DESCRIPTION

Print an isolate's database ID given its sanger_id (e.g. 1234_5#6 ...)

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exit.

=back

=head1 VERSION

Version 0.01

=cut

