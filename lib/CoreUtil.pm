package CoreUtil;
use Moose;
use Data::Dumper;
use List::MoreUtils qw/ uniq /;

has db => (
    is => 'ro',
    isa => 'CoreDB',
    required => 1,
);

=head2 protein_length_matrix

Make a matrix of protein sequence lengths for each
group ID

=cut

sub protein_length_matrix {
    my ($self) = @_;

    my @group_ids = $self->db->get_group_ids;
    foreach my $id (@group_ids) {
        my @lens = sort { $a <=> $b } $self->db->get_clustered_protein_lengths_by_group_id($id);
        print join " ", ( "id_$id", @lens);
        print "\n";
    }
}

=head2 fasta_by_group_id

Make a fasta file for sequences by group ID

=cut

sub fasta_by_group_id {
    my ($self, $group_id) = @_;

    #Element.pm objects
    my @elements = $self->db->get_elements_by_group_id($group_id);
	open my $fn, ">", $group_id . '.nucl.fasta' or die $!; 
	open my $fa, ">", $group_id . '.prot.fasta' or die $!;
    foreach my $elem (@elements) {
    	my $fasta_header = _make_fasta_header($group_id, $elem);
    	print $fn $fasta_header . "\n" . $elem->dna_seq->seq . "\n";
    	print $fa $fasta_header . "\n" . $elem->protein_seq->seq . "\n";
    }
    close $fa;
    close $fn;
}

=head2 fasta_by_list

Make a fasta file for sequences by group ID

=cut

sub fasta_by_list {
    my ($self, $listfile) = @_;
    die "No list file provided." unless (defined $listfile);
    
	open my $fh, "<", $listfile or die $!; 

    while(<$fh>) {
    	chomp;
    	next if $_ =~ /^#/;
    	my ($group_id) = split "\t", $_;
    	$self->fasta_by_group_id($group_id);
    }
    close $fh;
}

=head2 list_groups

List all group_ids with some details.

=cut

sub list_groups {
	my $self = shift;
	my @group_ids = $self->db->get_group_ids;
	
	print join "\t", ("#". 'group_id', 'num_unique_isolates', 'num_sequences', 'product (truncated)');
	print "\n";
	foreach my $id (@group_ids) {
		my @elements = $self->db->get_elements_by_group_id($id);
		my $product = join " | ", map { $_->product } @elements ;
		my $product_subset    = substr $product, 0,30;
		$product_subset      .= ' (...)';
		my $num_sequences     = scalar @elements;
		my $num_uniq_isolates = scalar uniq (map { $_->sanger_id } @elements);
		print join "\t", ($id, $num_uniq_isolates, $num_sequences, $product_subset);
		print "\n";
	}
}

=head2 _make_fasta_header

=cut

sub _make_fasta_header {
	my ($group_id, $elem) = @_;
	return join "_", ('>' . $group_id , $elem->id, $elem->sanger_id);
}

=head2 presence_matrix

=cut

sub presence_matrix {
	my $self = shift;
	
	my $isolates = $self->db->load_isolates;
	my @ids   = map {$_->id } @$isolates; 
	my @types = map {$_->remark} @$isolates;
	
    print join ("\t",
        (  "#GroupID"
          , "Annotation (Truncated)"
          , "MemberCount"
          , "SequenceCount"
          , @types ));	 
	print "\n";

    print join ("\t",
        (  "#."
          , "."
          , "."
          , "."
          , @ids));	 
	print "\n";

	#queries the DB using DBI and returns sth, see CoreDB
	my $sth = $self->db->cluster_sth;
		
	
	while(my $row = $sth->fetchrow_hashref) {
	    my %seen; #the isolates in this cluster;
	    foreach my $sanger_id (split ',', $row->{member_names}) {
	    	$seen{$sanger_id} = 1;
	    }
	       
	    #iterarte through all the isolate ids
	    my @presence;
	    for my $id (@ids) {
	        my $status = (exists $seen{$id} ) ? '++' : '--';
	        push @presence, $status;
	    }
	    my $status_str = join "\t", @presence;
	    
	    print join ("\t",
	        (  $row->{group_id}
	         , $row->{annotation}
	         , $row->{member_count}
	         , $row->{sequence_count}
	         , $status_str ));
	    print  "\n";
	}
}


no Moose;
__PACKAGE__->meta->make_immutable;
