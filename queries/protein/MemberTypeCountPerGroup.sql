.header on
.mode column
SELECT protein_group_id AS 'Protein_Group'
     , isolates.remarks AS 'Member_Type'
     , COUNT(*) AS 'Sequence_Count'
     , COUNT(DISTINCT(isolate_id)) AS 'Member_Count'
FROM genes
    , isolates
WHERE genes.isolate_id = isolates.id
    AND genes.protein_group_id IS NOT NULL
GROUP BY protein_group_id, isolates.remarks
;
