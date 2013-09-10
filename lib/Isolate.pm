package Isolate;
use Moose;

has 'id' => (
    is => 'rw',
    isa => 'Str',
    );

has 'remark' => (
    is => 'rw',
    isa => 'Str',
    );

has 'sanger_id' => (
    is => 'rw',
    isa => 'Str',
    );


no Moose;
__PACKAGE__->meta->make_immutable;
