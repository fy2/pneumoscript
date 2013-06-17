.header on
.mode column
SELECT dna_group_id AS 'Dna_Group'
     , GROUP_CONCAT(isolates.sanger_id) AS 'Members'
FROM genes
    , isolates
WHERE genes.isolate_id = isolates.id
GROUP BY dna_group_id;
