.header on
SELECT protein_group_id AS 'Protein_Group'
    , COUNT(*) AS 'Sequence_Count'
    , COUNT(DISTINCT(isolate_id)) AS 'Member_Count'
     , GROUP_CONCAT(DISTINCT(isolates.sanger_id)) AS 'Member_Names'
FROM genes
    , isolates
WHERE genes.isolate_id = isolates.id
    AND protein_group_id IS NOT NULL
GROUP BY protein_group_id;
