.header on
.mode tabs
SELECT group_id AS 'GroupID'
    , COUNT(*) AS 'SequenceCount'
    , COUNT(DISTINCT(isolate_id)) AS 'MemberCount'
    , GROUP_CONCAT(DISTINCT(sequences.protein_id)) AS 'DistinctProteinIDs'
    , GROUP_CONCAT(DISTINCT(sequences.dna_id)) AS 'DistinctDnaIDs'
FROM sequences
    , isolates
WHERE sequences.isolate_id = isolates.id
    AND group_id IS NOT NULL
GROUP BY group_id;
