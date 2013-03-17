#!/usr/bin/env perl
use strict;
use warnings;
use Homolog::Schema;
use Bio::SeqIO;
use Getopt::Long;
use Pod::Usage;

my ($opt_help, $opt_man, $opt_password, $opt_analysis_id);
GetOptions(
  'help|h'         => \$opt_help,
  'password|p=s'   => \$opt_password,
  'analysis_id|a=i'   => \$opt_analysis_id,
) or pod2usage(-verbose => 1) && exit;

pod2usage(-verbose => 1) && exit if defined $opt_help;
pod2usage(-verbose => 1) && exit unless 
                           (
                               defined $opt_password
                           );

my @embl_files = @ARGV;

my $SCHEMA = Homolog::Schema->connect('dbi:mysql:pathogen_fy2_test:mcs6:3346', 'fy2', $opt_password);



foreach my $embl (@embl_files) {

    #remove any any preceeding paths or trailing extensions 
    #from file name args:
    my ($name) = $embl =~ /(?:.*\/)*([^.]+)/;
   
    my $isolate_id; 
    #well this will fail if the ID is not there...
    eval {
        $isolate_id = $SCHEMA->resultset('HomIsolates')->search({ sanger_id => $name })->first->id;
    }; 
    if ($@) {
        die "Looks like isolate with name $name is not in our DB, dying!";
    }
    else {
        #inserts embl features into the database
        insert_features( $embl, $isolate_id ); #insert into features table 
    }
}


#inserts embl features into the hom_features table

sub insert_features {

    my ($file, $id) = @_;

    my $seqio = Bio::SeqIO->new(-file => $file );
   
    while ( my $seq = $seqio->next_seq ) {

        for my $feat ($seq->get_SeqFeatures) {

            #get the feature details:
            if ($feat->primary_tag eq "CDS") {
               
                my @tags;
                my $product = my $translation = -1;
                TAG: 
                for my $tag ($feat->get_all_tags) {             
                     
                     
                    if ($tag eq 'product')  {
                        $product = join ',', $feat->get_tag_values($tag);
                        $feat->remove_tag('product');
                    } 
                    elsif ($tag eq 'translation')   {
                        $translation = join ',', $feat->get_tag_values($tag);
                        $feat->remove_tag('translation')
                    }
                    
                }

            #start inserting the feature
            #into the DB:
            my $inserted = $SCHEMA->resultset('HomFeature')->create({
                                                 dna         => $feat->spliced_seq->seq,
                                                 translation => $translation,
                                                 product     => $product,
                                                 description => $feat->gff_string, 
                                                 isolate_id  => $id,
                                                 analysis_id => $opt_analysis_id,
                                               });
            print 'Inserted: ', $inserted->id, "\n";

            }
        }
    }
}




__END__

=head1 NAME

=head1 SYNOPSIS

B<hom_embl_2_db.pl> -p password  embl1 embl2 ...
   
 Options:
   -help|h        brief help message
   -dbpassword|p=s
   -analysis_id|a=i

=head1 DESCRIPTION

Insert features from an EMBL file into DB, check if isolate exists in DB by inspecting embl file name's prefix.

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exit.

=back

=head1 VERSION

Version 0.01

=cut

