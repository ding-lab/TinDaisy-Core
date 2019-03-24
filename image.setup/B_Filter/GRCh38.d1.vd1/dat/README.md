```
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.26_GRCh38/GCF_000001405.26_GRCh38_assembly_report.txt
grep -v "^#" GCF_000001405.26_GRCh38_assembly_report.txt | cut -f 7,10 | tr -d '\r' > NCBI2UCSD.dat
```
