####################################
# Querying Results
####################################

#10 Querying general metrics ('Member' is a synonym for organism/isolate/strain):
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/MemberStats.sql |less
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/MemberAnnotations.sql |less

#11 Querying gene clusters for 'protein' analysis:
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/protein/MemberCountPerGroup.sql |less
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/protein/MemberNamesPerGroup.sql |less -S
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/protein/MemberTypeCountPerGroup.sql |less
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/protein/MemberTypeNamesPerGroup.sql |less -S

#12 Querying gene clusters for 'dna' analysis:
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/dna/MemberCountPerGroup.sql |less
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/dna/MemberNamesPerGroup.sql |less -S
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/dna/MemberTypeCountPerGroup.sql |less
sqlite3 seq.db < ~fy2/software/CoreGenome/queries/dna/MemberTypeNamesPerGroup.sql |less -S

