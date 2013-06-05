use utf8;
package Genome::Schema::Result::Feature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Genome::Schema::Result::Feature

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<features>

=cut

__PACKAGE__->table("features");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 isolate_id

  data_type: 'integer'
  is_nullable: 1

=head2 product

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "isolate_id",
  { data_type => "integer", is_nullable => 1 },
  "product",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-06-05 07:08:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7EKJqWcSQcTK5try3MKQUw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
