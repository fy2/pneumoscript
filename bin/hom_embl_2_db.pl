#!/usr/bin/env perl
use strict;
use warnings;
use Homolog::Schema;
use Bio::SeqIO;

my $ps = <STDIN>;
chomp $ps;
my $SCHEMA = Homolog::Schema->connect('dbi:mysql:pathogen_fy2_test:mcs6:3346', 'fy2', $ps);



my @embl_files = @ARGV;

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

            if ($feat->primary_tag eq "CDS") {
               
                my (@tags, $product, $translation);
                TAG: 
                for my $tag ($feat->get_all_tags) {             
                     
                     
                    if ($tag eq 'product')  {
                        $product = $feat->get_tag_values($tag);
                    } 
                    elsif ($tag eq 'translation')   {
                        $translation = $feat->get_tag_values($tag);
                    }
                    else {
                        push @tags, $tag . "\t" . $feat->get_tag_values($tag);
                    }
                    
                }
              
            $SCHEMA->resultset('HomFeatures')->create({
                                                 dna         => $feat->spliced_seq->seq,
                                                 translation => $translation || '',
                                                 product     => $product || '',
                                               });
            }
        }
    }
}
