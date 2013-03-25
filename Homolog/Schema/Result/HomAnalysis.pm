use utf8;
package Homolog::Schema::Result::HomAnalysis;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Homolog::Schema::Result::HomAnalysis

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

=head1 TABLE: C<hom_analysis>

=cut

__PACKAGE__->table("hom_analysis");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

a single orthology with orthomcl analysis will constitute an experiment

=head2 user

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 remarks

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 software_params

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 software_versions

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "user",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "remarks",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "software_params",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "software_versions",
  { data_type => "varchar", is_nullable => 1, size => 200 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 hom_features

Type: has_many

Related object: L<Homolog::Schema::Result::HomFeature>

=cut

__PACKAGE__->has_many(
  "hom_features",
  "Homolog::Schema::Result::HomFeature",
  { "foreign.analysis_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 hom_groups

Type: has_many

Related object: L<Homolog::Schema::Result::HomGroup>

=cut

__PACKAGE__->has_many(
  "hom_groups",
  "Homolog::Schema::Result::HomGroup",
  { "foreign.analysis_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-25 14:40:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CJzW2e/mdpD4XxuAJc+r0w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
