package CoreUtil;
use Moose;
use Data::Dumper;


has db => (
    is => 'ro',
    isa => 'CoreDB',
    required => 1,
);

=head2 make_protein_seqlen_matrix

Make a matrix of protein sequence lengths for each
protein group ID

=cut

sub make_protein_seqlen_matrix {
    my ($self) = @_;

    my @group_ids = $self->db->get_protein_group_ids;
    foreach my $id (@group_ids) {
        my @lens = sort { $a <=> $b } $self->db->get_clustered_protein_lengths_by_group_id($id);
        print join " ", ( "id_$id", @lens);
        print "\n";
    }
}


no Moose;
__PACKAGE__->meta->make_immutable;
