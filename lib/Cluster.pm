package Cluster;
use Moose;

has 'id' => (
    is => 'rw',
    isa => 'Int',
    );

#DNA/protein
has 'type' => (
    is => 'rw',
    isa => 'Str',
    );

#Bacteraemia/Meningitis
has 'remark' => (
    is => 'rw',
    isa => 'Str',
    );

#Choline binding protein, tetM etc...
has 'product' => (
    is => 'rw',
    isa => 'Str',
    );


has members => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    );

has member_count => (
    is => 'rw',
    isa => 'Int',
    );



no Moose;
__PACKAGE__->meta->make_immutable;
