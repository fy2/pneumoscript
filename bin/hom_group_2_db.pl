#!/usr/bin/env perl
use strict;
use warnings;
use Homolog::Schema;
use Bio::SeqIO;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

my ($opt_help, $opt_man, $opt_password, $opt_group_file, $opt_analysis_id);
GetOptions(
  'help|h'          => \$opt_help,
  'password|p=s'    => \$opt_password,
  'group_file|g=s' => \$opt_group_file,
  'analysis_id|a=i' => \$opt_analysis_id,
) or pod2usage(-verbose => 1) && exit;

pod2usage(-verbose => 1) && exit if defined $opt_help;
pod2usage(-verbose => 1) && exit unless 
                           (
                               defined $opt_password
                               and 
                                defined $opt_group_file                              
                              and 
                               defined $opt_analysis_id
                           );



my $SCHEMA = Homolog::Schema->connect('dbi:mysql:pathogen_fy2_test:mcs6:3346', 'fy2', $opt_password);



insert_into_db( get_groups($opt_group_file) );






sub get_groups {
    my $file = shift;
    open my $fh, "<", $file or die $!;
    
    my @members;
    while (<$fh>) {
        chomp;
        my ($prefix, $feature_ids) = $_ =~ /(^.+:\D+)(.+)/;
        push @members, [split /\s+/, $feature_ids];
    }
    
    return \@members;
}


sub insert_into_db {
    my $groups = shift; 
    
    foreach my $group ( @$groups ) {
        my $group_object = $SCHEMA->resultset('HomGroup')
                              ->create({ analysis_id => $opt_analysis_id });
                                    
        foreach my $feature_id (@$group) {
            my $feat = $SCHEMA->resultset('HomGroupComposition')
                   ->create({  group_id  => $group_object->id,
                               feature_id => $feature_id });
            print 'Inserted :', $feature_id, ' in ', $group_object->id, "\n";
        }
    }
}



__END__

=head1 NAME

=head1 SYNOPSIS

B<$0> -p password  -group_file <FILE> -analysis_id <ID>
   
 Options:
   -help|h        brief help message
   -dbpassword|p=s' => \$opt_password,
   -group_file|g=s' => \$opt_group_file
   -analysis_id|a=i' => \$opt_analysis_id,

=head1 DESCRIPTION

Insert group file from ortho_mcl into DB

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exit.

=back

=head1 VERSION

Version 0.01

=cut

