package CoreStats;
use Moose;
use Data::Dumper;

sub get_random_isolates {
    my ($self, $isolate_arr, $how_many) = @_;
    die 'Error: isolate arg empty' if (scalar @{ $isolate_arr } == 0);
    my %seen;
    my @ids;
    my $total = @{ $isolate_arr };
    $total--;
    while($how_many > 0) {
        my $id = int(rand($total));
        if ( not (exists $seen{$id}) ) {
            my $isolate = $isolate_arr->[$id];
            die unless (ref $isolate eq 'Isolate');
            push @ids, $isolate;
            $seen{$id} = 1;
            $how_many--;
        }
    }
    return \@ids;
}

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
