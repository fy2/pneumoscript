use vars qw($VERSION);

$VERSION="0.01";

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use DBI;

my ($opt_help, $opt_man);
my ($opt_METADATA, $opt_ROLE, $opt_SQLITE_DB);
GetOptions(
  'help|h'         => \$opt_help,
  'metadata|m=s'   => \$opt_METADATA,
) or pod2usage(-verbose => 1) && exit;

pod2usage(-verbose => 1) && exit if defined $opt_help;
pod2usage(-verbose => 1) && exit unless 
                           (
                           defined $opt_METADATA 
                           );

my $ps = <STDIN>;
chomp $ps;

my $dsn = "DBI:mysql:database=pathogen_fy2_test;host=mcs6;port=3346";
my $DBH = DBI->connect($dsn, 'fy2', $ps, {RaiseError => 1, AutoCommit => 0} );


insert_meta_data();

$DBH->commit();
$DBH->disconnect;


sub insert_meta_data {
   
    
    
    my $sth = $DBH->prepare("INSERT INTO hom_isolates(sanger_id, sanger_study_id, site, country_of_origin, country_contact, mta_agreement, strain_id, strain_id_sanger, top_serotype, top_serotype_perc, second_serotype, second_serotype_perc, mlst, analysis_status, analysis_comment, gender, age_in_years, age_in_months, body_source, meningitis_outbreak_isolate, hiv, date_of_isolation, context, region, city, hospital, latitude, longitude, location_country, location_city, cd4_count, age_category, no, lab_no, country_st, country, date_received, culture_received, sa_st, sa_penz, sa_eryz, sa_cliz, sa_tetz, sa_chlz, sa_rifz, sa_optz, sa_penmic, sa_amomic, sa_furmic, sa_cromic, sa_taxmic, sa_mermic, sa_vanmic, sa_erymic, sa_telmic, sa_climic, sa_tetmic, sa_cotmic, sa_chlmic, sa_cipmic, sa_levmic, sa_rifmic, sa_linmic, sa_synmic) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

    open IN, $opt_METADATA or die $!;
    my $i =1;
    while(<IN>) {
        
        my @fields = split "\t", $_;
        
        #dont chomp the whole line but chomp the last element as 
        #the excel file has some empty fields towards the end
        chomp $fields[$#fields];
        
        if (scalar @fields != 64) {
            die "Rolling back all inserts for this file! I expected 64 fields for each isolate but got:" . scalar @fields ;    
            
        }
                                     
                                    
        $sth->execute(@fields);        
        print "Inserted ", $i++, " rows into database\n";
    }

}



__END__

=head1 NAME

 insert_metadata.pl

=head1 SYNOPSIS

B<insert_metadata.pl> [options...]

 Arguments:
   -metadata|d    meta data file with 65 fields for each isolate
   
 Options:
   -help|h        brief help message
   -metadata|m=s'   => \$opt_METADATA,

=head1 DESCRIPTION

B<insert_metadata.pl> will create necessary file links 
in PageApp's database for a given set of files and a role.

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exit.

=back

=head1 VERSION

Version 0.01

=cut
