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

most the 'heavy' columns to home_feature_contents table as this table can grow very large and querying could be slowed down by bigger columns.

=head2 isolate_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 analysis_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 product

  data_type: 'varchar'
  is_nullable: 1
  size: 80

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "isolate_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "analysis_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
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

=head2 hom_feature_contents

Type: has_many

Related object: L<Homolog::Schema::Result::HomFeatureContent>

=cut

__PACKAGE__->has_many(
  "hom_feature_contents",
  "Homolog::Schema::Result::HomFeatureContent",
  { "foreign.feature_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 hom_group_compositions

Type: has_many

Related object: L<Homolog::Schema::Result::HomGroupComposition>

=cut

__PACKAGE__->has_many(
  "hom_group_compositions",
  "Homolog::Schema::Result::HomGroupComposition",
  { "foreign.feature_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 home_feature_content

Type: might_have

Related object: L<Homolog::Schema::Result::HomeFeatureContent>

=cut

__PACKAGE__->might_have(
  "home_feature_content",
  "Homolog::Schema::Result::HomeFeatureContent",
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


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-25 15:05:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hEI8pWbTwlFABEpxX5S5tg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
