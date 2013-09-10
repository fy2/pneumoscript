package CoreStats;
use Moose;
use Data::Dumper;
use List::Util qw(shuffle);

=head2 get_random_isolates

arrayref to isolates

=cut

sub get_random_isolates {
    my ($self, $isolate_arr, $how_many) = @_;
    die 'Error: isolate arg empty' if (scalar @{ $isolate_arr } == 0);
    
    my $all_isolate_count = scalar @{ $isolate_arr };
    $all_isolate_count--; #makes it a zero based

    #generate a range of random numbers, using List::Util::shuffle:
    my @shuffled_indices = List::Util::shuffle 0..$all_isolate_count;
   
    $how_many--; #makes it a zerobased upper bound
     
    my @random_indices = @shuffled_indices[0..$how_many];

    my @random_isolates;
    foreach my $idx (@random_indices) {
        push @random_isolates, $isolate_arr->[$idx];
    }
    
    return \@random_isolates;
}

=head2 get_associated_clusters

arrayref to cluster objects

=cut

sub get_associated_clusters {
    my ($self, $isolate_arr, $cluster_arr) = @_;
    die 'Error: Forgot to load clusters?' if (@{ $cluster_arr } == 0);

    my @isolates = @{ $isolate_arr };
    my $isolate_count = scalar @isolates;
    my %isohash;
    
    for my $iso (@isolates) {
        $isohash{$iso->id} = 1;
    }

    my @found_clusters;
    foreach my $cluster ( @{ $cluster_arr } ) {
        my $count=0;
        MEMBER_LOOP: foreach my $member ( @{$cluster->members} ) {
            if (exists $isohash{$member} ) {
                $count++;
            }
            if ($count == $isolate_count) {
                push @found_clusters, $cluster;
                last MEMBER_LOOP;
            } 
        }
    }
    return \@found_clusters;
}

no Moose;
__PACKAGE__->meta->make_immutable;
