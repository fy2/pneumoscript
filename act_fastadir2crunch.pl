#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(usleep);


my $dir = $ARGV[0] or die "no directory with fasta files supplied?";

#read the dir, return arref of .fasta files
my $fastas = read_dir_data($dir);

#create an NCBI database for each fasta file
formatdb_each_fasta($fastas);

#for each combined unique pair create one crunch file
create_crunch_files($fastas);



sub read_dir_data {
     my ($some_dir) = @_;

    opendir(DIR, $some_dir) || die "can’t opendir $some_dir: $!";
    my @fasta_files = grep { /.fasta$/ && -f "$some_dir/$_" } readdir(DIR);
    closedir DIR;
    return \@fasta_files;
}

sub formatdb_each_fasta {
    my $files = shift;

    foreach my $file (@$files) {
        unless (-e "$dir/$file.nhr" and -e "$dir/$file.nin") {
            warn "formatdb database is missing for $dir/$file, will create it now...";
            my $cmd = "formatdb -p F -i $dir/$file";
            die "error in $cmd" if (system($cmd));
        }
    }
}

sub create_crunch_files {
    my $files = shift or die "no input";

    my %seen;
    foreach my $file1 (@$files) {

        foreach my $file2 (@$files) {

            my ($query, $subject) = sort { $a cmp $b } ($file1, $file2);
            if (not exists $seen{$query. $subject}) {
                _run_blast($query, $subject);
                usleep(200000); #sleeps for 200K microseconds (i.e. 2/10th of a second)
            }
            $seen{$query. $subject} = 1;
        }
    }
}

sub _run_blast {
    my ($query, $subject) = @_;

    my $blast_output_file_name = "$query.$subject.crunch";
    $blast_output_file_name =~ s/\.fasta//g;
    my $cmd = "bsub -q basement -o $dir/$blast_output_file_name.bout -e /dev/null 'blastall -p blastn -d $dir/$subject -i $dir/$query -m 8 -o $dir/$blast_output_file_name'";
    die "bsub failed for: $cmd" if (system($cmd));
}
