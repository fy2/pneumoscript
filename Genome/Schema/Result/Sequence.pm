use utf8;
package Genome::Schema::Result::Sequence;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Genome::Schema::Result::Sequence

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<sequences>

=cut

__PACKAGE__->table("sequences");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 dna_id

  data_type: 'integer'
  is_nullable: 1

=head2 protein_id

  data_type: 'integer'
  is_nullable: 1

=head2 isolate_id

  data_type: 'integer'
  is_nullable: 1

=head2 product

  data_type: 'text'
  is_nullable: 1

=head2 group_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "dna_id",
  { data_type => "integer", is_nullable => 1 },
  "protein_id",
  { data_type => "integer", is_nullable => 1 },
  "isolate_id",
  { data_type => "integer", is_nullable => 1 },
  "product",
  { data_type => "text", is_nullable => 1 },
  "group_id",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-09-17 11:31:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jIa65B5JJtpm2ASzdSSdtg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
