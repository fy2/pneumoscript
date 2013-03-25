use utf8;
package Homolog::Schema::Result::HomeFeatureContent;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Homolog::Schema::Result::HomeFeatureContent

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

=head1 TABLE: C<home_feature_contents>

=cut

__PACKAGE__->table("home_feature_contents");

=head1 ACCESSORS

=head2 feature_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 dna

  data_type: 'text'
  is_nullable: 1

=head2 translation

  data_type: 'text'
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "feature_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "dna",
  { data_type => "text", is_nullable => 1 },
  "translation",
  { data_type => "text", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</feature_id>

=back

=cut

__PACKAGE__->set_primary_key("feature_id");

=head1 RELATIONS

=head2 feature

Type: belongs_to

Related object: L<Homolog::Schema::Result::HomFeature>

=cut

__PACKAGE__->belongs_to(
  "feature",
  "Homolog::Schema::Result::HomFeature",
  { id => "feature_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-25 15:05:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zBIy9Mgyml+gw80pfFbgSg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
