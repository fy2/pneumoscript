.header on
.mode column
SELECT dna_group_id AS 'Dna_Group'
     , GROUP_CONCAT(isolates.remarks) AS 'Member_Type'
FROM genes
    , isolates
WHERE genes.isolate_id = isolates.id
    AND dna_group_id IS NOT NULL
GROUP BY dna_group_id;
