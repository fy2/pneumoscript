use utf8;
package Homolog::Schema::Result::HomGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Homolog::Schema::Result::HomGroup

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

=head1 TABLE: C<hom_groups>

=cut

__PACKAGE__->table("hom_groups");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 analysis_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "analysis_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
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

=head2 hom_group_compositions

Type: has_many

Related object: L<Homolog::Schema::Result::HomGroupComposition>

=cut

__PACKAGE__->has_many(
  "hom_group_compositions",
  "Homolog::Schema::Result::HomGroupComposition",
  { "foreign.group_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-25 14:40:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DnHHJnW9uTs3X/PD3A+ecA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
