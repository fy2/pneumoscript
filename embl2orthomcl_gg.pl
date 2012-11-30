#!/usr/bin/env perl
use strict;
use warnings;
use Bio::SeqIO;
use Data::Dumper;

my $file = $ARGV[0]; 
my $seqio_object = Bio::SeqIO->new(-file => $file);
my $seq_object = $seqio_object->next_seq;

$file =~ s/\..+$//g;
my @gg_entries;
my $co = 1;
for my $feat_object ($seq_object->get_SeqFeatures) {

   if ($feat_object->primary_tag eq "CDS") {

       my $val;
       my $colour;
       TAG: for my $tag ($feat_object->get_all_tags) {             
             
             if ($tag eq 'colour') 
             {
                ($colour) = $feat_object->get_tag_values($tag);
             }


             if ($tag eq 'locus_tag') 
             {
                $val = join '_', $feat_object->get_tag_values($tag);
                last TAG;
             }
             elsif ($tag eq 'note')
             {
                  $val = join '_', $feat_object->get_tag_values($tag);
                  last TAG;
             }
             elsif ($tag eq 'product')
             {
                  $val = join '_', $feat_object->get_tag_values($tag);
                  last TAG;
             }
       }

      warn "no note no locus_tag around $co" unless $val;
      $val =~ s/[^A-Za-z0-9]+/_/g if $val;
      $val .= "_colour_$colour" if ($val and $colour);
      my $entry = join '',
            , $file
            , '_'
            , $co++
            , '_'
            , $val;

     push @gg_entries, $entry;
   }
}


#from orthomcl's readme:
#FORMAT of all.gg or "usr_gg_file"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Ath: At1g01190 At1g01280 At1g04160 ...
#Hsa: Hs10834998 Hs10835119 Hs10835271 ...
#Sce: YAL029c YAR009c YAR010c YHR023w ...

#Each line stands for each genome. Each line starts with genome name, followed by a
#colon ":", and then followed by all the gene id's separated by space key " ".

print $file, ':', ' ', join ' ', @gg_entries;
print "\n";

