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
   
    
    
    my $sth = $DBH->prepare("INSERT INTO hom_isolates(sanger_id, strain_id, remarks) VALUES (?, ?, ?)");

    open IN, $opt_METADATA or die $!;
    my $i =1;
    while(<IN>) {
        
        my ($first, @others) = split "\t", $_;

        my @fields = ($first, $first, join("\t", @others) );
        
        #dont chomp the whole line but chomp the last element as 
        #the excel file has some empty fields towards the end
        chomp $fields[$#fields];
        
        if (scalar @fields != 3) {
            die "Rolling back all inserts for this file! I expected 3 fields for each isolate but got:" . scalar @fields ;    
            
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
