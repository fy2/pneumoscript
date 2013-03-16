use Homolog::Schema;
use Bio::SeqIO;

my $ps = <STDIN>;
chomp $ps;
my $schema = Homolog::Schema->connect('dbi:mysql:pathogen_fy2_test:mcs6:3346', 'fy2', $ps);



my @embl_files = @ARGV;

foreach my $embl (@embl_files) {

    my ($name) = $embl =~ /^(.+)\W/;
    my $isolate_db_id = $schema->resultset('HomIsolates')->search({ sanger_id => $name })->first->id;
    print 'Looking for ', $name, '. Found: ', $isolate_db_id, "\n";
}
