.header on
.mode column
SELECT protein_group_id AS 'Protein_Group'
     , GROUP_CONCAT(isolates.sanger_id) AS 'Members'
FROM genes
    , isolates
WHERE genes.isolate_id = isolates.id
GROUP BY protein_group_id;
