.header on
.mode column
.width 9 13 10 10 10 40
SELECT
       dna_group_id AS 'Dna_Group'
     , protein_group_id AS 'Protein_Group'
     , isolates.sanger_id AS 'Member_ID'
     , genes.dna_id AS 'Dna_ID'
     , genes.protein_id AS 'Protein_ID'
     , product AS 'Member_Annotation'

FROM genes
    , isolates
WHERE isolates.id = genes.isolate_id
ORDER BY dna_group_id ASC;
