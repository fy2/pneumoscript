#!/usr/bin/env perl
use strict;
use warnings;
use lib '..';
use Getopt::Long;
use Pod::Usage;
use Bio::SeqIO;
use Genome::Schema;

my ($opt_help, $opt_man);

GetOptions(
  'help|h'         => \$opt_help,
) or pod2usage(-verbose => 1) && exit;

pod2usage(-verbose => 1) && exit if defined $opt_help;
pod2usage(-verbose => 1) && exit unless (@ARGV == 2);


my ($DB, $mcl)  =  @ARGV;

my $dsn = "DBI:SQLite:$DB";
my $SCHEMA = Genome::Schema->connect("dbi:SQLite:$DB", { AutoCommit => 0 },);

insert_groups();

sub insert_groups {

    $SCHEMA->txn_begin;
    open my $fh, "<" . $mcl or die $!;
    my $i = 0;
    my $group_id = 0;
    my $seqtype;

    while(<$fh>) {
        chomp;
        my $line = $_;
        $group_id++;

        if ($line =~ /p/) {
            $seqtype = 'protein_id';
            $line =~ s/p//g;
        }
        elsif ($line =~ s/d//)
        {
            $seqtype = 'dna_id';
            $line =~ s/d//g;
        }
        else {
            die "unknown seqtype";
        }

        my @ids  = split "\t", $line;
        
        while(my @nextfifty = splice @ids, 0, 50) {
            my $rs = $SCHEMA->resultset('Sequence')
                        ->search({ $seqtype => { '-in' => [ @nextfifty ] } });

            while (my $sequence = $rs->next) { 
                $sequence->group_id($group_id);
                $sequence->update;
                $i++;
                if (not $i % 1000) {
                    print $i, "\n"; 
                    $SCHEMA->txn_commit;
                    $SCHEMA->txn_begin;
                }
            }
        }
    }
    $SCHEMA->txn_commit;
    print "$group_id groups inserted\n";
}

__END__

=head1 NAME

=head1 SYNOPSIS

B<$0> [SQLite DB] [MCL dump file]

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
