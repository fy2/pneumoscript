####################################
# Querying Results
####################################

#LSF example:
#$'\t' ensures that the result is TAB-delimited
bsub "sqlite3 -separator $'\t' seq.db < ~fy2/software/CoreGenomeUnofficial/queries/MemberAnnotations.sql > MemberAnnotations.sql.tab"

#Non-LSF
sqlite3 -separator $'\t' seq.db < ~fy2/software/CoreGenomeUnofficial/queries/MemberAnnotations.sql |less
sqlite3 -separator $'\t' seq.db < ~fy2/software/CoreGenomeUnofficial/queries/MemberCountPerGroup.sql |less
sqlite3 -separator $'\t' seq.db < ~fy2/software/CoreGenomeUnofficial/queries/MemberNamesPerGroup.sql |less -S
sqlite3 -separator $'\t' seq.db < ~fy2/software/CoreGenomeUnofficial/queries/MemberProteinDnaIDsPerGroup.sql |less -S
sqlite3 -separator $'\t' seq.db < ~fy2/software/CoreGenomeUnofficial/queries/MemberStats.sql |less
sqlite3 -separator $'\t' seq.db < ~fy2/software/CoreGenomeUnofficial/queries/MemberTypeCountPerGroup.sql |less
sqlite3 -separator $'\t' seq.db < ~fy2/software/CoreGenomeUnofficial/queries/MemberTypeNamesPerGroup.sql |less
