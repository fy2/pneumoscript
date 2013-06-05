use utf8;
package Genome::Schema::Result::FeatureSequence;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Genome::Schema::Result::FeatureSequence

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<feature_sequences>

=cut

__PACKAGE__->table("feature_sequences");

=head1 ACCESSORS

=head2 dna_id

  data_type: 'integer'
  is_nullable: 1

=head2 proteins_id

  data_type: 'integer'
  is_nullable: 1

=head2 features_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "dna_id",
  { data_type => "integer", is_nullable => 1 },
  "proteins_id",
  { data_type => "integer", is_nullable => 1 },
  "features_id",
  { data_type => "integer", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-06-05 07:17:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:H8L6T+q91Vkci+T/EYPfGw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
