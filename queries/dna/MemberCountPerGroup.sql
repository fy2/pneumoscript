.header on
SELECT dna_group_id AS "Dna_Group"
     , COUNT(*) AS "Sequence_Count"
     , COUNT(DISTINCT(isolate_id)) AS "Member_Count"
FROM genes, isolates
WHERE genes.isolate_id = isolates.id
    AND dna_group_id IS NOT NULL
GROUP BY dna_group_id;
