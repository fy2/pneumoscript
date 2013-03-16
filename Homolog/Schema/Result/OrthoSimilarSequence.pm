use utf8;
package Homolog::Schema::Result::OrthoSimilarSequence;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Homolog::Schema::Result::OrthoSimilarSequence

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

=head1 TABLE: C<ortho_SimilarSequences>

=cut

__PACKAGE__->table("ortho_SimilarSequences");

=head1 ACCESSORS

=head2 query_id

  data_type: 'varchar'
  is_nullable: 1
  size: 60

=head2 subject_id

  data_type: 'varchar'
  is_nullable: 1
  size: 60

=head2 query_taxon_id

  data_type: 'varchar'
  is_nullable: 1
  size: 40

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

=head2 percent_identity

  data_type: 'float'
  is_nullable: 1

=head2 percent_match

  data_type: 'float'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "query_id",
  { data_type => "varchar", is_nullable => 1, size => 60 },
  "subject_id",
  { data_type => "varchar", is_nullable => 1, size => 60 },
  "query_taxon_id",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "subject_taxon_id",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "evalue_mant",
  { data_type => "float", is_nullable => 1 },
  "evalue_exp",
  { data_type => "integer", is_nullable => 1 },
  "percent_identity",
  { data_type => "float", is_nullable => 1 },
  "percent_match",
  { data_type => "float", is_nullable => 1 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<ss_qtaxexp_ix>

=over 4

=item * L</query_id>

=item * L</subject_taxon_id>

=item * L</evalue_exp>

=item * L</evalue_mant>

=item * L</query_taxon_id>

=item * L</subject_id>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "ss_qtaxexp_ix",
  [
    "query_id",
    "subject_taxon_id",
    "evalue_exp",
    "evalue_mant",
    "query_taxon_id",
    "subject_id",
  ],
);

=head2 C<ss_seqs_ix>

=over 4

=item * L</query_id>

=item * L</subject_id>

=item * L</evalue_exp>

=item * L</evalue_mant>

=item * L</percent_match>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "ss_seqs_ix",
  [
    "query_id",
    "subject_id",
    "evalue_exp",
    "evalue_mant",
    "percent_match",
  ],
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-15 22:44:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:y53PKXsg4IhDQRo9InsuQQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
