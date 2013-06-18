.header on
.mode column
.width 6 13 6 20 20
SELECT 
      isolates.id AS 'Member'
    , isolates.sanger_id AS 'Member_Name'
    , COUNT(genes.id) AS 'Genes'
    , COUNT(genes.dna_group_id) AS 'Genes_in_DnaGroups'
    , COUNT(genes.protein_group_id) AS 'Genes_in_ProtGroups'
    
FROM isolates LEFT OUTER JOIN genes ON isolates.id = genes.isolate_id 
GROUP BY isolates.id;
