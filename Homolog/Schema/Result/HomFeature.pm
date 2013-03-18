use utf8;
package Homolog::Schema::Result::HomFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Homolog::Schema::Result::HomFeature

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

=head1 TABLE: C<hom_features>

=cut

__PACKAGE__->table("hom_features");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 start

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 end

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 strand

  data_type: 'integer'
  is_nullable: 1

=head2 dna

  data_type: 'text'
  is_nullable: 1

=head2 translation

  data_type: 'text'
  is_nullable: 1

=head2 isolate_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 analysis_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 group_id

  data_type: 'integer'
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 product

  data_type: 'varchar'
  is_nullable: 1
  size: 80

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "start",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "end",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "strand",
  { data_type => "integer", is_nullable => 1 },
  "dna",
  { data_type => "text", is_nullable => 1 },
  "translation",
  { data_type => "text", is_nullable => 1 },
  "isolate_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "analysis_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "group_id",
  { data_type => "integer", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "product",
  { data_type => "varchar", is_nullable => 1, size => 80 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 analysis

Type: belongs_to

Related object: L<Homolog::Schema::Result::HomAnalysis>

=cut

__PACKAGE__->belongs_to(
  "analysis",
  "Homolog::Schema::Result::HomAnalysis",
  { id => "analysis_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 hom_comparisons_feature_bs

Type: has_many

Related object: L<Homolog::Schema::Result::HomComparison>

=cut

__PACKAGE__->has_many(
  "hom_comparisons_feature_bs",
  "Homolog::Schema::Result::HomComparison",
  { "foreign.feature_b_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 hom_comparisons_features_a

Type: has_many

Related object: L<Homolog::Schema::Result::HomComparison>

=cut

__PACKAGE__->has_many(
  "hom_comparisons_features_a",
  "Homolog::Schema::Result::HomComparison",
  { "foreign.feature_a_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 hom_group_compsitions

Type: has_many

Related object: L<Homolog::Schema::Result::HomGroupCompsition>

=cut

__PACKAGE__->has_many(
  "hom_group_compsitions",
  "Homolog::Schema::Result::HomGroupCompsition",
  { "foreign.feature_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 isolate

Type: belongs_to

Related object: L<Homolog::Schema::Result::HomIsolates>

=cut

__PACKAGE__->belongs_to(
  "isolate",
  "Homolog::Schema::Result::HomIsolates",
  { id => "isolate_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-18 17:40:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:um6zVpQzVR5FJHxEmcFf4g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
