.header on
.mode tabs
SELECT group_id AS 'GroupID'
     , isolates.remarks AS 'MemberType'
     , COUNT(sequences.id) AS 'SequenceCount'
     , COUNT(DISTINCT(isolate_id)) AS 'MemberCount'
FROM sequences
    , isolates
WHERE sequences.isolate_id = isolates.id
    AND sequences.group_id IS NOT NULL
GROUP BY group_id, isolates.remarks
;
