use utf8;
package Homolog::Schema::Result::OrthoInParalog;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Homolog::Schema::Result::OrthoInParalog

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<ortho_InParalog>

=cut

__PACKAGE__->table("ortho_InParalog");

=head1 ACCESSORS

=head2 sequence_id_a

  data_type: 'varchar'
  is_nullable: 1
  size: 60

=head2 sequence_id_b

  data_type: 'varchar'
  is_nullable: 1
  size: 60

=head2 taxon_id

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 unnormalized_score

  data_type: 'float'
  is_nullable: 1

=head2 normalized_score

  data_type: 'float'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "sequence_id_a",
  { data_type => "varchar", is_nullable => 1, size => 60 },
  "sequence_id_b",
  { data_type => "varchar", is_nullable => 1, size => 60 },
  "taxon_id",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "unnormalized_score",
  { data_type => "float", is_nullable => 1 },
  "normalized_score",
  { data_type => "float", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-15 22:44:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Nigy0vCdGnXncatLJLA0aw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
