# Create list of common SNPs

1. Download dbsnp database
2. Download COSMIC database
3. Remove from dbsnp database those mutations which exist in COSMIC database

This stage will generally need to be run just once to generate the database.

`dbSnP_b150` has scripts for the b150 release of dbSnP (GRCh37 and GRCh38).
It was was found to have an incorrect chromosome naming scheme (chromosome names like `1` 
instead of `chr1`).

GRCh38.d1.vd1 generates dbSnP-COSMIC file for use with the GRCh38.d1.vd1 reference,
which is standard for GDC, with automated renaming of chromosomes based on tables downloaded
from NBCI.
