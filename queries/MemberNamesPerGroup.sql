.header on
SELECT group_id AS 'GroupID'
    , COUNT(*) AS 'SequenceCount'
    , COUNT(DISTINCT(isolate_id)) AS 'MemberCount'
     , GROUP_CONCAT(DISTINCT(isolates.sanger_id)) AS 'MemberNames'
FROM sequences
    , isolates
WHERE sequences.isolate_id = isolates.id
    AND group_id IS NOT NULL
GROUP BY group_id;
