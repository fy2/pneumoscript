use utf8;
package Homolog::Schema::Result::HomGroupCompsition;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Homolog::Schema::Result::HomGroupCompsition

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

=head1 TABLE: C<hom_group_compsitions>

=cut

__PACKAGE__->table("hom_group_compsitions");

=head1 ACCESSORS

=head2 feature_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 group_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "feature_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "group_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 RELATIONS

=head2 feature

Type: belongs_to

Related object: L<Homolog::Schema::Result::HomFeature>

=cut

__PACKAGE__->belongs_to(
  "feature",
  "Homolog::Schema::Result::HomFeature",
  { id => "feature_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 group

Type: belongs_to

Related object: L<Homolog::Schema::Result::HomGroup>

=cut

__PACKAGE__->belongs_to(
  "group",
  "Homolog::Schema::Result::HomGroup",
  { id => "group_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-18 17:40:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fx6+DaQO1IHD/oclGdV2Sg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
