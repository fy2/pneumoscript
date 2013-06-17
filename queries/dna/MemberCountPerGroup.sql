.header on
.mode column
SELECT dna_group_id AS "Dna_Group"
     , COUNT(*) AS "Member_Count"
FROM genes
GROUP BY dna_group_id
ORDER BY COUNT(*) DESC;
