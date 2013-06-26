package CoreStats;
use Moose;
use Data::Dumper;

has 'isolates' => (
    traits => ['Array'],
    is => 'rw',
    isa => 'ArrayRef[Isolate]',
    default=> sub { [] },
    handles => {
        all_isolates   => 'elements',
        add_isolate    => 'push',
        clear_isolates => 'clear',
        count_isolates => 'count',
        get_isolate    => 'get',
    },
);

has 'clusters' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    );

sub get_random_isolates {
    my ($self, $how_many) = @_;
    die 'Error: Forgot to load isolates?' if ($self->count_isolates == 0);
    my %seen;
    my @ids;
    my $total = $self->count_isolates;
    $total--;
    while($how_many > 0) {
        my $id = int(rand($total));
        if ( not (exists $seen{$id}) ) {
            my $isolate = $self->get_isolate($id);
            die unless (ref $isolate eq 'Isolate');
            push @ids, $isolate;
            $seen{$id} = 1;
            $how_many--;
        }
    }
    return \@ids;
}

no Moose;
__PACKAGE__->meta->make_immutable;
