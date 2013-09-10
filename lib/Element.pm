package Element;
use Moose;

has 'id' => (
    is => 'rw',
    isa => 'Int',
    );

has 'sanger_id' => (
    is => 'rw',
    isa => 'Str',
    );

has 'product' => (
    is => 'rw',
    isa => 'Str',
    );

has dna_seq => (
    is => 'rw',
    isa => 'Bio::Seq',
    );

has protein_seq => (
    is => 'rw',
    isa => 'Bio::Seq',
    );

no Moose;
__PACKAGE__->meta->make_immutable;
