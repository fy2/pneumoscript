.header on
.mode column
SELECT dna_group_id AS 'Dna_Group'
    , COUNT(*) AS 'Sequence_Count'
    , COUNT(DISTINCT(isolate_id)) AS 'Member_Count'
     , GROUP_CONCAT(DISTINCT(isolates.sanger_id)) AS 'Member_Names'
FROM genes
    , isolates
WHERE genes.isolate_id = isolates.id
    AND dna_group_id IS NOT NULL
GROUP BY dna_group_id
ORDER BY COUNT(DISTINCT(isolate_id)) DESC;
