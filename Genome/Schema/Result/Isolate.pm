use utf8;
package Genome::Schema::Result::Isolate;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Genome::Schema::Result::Isolate

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<isolates>

=cut

__PACKAGE__->table("isolates");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 remarks

  data_type: 'text'
  is_nullable: 1

=head2 sanger_id

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "remarks",
  { data_type => "text", is_nullable => 1 },
  "sanger_id",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-06-04 14:31:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aRh+ngLdqz+G6unXnUBrig


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
