.header on
.mode column
SELECT dna_group_id AS 'Dna_Group'
     , isolates.remarks AS 'Member_Type'
     , COUNT(*) AS 'Member_Type_Count'
FROM genes
    , isolates
WHERE genes.isolate_id = isolates.id
GROUP BY dna_group_id, isolates.remarks
;
