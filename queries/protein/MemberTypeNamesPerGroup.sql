.header on
.mode column
SELECT protein_group_id AS 'Protein_Group'
     , GROUP_CONCAT(isolates.remarks) AS 'Member_Type'
FROM genes
    , isolates
WHERE genes.isolate_id = isolates.id
    AND protein_group_id IS NOT NULL
GROUP BY protein_group_id;
