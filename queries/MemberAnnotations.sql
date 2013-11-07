.header on
.mode tabs
SELECT
       group_id AS 'GroupID'
     , isolates.sanger_id AS 'MemberName'
     , sequences.dna_id AS 'DnaID'
     , sequences.protein_id AS 'ProteinID'
     , product AS 'Annotation'

FROM sequences
    , isolates
WHERE isolates.id = sequences.isolate_id
ORDER BY group_id ASC;
