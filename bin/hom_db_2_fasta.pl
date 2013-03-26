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
   , $opt_SANGER_ID_FILE
   , $opt_ANALYSIS_ID
   );
GetOptions(
  'help|h'          => \$opt_help,
  'password|p=s'    => \$opt_PASSWORD,
  'sanger_id_file|s=s' => \$opt_SANGER_ID_FILE,
  'analysis_id|a=i' => \$opt_ANALYSIS_ID,
) or pod2usage(-verbose => 1) && exit;

pod2usage(-verbose => 1) && exit if defined $opt_help;
pod2usage(-verbose => 1) && exit unless 
                           (
                                defined $opt_PASSWORD
                               and 
                                defined $opt_SANGER_ID_FILE
                               and
                                defined $opt_ANALYSIS_ID
                           );

my $SCHEMA = Homolog::Schema->connect('dbi:mysql:pathogen_fy2_test:mcs6:3346', 'fy2', $opt_PASSWORD);

#parse the sanger id file into array
my @sanger_ids = file_to_array($opt_SANGER_ID_FILE);

#get the hom_isolates.id by sanger_id from DB 
my @isolate_ids;
for my $sanger_id (@sanger_ids) {
    my $isolate_id = get_isolateID_by_sangerID($sanger_id);
    push @isolate_ids, $isolate_id;
}

isolate_features_to_fasta(@isolate_ids);


sub file_to_array {
    my $file  = shift;

    my @files;
    open my $fhd, '<', $file or die $!;
    while(<$fhd>) {
        chomp;
        push @files, $_;
    }
    close $fhd;
    
    return @files;
}

sub get_isolateID_by_sangerID {
    my $sanger_id  = shift;

    my $isolate_id;
    #well this will fail if the ID is not there...
    eval {
        $isolate_id = $SCHEMA->resultset('HomIsolates')->search({ sanger_id => $sanger_id })->first->id;
    }; 
    if ($@) {
        die "Looks like isolate with name $sanger_id is not in our DB, dying!";
    }
    
    return $isolate_id;
}

sub isolate_features_to_fasta {
    my (@isolate_ids) = @_;
    
    
    for my $isolate_id (@isolate_ids) {
        
        my $io = Bio::SeqIO->new(-file => '>' . $isolate_id . '.fasta', -format => 'fasta');
        
        my $feature_content_rs = get_feature_content_rs_by_isolate_id($isolate_id, $opt_ANALYSIS_ID);
        
        while(my $feature = $feature_content_rs->next ) {
                
            my $seq = Bio::PrimarySeq->new( -seq => $feature->dna, 
                                            -id  => $feature->feature_id 
                                          );
            $io->write_seq($seq);
            print "Done ", $feature->id, "\n";  
        }
    }      
}

#get hom_feature_contents result set by isolate id
sub get_feature_content_rs_by_isolate_id {
    my ($isolate_id, $analysis_id ) = @_;
    
    my $rs = $SCHEMA->resultset('HomFeature')
    ->search({ isolate_id => $isolate_id }, { $analysis_id => $analysis_id } )->search_related('hom_feature_contents');
    
    return $rs;
    
}

__END__

=head1 NAME

=head1 SYNOPSIS

B<hom_db_2_fasta.pl>  options ...
   
 Options:
   -help|h                  brief help message
   -dbpassword|p=s'     => \$opt_PASSWORD,
   -sanger_id_file|s=s' => \$opt_SANGER_ID_FILE,
   -analysis_id|a=i'    => \$opt_ANALYSIS_ID,

=head1 DESCRIPTION

Insert features from an FASTA file into DB

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exit.

=back

=head1 VERSION

Version 0.01

=cut

