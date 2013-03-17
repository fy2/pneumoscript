#!/usr/bin/env perl
use strict;
use warnings;
use Homolog::Schema;
use Bio::SeqIO;
use Getopt::Long;
use Pod::Usage;

my ($opt_help, $opt_man, $opt_password, $opt_trans, $opt_dna);
GetOptions(
  'help|h'         => \$opt_help,
  'password|p=s'   => \$opt_password,
  'translation|t=s' => \$opt_trans,
  'dna|d=s'         => \$opt_dna,
) or pod2usage(-verbose => 1) && exit;

pod2usage(-verbose => 1) && exit if defined $opt_help;
pod2usage(-verbose => 1) && exit unless 
                           (
                               defined $opt_password
                               and 
                               (defined $opt_trans or defined $opt_dna)
                           );



my $SCHEMA = Homolog::Schema->connect('dbi:mysql:pathogen_fy2_test:mcs6:3346', 'fy2', $opt_password);


if (defined $opt_trans or defined $opt_dna) {
    insert_translation_and_dna();
} 
elsif (defined $opt_trans) {
    insert_translation();
} 
else {
    insert_dna();
}


sub insert_dna {
    
    my $io = Bio::SeqIO->new(-file => $opt_dna);
    
    my $isolate_name = _get_isolate_name($opt_dna);
    my $isolate_id   = _get_isolate_id_by_name($isolate_name);

    while (my $seq = $io->next_seq) {
            #start inserting into the DB:
            my $inserted = $SCHEMA->resultset('HomFeature')->create({
                                                 dna         => $seq->seq,
                                                 description => $seq->id . $seq->desc, 
                                                 hom_isolates_id  => $isolate_id,
                                               });
            print 'Inserted: ', $inserted->id, "\n";       
    }
}


sub insert_translation {
    my $io = Bio::SeqIO->new(-file => $opt_trans);
    
    my $isolate_name = _get_isolate_name($opt_trans);
    my $isolate_id   = _get_isolate_id_by_name($isolate_name);

    while (my $seq = $io->next_seq) {
            #start inserting into the DB:
            my $inserted = $SCHEMA->resultset('HomFeature')->create({
                                                 translation      => $seq->seq,
                                                 description      => $seq->id . $seq->desc, 
                                                 hom_isolates_id  => $isolate_id,
                                               });
            print 'Inserted: ', $inserted->id, "\n";       
    }    
}

sub insert_translation_and_dna {
    
    my $iodna = Bio::SeqIO->new(-file => $opt_dna);
    my $iotrans = Bio::SeqIO->new(-file => $opt_trans);
    
    my $isolate_name = _get_isolate_name($opt_dna);
    my $isolate_id   = _get_isolate_id_by_name($isolate_name);

    while (my $seqdna = $iodna->next_seq) {
            my $seqtrans = $iotrans->next_seq;
            #start inserting into the DB:
            my $inserted = $SCHEMA->resultset('HomFeature')->create({
                                                 dna         => $seqdna->seq,
                                                 translation => $seqtrans->seq,
                                                 description =>   'DNA_FILE_DESC: '         . $opt_dna   . ', ' . $seqdna->id . $seqdna->desc 
                                                                . ' TRANSLATION_FILE_DESC: ' . $opt_trans . ', ' . $seqtrans->id . $seqtrans->desc,
                                                       
                                                 hom_isolates_id  => $isolate_id,
                                               });
            print 'Inserted: ', $inserted->id, "\n";       
    }
}
#inserts embl features into the hom_features table



sub _get_isolate_name {
    my $file_name = shift;
    
     #remove any any preceeding paths or trailing extensions 
    #from file name args:
    my ($name) = $file_name =~ /(?:.*\/)*([^.]+)/;
    
    return $name if $name;
    
    die 'Couldnt parse the name from: ' . $file_name;
}

sub _get_isolate_id_by_name {
    my $name = shift;
    
    my $isolate_id; 
    #well this will fail if the ID is not there...
    eval {
        $isolate_id = $SCHEMA->resultset('HomIsolates')->search({ sanger_id => $name })->first->id;
    }; 
    if ($@) {
        die "Looks like isolate with name $name is not in our DB, dying!";
    }
   
    return $isolate_id;
}







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
                                                 hom_isolates_id  => $id,
                                               });
            print 'Inserted: ', $inserted->id, "\n";

            }
        }
    }
}




__END__

=head1 NAME

=head1 SYNOPSIS

B<hom_fasta_2_db.pl> -p password  -translation -dna ...
   
 Options:
   -help|h        brief help message
   -dbpassword|p=s' => \$opt_password,
   -translation|t=s' => \$opt_trans, FASTA format
   -dna|d=s'         => \$opt_dna  FASTA format

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

