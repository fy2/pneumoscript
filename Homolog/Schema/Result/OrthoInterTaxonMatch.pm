use utf8;
package Homolog::Schema::Result::OrthoInterTaxonMatch;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Homolog::Schema::Result::OrthoInterTaxonMatch - VIEW

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

=head1 TABLE: C<ortho_InterTaxonMatch>

=cut

__PACKAGE__->table("ortho_InterTaxonMatch");

=head1 ACCESSORS

=head2 query_id

  data_type: 'varchar'
  is_nullable: 1
  size: 60

=head2 subject_id

  data_type: 'varchar'
  is_nullable: 1
  size: 60

=head2 subject_taxon_id

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 evalue_mant

  data_type: 'float'
  is_nullable: 1

=head2 evalue_exp

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "query_id",
  { data_type => "varchar", is_nullable => 1, size => 60 },
  "subject_id",
  { data_type => "varchar", is_nullable => 1, size => 60 },
  "subject_taxon_id",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "evalue_mant",
  { data_type => "float", is_nullable => 1 },
  "evalue_exp",
  { data_type => "integer", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-15 22:44:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Jgbs5g/gzT0yopfwduMmSg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
