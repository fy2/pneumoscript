.header on
.mode column
SELECT protein_group_id AS "Protein_Group"
     , COUNT(*) AS "Member_Count"
FROM genes
GROUP BY protein_group_id
ORDER BY COUNT(*) DESC;
