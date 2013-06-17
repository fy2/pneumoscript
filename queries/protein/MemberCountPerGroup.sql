.header on
.mode column
SELECT protein_group_id AS "Protein_Group"
     , COUNT(*) AS "Sequence_Count"
     , COUNT(DISTINCT(isolate_id)) AS "Member_Count"
     , GROUP_CONCAT(DISTINCT(isolates.sanger_id)) AS 'Members'
FROM genes
GROUP BY protein_group_id
ORDER BY COUNT(*) DESC;
