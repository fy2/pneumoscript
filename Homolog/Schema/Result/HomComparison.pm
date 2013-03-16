use utf8;
package Homolog::Schema::Result::HomComparison;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Homolog::Schema::Result::HomComparison

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

=head1 TABLE: C<hom_comparisons>

=cut

__PACKAGE__->table("hom_comparisons");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 feature_a_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 feature_b_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 perc_identity

  data_type: 'float'
  is_nullable: 1

=head2 evalue

  data_type: 'float'
  is_nullable: 1

=head2 ortho_score_normalised

  data_type: 'float'
  is_nullable: 1

=head2 ortho_score_raw

  data_type: 'float'
  is_nullable: 1

=head2 relation

  data_type: 'enum'
  extra: {list => ["ortholog","paralog","co_ortholog","unknown"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "feature_a_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "feature_b_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "perc_identity",
  { data_type => "float", is_nullable => 1 },
  "evalue",
  { data_type => "float", is_nullable => 1 },
  "ortho_score_normalised",
  { data_type => "float", is_nullable => 1 },
  "ortho_score_raw",
  { data_type => "float", is_nullable => 1 },
  "relation",
  {
    data_type => "enum",
    extra => { list => ["ortholog", "paralog", "co_ortholog", "unknown"] },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 feature_a

Type: belongs_to

Related object: L<Homolog::Schema::Result::HomFeature>

=cut

__PACKAGE__->belongs_to(
  "feature_a",
  "Homolog::Schema::Result::HomFeature",
  { id => "feature_a_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 feature_b

Type: belongs_to

Related object: L<Homolog::Schema::Result::HomFeature>

=cut

__PACKAGE__->belongs_to(
  "feature_b",
  "Homolog::Schema::Result::HomFeature",
  { id => "feature_b_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-15 22:44:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:muy8bJgIe+2hZxAlwnuklw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
