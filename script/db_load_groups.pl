#!/usr/bin/env perl
use strict;
use warnings;
use lib '..';
use Getopt::Long;
use Pod::Usage;
use Bio::SeqIO;
use Genome::Schema;

my ($opt_help, $opt_man, $opt_type);

GetOptions(
  'help|h'         => \$opt_help,
) or pod2usage(-verbose => 1) && exit;

pod2usage(-verbose => 1) && exit if defined $opt_help;
pod2usage(-verbose => 1) && exit unless (@ARGV == 3);


my ($DB, $mcl, $type)  =  @ARGV;

my $dsn = "DBI:SQLite:$DB";
my $SCHEMA = Genome::Schema->connect("dbi:SQLite:$DB", { AutoCommit => 0 },);

if ($type =~ /protein/i) {
    insert_protein_groups();
} 
elsif ($type =~ /dna/i) {
    insert_dna_groups();
} 
else {
    print $type, "\n";
    pod2usage(-verbose => 1) && exit;
}


sub insert_protein_groups {

    $SCHEMA->txn_begin;
    open my $fh, "<" . $mcl or die $!;
    my $i = 0;
    my $group_id = 0;
    while(<$fh>) {
        chomp;
        $group_id++;
        my @ids  = split "\t", $_;
        my $rs = $SCHEMA->resultset('Gene')
                    ->search({protein_id => { '-in' => [ @ids ] } });

        while (my $gene = $rs->next) { 
            $gene->protein_group_id($group_id);
            $gene->update;
            $i++;
            if (not $i % 1000) {
                print $i, "\n"; 
                $SCHEMA->txn_commit;
                $SCHEMA->txn_begin;
            }
        }
    }
    $SCHEMA->txn_commit;
    print "$group_id protein groups inserted\n";
}

sub insert_dna_groups {

    $SCHEMA->txn_begin;
    open my $fh, "<" . $mcl or die $!;
    my $i = 0;
    my $group_id = 0;
    while(<$fh>) {
        chomp;
        $group_id++;
        my @ids  = split "\t", $_;
        my $rs = $SCHEMA->resultset('Gene')
                    ->search({dna_id => { '-in' => [ @ids ] } });

        while (my $gene = $rs->next) { 
            $gene->dna_group_id($group_id);
            $gene->update;
            $i++;
            if (not $i % 1000) {
                print $i, "\n"; 
                $SCHEMA->txn_commit;
                $SCHEMA->txn_begin;
            }
        }
    }
    $SCHEMA->txn_commit;
    print "$group_id dna groups inserted\n";
}


__END__

=head1 NAME

=head1 SYNOPSIS

B<$0> [SQLite DB] [MCL dump file] [protein|dna]

 Options:
   -help|h        brief help message

=head1 DESCRIPTION

=over 8

=item B<-help>

Print a brief help message and exit.

=back

=head1 VERSION

Version 0.01

=cut
