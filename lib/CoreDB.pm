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

has clusters_protein => (
    is => 'rw',
    isa => 'ArrayRef[Cluster]',
    default => sub { [] },
    );

has clusters_dna => (
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

=head2 load_clusters_protein

Make "Cluster" objects which can hold this data:
Protein group_id, sequence count in cluster, member remarks, distinct member counts,
distinct member names

=cut

sub load_clusters_protein {
    my $self = shift;
    my $sql =<<END;
    SELECT protein_group_id AS 'Protein_Group'
        , COUNT(*) AS 'Sequence_Count'
        , isolates.remarks AS 'Remarks'
        , COUNT(DISTINCT(isolate_id)) AS 'Member_Count'
        , GROUP_CONCAT(DISTINCT(isolates.sanger_id)) AS 'Member_Names'
    FROM genes
        , isolates
    WHERE genes.isolate_id = isolates.id
        AND protein_group_id IS NOT NULL
    GROUP BY protein_group_id;
END
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute();
    while(my @row = $sth->fetchrow_array) {
        my @members = split ',', $row[4];
        my $cluster = Cluster->new(id => $row[0],
                                       remark=>$row[2],
                                       members=> [@members],
                                       );
        push @{ $self->clusters_protein }, $cluster;
    }
    return $self->clusters_protein;
}

=head2 load_clusters_dna

Make "Cluster" objects which can hold this data:
DNA group_id, sequence count in cluster, member remarks, distinct member counts,
distinct member names

=cut

sub load_clusters_dna {
    my $self = shift;
    my $sql =<<END;
    SELECT dna_group_id AS 'Dna_Group'
        , COUNT(*) AS 'Sequence_Count'
        , isolates.remarks AS 'Remarks'
        , COUNT(DISTINCT(isolate_id)) AS 'Member_Count'
        , GROUP_CONCAT(DISTINCT(isolates.sanger_id)) AS 'Member_Names'
    FROM genes
        , isolates
    WHERE genes.isolate_id = isolates.id
        AND dna_group_id IS NOT NULL
    GROUP BY dna_group_id;
END
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute();
    while(my @row = $sth->fetchrow_array) {
        my @members = split ',', $row[4];
        my $cluster = Cluster->new(id => $row[0],
                                       remark=>$row[2],
                                       members=> [@members],
                                       );
        push @{ $self->clusters_dna }, $cluster;
    }
    return $self->clusters_dna;
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

=head2 get_type_counts_for_dna_clusters

hashref

=cut

sub get_type_counts_for_dna_clusters {
    my $self = shift;
    my %clusters_of;

    my $sql =<<END;
SELECT genes.dna_group_id AS 'Dna_Group'
     , isolates.remarks AS 'Member_Type'
     , COUNT(*) AS 'Sequence_Count'
     , COUNT(DISTINCT(genes.isolate_id)) AS 'Member_Count'
     , SUBSTR(GROUP_CONCAT(genes.product), 1,40) AS 'Product'
FROM genes
    , isolates
WHERE genes.isolate_id = isolates.id
    AND genes.dna_group_id IS NOT NULL
GROUP BY genes.dna_group_id, isolates.remarks
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
                                    type => 'dna',
                                   );
         push @{ $clusters_of{$cluster_id} }, $cluster;
    }
    return \%clusters_of;
}

=head2 get_type_counts_for_protein_clusters

hashref

=cut

sub get_type_counts_for_protein_clusters {
    my $self = shift;
    my %clusters_of;

    my $sql =<<END;
SELECT genes.protein_group_id AS 'Protein_Group'
     , isolates.remarks AS 'Member_Type'
     , COUNT(*) AS 'Sequence_Count'
     , COUNT(DISTINCT(genes.isolate_id)) AS 'Member_Count'
     , SUBSTR(GROUP_CONCAT(genes.product), 1,40) AS 'Product'
FROM genes
    , isolates
WHERE genes.isolate_id = isolates.id
    AND genes.protein_group_id IS NOT NULL
GROUP BY genes.protein_group_id, isolates.remarks
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
                                    type => 'protein',
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

=head2 get_protein_group_ids

arr

=cut

sub get_protein_group_ids {
    my $self = shift;

    my $sql =<<END;
SELECT DISTINCT(genes.protein_group_id) FROM genes ORDER BY genes.protein_group_id;
END
    my @ids;
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute();
    while(my ($id) = $sth->fetchrow_array) {
       push @ids, $id if defined $id;
    }
    if (scalar @ids == 0) {
        print STDERR "no protein groups are present in your database";
        die;
    }

    return @ids;
}

=head2 get_dna_cluster_ids

arr

=cut

sub get_dna_group_ids {
    my $self = shift;

    my $sql =<<END;
SELECT DISTINCT(genes.dna_group_id) FROM genes ORDER BY genes.dna_group_id;
END
    my @ids;
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute();
    while(my ($id) = $sth->fetchrow_array) {
       push @ids, $id if defined $id;
    }
 
    if (scalar @ids == 0) {
       print STDERR "no dna groups are present in your database";
       die;
    }
    
    return @ids;
}

=head2 get_clustered_protein_lengths_by_group_id

hashref: hashref->{protein_group_id} = [ (lengths of proteins) ];

=cut

sub get_clustered_protein_lengths_by_group_id {
    my ($self, $group_id) = @_;
    my $sql =<<END;
SELECT GROUP_CONCAT(LENGTH(proteins.seq),',') FROM genes, proteins 
WHERE protein_group_id = ? AND proteins.id = genes.protein_id;
END
    my @lens;
    my $sth = $self->_dbh->prepare($sql) or die $self->_dbh->errstr;
    $sth->execute($group_id) or die $self->_dbh->errstr ;
    
    while(my ( $lengths) = $sth->fetchrow_array) {
       @lens = split ',', $lengths;
    }
    return @lens;
}

=head2 get_elements_by_protein_group_id 

Array of 'Element' objects, which together constitute a protein cluster.
Elements are more or less the rows of the gene table which is joined 
with proteins, dna and isolates for some more info.

=cut

sub get_elements_by_protein_group_id {
    my ($self, $group_id) = @_;
    my $sql =<<END;
SELECT genes.id, 
        isolates.sanger_id, 
        genes.product, 
        dna.seq, 
        proteins.seq 
FROM genes, proteins, dna, isolates
WHERE 
    protein_group_id = ? 
    AND proteins.id = genes.protein_id
    AND dna.id = genes.dna_id
    AND isolates.id = genes.isolate_id;
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
