package CoreDB;
use Moose;
use DBI;
use Genome::Schema;
use Cluster;
use Isolate;
use Element;
use Bio::Seq;
use Data::Dumper;

has 'db' => (
    is => 'rw',
    isa => 'Str',
    trigger => \&_connect,
    );

has _dbh => (
    is => 'rw',
    isa => 'DBI::db',
    );

has clusters => (
    is => 'rw',
    isa => 'ArrayRef[Cluster]',
    default => sub { [] },
    );

has isolates => (
    is => 'rw',
    isa => 'ArrayRef[Isolate]',
    default => sub { [] },
    );

sub _connect {
    my $self = shift;
    my $db = $self->db;
    $self->_dbh(DBI->connect("dbi:SQLite:dbname=$db","",""));
    $self->_dbh->{LongReadLen} = 400;
}

=head2 load_clusters

Make "Cluster" objects which can hold this data:
group_id, sequence count in cluster, member remarks, distinct member counts,
distinct member names

=cut

sub load_clusters {
    my $self = shift;
    my $sql =<<END;
    SELECT group_id AS 'Group'
        , COUNT(*) AS 'Sequence_Count'
        , isolates.remarks AS 'Remarks'
        , COUNT(DISTINCT(isolate_id)) AS 'Member_Count'
        , GROUP_CONCAT(DISTINCT(isolates.sanger_id)) AS 'Member_Names'
    FROM sequences
        , isolates
    WHERE sequences.isolate_id = isolates.id
        AND group_id IS NOT NULL
    GROUP BY group_id;
END
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute();
    while(my @row = $sth->fetchrow_array) {
        my @members = split ',', $row[4];
        my $cluster = Cluster->new(id => $row[0],
                                       remark=>$row[2],
                                       members=> [@members],
                                       );
        push @{ $self->clusters }, $cluster;
    }
    return $self->clusters;
}

=head2 load_isolates

load isolate_ids and remark into "isolates" attribute of $self

=cut

sub load_isolates {
    my $self = shift;
    my $sql =<<END;
    SELECT  sanger_id
          , remarks 
    FROM isolates;
END
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute();
    while(my @row = $sth->fetchrow_array) {
        my $isolate = Isolate->new(id => $row[0],
                                   remark => $row[1],
                                   );
        push @{ $self->isolates }, $isolate;
    }
    return $self->isolates;
}

=head2 get_type_counts_for_clusters

hashref

=cut

sub get_type_counts_for_clusters {
    my $self = shift;
    my %clusters_of;

    my $sql =<<END;
SELECT sequences.group_id AS 'Group'
     , isolates.remarks AS 'Member_Type'
     , COUNT(*) AS 'Sequence_Count'
     , COUNT(DISTINCT(sequences.isolate_id)) AS 'Member_Count'
     , SUBSTR(GROUP_CONCAT(sequences.product), 1,40) AS 'Product'
FROM sequences
    , isolates
WHERE sequences.isolate_id = isolates.id
    AND sequences.group_id IS NOT NULL
GROUP BY sequences.group_id, isolates.remarks
;
END
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute();
    while(my @row = $sth->fetchrow_array) {
         my $cluster_id = $row[0];
         my $cluster = Cluster->new(id => $row[0],
                                    remark=>$row[1],         #should call this phenotype  
                                    gene_count => $row[2],
                                    member_count => $row[3],
                                    product => $row[4] . '...',
                                   );
         push @{ $clusters_of{$cluster_id} }, $cluster;
    }
    return \%clusters_of;
}

=head2 get_distinct_types

array

=cut

sub get_distinct_types {
    my $self = shift;

    my $sql =<<END;
SELECT DISTINCT(isolates.remarks) FROM isolates;
END

    my @types;
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute();
    while(my @row = $sth->fetchrow_array) {
       push @types, @row;
    }
    return @types;
}

=head2 get_group_ids

arr

=cut

sub get_group_ids {
    my $self = shift;

    my $sql =<<END;
SELECT DISTINCT(sequences.group_id) FROM sequences ORDER BY sequences.group_id;
END
    my @ids;
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute();
    while(my ($id) = $sth->fetchrow_array) {
       push @ids, $id if defined $id;
    }
    #if (scalar @ids == 0) {
        #print STDERR "no groups are present in your database";
    #}

    return @ids;
}

=head2 get_clustered_protein_lengths_by_group_id

hashref: hashref->{group_id} = [ (lengths of proteins) ];

=cut

sub get_clustered_protein_lengths_by_group_id {
    my ($self, $group_id) = @_;
    my $sql =<<END;
SELECT GROUP_CONCAT(LENGTH(proteins.seq),',') FROM sequences, proteins 
WHERE group_id = ? AND proteins.id = sequences.protein_id;
END
    my @lens;
    my $sth = $self->_dbh->prepare($sql) or die $self->_dbh->errstr;
    $sth->execute($group_id) or die $self->_dbh->errstr ;
    
    while(my ( $lengths) = $sth->fetchrow_array) {
       @lens = split ',', $lengths;
    }
    return @lens;
}

=head2 get_elements_by_group_id 

Array of 'Element' objects, which together constitute a cluster.
Elements are more or less the rows of the gene table which is joined 
with proteins, dna and isolates for some more info.

=cut

sub get_elements_by_group_id {
    my ($self, $group_id) = @_;
    my $sql =<<END;
SELECT sequences.id, 
        isolates.sanger_id, 
        sequences.product, 
        dna.seq, 
        proteins.seq 
FROM sequences, proteins, dna, isolates
WHERE 
    group_id = ? 
    AND proteins.id = sequences.protein_id
    AND dna.id = sequences.dna_id
    AND isolates.id = sequences.isolate_id;
END
    my @elements;
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute($group_id);
    while(my @row = $sth->fetchrow_array) {
        my $dna_seq = Bio::Seq->new(-seq => $row[3], -alphabet => 'dna' );
        my $prot_seq = Bio::Seq->new(-seq => $row[4], -alphabet => 'protein' );

        my $element = Element->new(id => $row[0],
                                  sanger_id => $row[1],
                                  product => $row[2],
                                  dna_seq => $dna_seq,
                                  protein_seq => $prot_seq);
        push @elements, $element;
    }

    return @elements;

}

no Moose;
__PACKAGE__->meta->make_immutable;
