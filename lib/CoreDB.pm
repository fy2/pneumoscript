package CoreDB;
use Moose;
use DBI;
use Genome::Schema;
use Cluster;
use Isolate;
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

sub get_distinct_types {
    my $self = shift;

    my $sql =<<END;
SELECT
     DISTINCT(isolates.remarks)
FROM 
     isolates
;
END

    my @types;
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute();
    while(my @row = $sth->fetchrow_array) {
       push @types, @row;
    }
    return @types;
}



no Moose;
__PACKAGE__->meta->make_immutable;
