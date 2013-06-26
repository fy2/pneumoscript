package CoreDB;
use Moose;
use DBI;
use Genome::Schema;
use CoreCluster;
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

has clusters => (
    is => 'rw',
    isa => 'ArrayRef[CoreCluster]',
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

sub load_clusters {
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
        my $cluster = CoreCluster->new(id => $row[0],
                                       remark=>$row[2],
                                       members=> [@members],
                                       );
        push @{ $self->clusters }, $cluster;
    }
    return $self->clusters;
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

no Moose;
__PACKAGE__->meta->make_immutable;
