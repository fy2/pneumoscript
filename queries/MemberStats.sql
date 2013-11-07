.header on
.mode tabs
SELECT 
      isolates.id AS 'Member'
    , isolates.sanger_id AS 'MemberName'
    , COUNT(sequences.id) AS 'SequencesTotal'
    , COUNT(sequences.group_id) AS 'SequencesInGroups'
FROM isolates LEFT OUTER JOIN sequences ON isolates.id = sequences.isolate_id 
GROUP BY isolates.id;
