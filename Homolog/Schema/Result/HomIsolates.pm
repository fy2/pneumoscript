use utf8;
package Homolog::Schema::Result::HomIsolates;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Homolog::Schema::Result::HomIsolates

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

=head1 TABLE: C<hom_isolates>

=cut

__PACKAGE__->table("hom_isolates");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 remarks

  data_type: 'varchar'
  is_nullable: 1
  size: 200

isolates involved in a particular experiment

=head2 sanger_id

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 sanger_study_id

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 species

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 serotype

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 site

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 country_contact

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 mta_agreement

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 strain_id

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 strain_id_sanger

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 top_serotype

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 top_serotype_perc

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 25

for some reason, float and text is mixed in this column

=head2 second_serotype

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 second_serotype_perc

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 25

for some reason, float and text is mixed in this column

=head2 mlst

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 analysis_status

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 analysis_comment

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 gender

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 age_in_years

  data_type: 'integer'
  default_value: -1
  is_nullable: 1

=head2 age_in_months

  data_type: 'integer'
  default_value: -1
  is_nullable: 1

=head2 body_source

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 meningitis_outbreak_isolate

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 hiv

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 date_of_isolation

  data_type: 'varchar'
  is_nullable: 1
  size: 20

yyyy-mm-dd

=head2 context

  data_type: 'varchar'
  is_nullable: 1
  size: 45

surveillance? hospital?

=head2 country_of_origin

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 region

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 city

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 hospital

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 latitude

  data_type: 'float'
  default_value: -1
  is_nullable: 1

=head2 longitude

  data_type: 'float'
  default_value: -1
  is_nullable: 1

=head2 location_country

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 location_city

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 cd4_count

  data_type: 'integer'
  default_value: -1
  is_nullable: 1

=head2 age_category

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 no

  data_type: 'integer'
  default_value: -1
  is_nullable: 1

=head2 lab_no

  data_type: 'integer'
  default_value: -1
  is_nullable: 1

=head2 country_st

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 country

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 date_received

  data_type: 'varchar'
  is_nullable: 1
  size: 25

=head2 culture_received

  data_type: 'varchar'
  is_nullable: 1
  size: 25

=head2 sa_st

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_penz

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_eryz

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_cliz

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_tetz

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_chlz

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_rifz

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_optz

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_penmic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_amomic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_furmic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_cromic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_taxmic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_mermic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_vanmic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_erymic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_telmic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_climic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_tetmic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_cotmic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_chlmic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_cipmic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_levmic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_rifmic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_linmic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=head2 sa_synmic

  data_type: 'varchar'
  default_value: -1
  is_nullable: 1
  size: 5

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "remarks",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "sanger_id",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "sanger_study_id",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "species",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "serotype",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "site",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "country_contact",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "mta_agreement",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "strain_id",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "strain_id_sanger",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "top_serotype",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "top_serotype_perc",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 25 },
  "second_serotype",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "second_serotype_perc",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 25 },
  "mlst",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "analysis_status",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "analysis_comment",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "gender",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "age_in_years",
  { data_type => "integer", default_value => -1, is_nullable => 1 },
  "age_in_months",
  { data_type => "integer", default_value => -1, is_nullable => 1 },
  "body_source",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "meningitis_outbreak_isolate",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "hiv",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "date_of_isolation",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "context",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "country_of_origin",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "region",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "city",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "hospital",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "latitude",
  { data_type => "float", default_value => -1, is_nullable => 1 },
  "longitude",
  { data_type => "float", default_value => -1, is_nullable => 1 },
  "location_country",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "location_city",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "cd4_count",
  { data_type => "integer", default_value => -1, is_nullable => 1 },
  "age_category",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "no",
  { data_type => "integer", default_value => -1, is_nullable => 1 },
  "lab_no",
  { data_type => "integer", default_value => -1, is_nullable => 1 },
  "country_st",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "country",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "date_received",
  { data_type => "varchar", is_nullable => 1, size => 25 },
  "culture_received",
  { data_type => "varchar", is_nullable => 1, size => 25 },
  "sa_st",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_penz",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_eryz",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_cliz",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_tetz",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_chlz",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_rifz",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_optz",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_penmic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_amomic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_furmic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_cromic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_taxmic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_mermic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_vanmic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_erymic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_telmic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_climic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_tetmic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_cotmic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_chlmic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_cipmic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_levmic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_rifmic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_linmic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
  "sa_synmic",
  { data_type => "varchar", default_value => -1, is_nullable => 1, size => 5 },
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
  { "foreign.isolate_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-25 14:40:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jCk73rCgu1qPXoO8Td86uw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
