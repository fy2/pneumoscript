.header on
.mode tabs
SELECT group_id AS 'GroupID'
     , GROUP_CONCAT(isolates.remarks) AS 'MemberType'
FROM sequences
    , isolates
WHERE sequences.isolate_id = isolates.id
    AND group_id IS NOT NULL
GROUP BY group_id;
