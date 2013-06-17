.header on
.mode column
SELECT protein_group_id AS 'Protein_Group'
     , isolates.remarks AS 'Member_Type'
     , COUNT(*) AS 'Member_Type_Count'
FROM genes
    , isolates
WHERE genes.isolate_id = isolates.id
GROUP BY protein_group_id, isolates.remarks
;
