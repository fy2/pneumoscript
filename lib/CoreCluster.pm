package CoreCluster;
use Moose;

has 'id' => (
    is => 'rw',
    isa => 'Int',
    );

has 'type' => (
    is => 'rw',
    isa => 'Str',
    );

has 'remark' => (
    is => 'rw',
    isa => 'Str',
    );

has members => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    );


no Moose;
__PACKAGE__->meta->make_immutable;
