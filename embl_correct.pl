use strict;
use warnings;
use Bio::SeqIO;
use Data::Dumper;

my $seqio_object = Bio::SeqIO->new(-file => $ARGV[0], -format => 'embl' );       
my $out = Bio::SeqIO->new(-file => ">". $ARGV[0] . ".correct.embl", '-format' => 'EMBL');


my @seq_array;
my @valid_tags = qw(allele artificial_location citation codon_start db_xref EC_number exception experiment function gene gene_synonym inference locus_tag map note number old_locus_tag operon product protein_id pseudogene ribosomal_slippage standard_name translation transl_except transl_table trans_splicing);
my %val;
foreach my $key (@valid_tags) {
	$val{uc($key)}++;
}

my $seqobj;
while($seqobj = $seqio_object->next_seq()){
     foreach my $feat ( $seqobj->all_SeqFeatures ) {
           my @tags = $feat->get_all_tags();
           my @notes;
           my $citations_added = 0;
           foreach my $tag ( @tags ) 
           {
#	 	print "INvalid: $tag\n" unless ( exists $val{uc($tag)} ) {
           	if ($tag =~ /orthologue/i) {
			$feat->remove_tag($tag);
                        push(@notes, $tag);
           		$feat->add_tag_value('note', $tag);
                }
          } 
          if ($feat->has_tag('citation')) {
                  my @vals = $feat->get_tag_values('citation');
		  $feat->{'_gsf_tag_hash'}->{'citation'} = [];
		  foreach my $tag_val (@vals) {
		       if ($tag_val =~ /\D+(\d+)/) {
                          $feat->add_tag_value('citation', '['.  $1 . ']' );
			   $citations_added = 1;
		       }
		  }
		  $feat->add_tag_value('note', 'citation numbers may refer to PMIDs') if $citations_added;
          }
      }
      $out->write_seq($seqobj);
}
