Creating dbSnP-COSMIC database for use with GRCh38.d1.vd1 reference as used for
[GDC harmonization](https://gdc.cancer.gov/about-data/data-harmonization-and-generation/gdc-reference-files)
on denali.  

Principal output is these two files:
* dbSnP-COSMIC.GRCh38.d1.vd1.vcf.gz
* dbSnP-COSMIC.GRCh38.d1.vd1.vcf.gz.tbi

See past discussion about reference / dbSnP mismatch on katmai:/home/mwyczalk_test/Projects/TinDaisy/sw1.3-compare/C3N-00560/04-dbSnP-compare/README.md

# Background 

The GRCh38.d1.vd1 reference consists of three types of sequences:
* `GCA_000001405.15_GRCh38_no_alt_analysis_set`, the core GRCh38 reference
    * [Details at NCBI](https://www.ncbi.nlm.nih.gov/assembly/GCF_000001405.26)
* Sequence decoys
* Virus sequences

The most recent dbSnP data is [GCF_000001405.38](https://ftp.ncbi.nih.gov/snp/latest_release/VCF/GCF_000001405.38.bgz)
This has sequence names in NCBI format, e.g., chromosome 1 is `NC_000001.11`.  To convert dbSnP VCF to something
compatible with the GRCh38.d1.vd1 reference, we need to map NCBI names to equivalent UCSD names like `chr1`.
This is done using an [assembly report file](http://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.26_GRCh38/GCF_000001405.26_GRCh38_assembly_report.txt)

## Prerequesites

Download and install [SnpEff](http://snpeff.sourceforge.net/download.html)

# Processing steps

This work is partly automated, with steps 1 and 3 currently done by manually.  All scripts will need to be
modified to work on different systems.

This step is run on host machine.  Follow steps below in order, and where appropriate execute script (e.g., `bash 2_get_snp.sh`)

This script was developed and run on denali, with the output directory: `/home/mwyczalk_test/data/docker/data/B_Filter/GRCh38.d1.vd1`


## 0. Edit all scripts

Determine OUTD, the output directory.  For GRCh38.d1.vd1 this uses 13G.  This will need to be specified in all scripts.


## 1. get remapping dictionary
Obtain dictionary to convert NCBI and Ensembl chromosome names to UCSC format.  Creates the MAPPING files,
`dat/NCBI_2_UCSC.dat` and `dat/Ensembl_2_UCSC.dat`.

```
mkdir -p dat
cd dat
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.26_GRCh38/GCF_000001405.26_GRCh38_assembly_report.txt
grep -v "^#" GCF_000001405.26_GRCh38_assembly_report.txt | cut -f 7,10 | tr -d '\r' > NCBI_2_UCSC.dat
grep -v "^#" GCF_000001405.26_GRCh38_assembly_report.txt | cut -f 1,10 | tr -d '\r' > Ensembl_2_UCSC.dat
```

## 2. download and process dbSnP database

* Downloading most recent dbSnP database
* Keeping only first 5 columns
* Using `NCBI_2_UCSC` dictionary to remap chromosome names

This is done with script `2_get_snp.sh` and generates files `dbSnP.5col.UCSC.vcf.gz` and `dbSnP.5col.UCSC.vcf.gz.tbi`
in the target directory `/home/mwyczalk_test/data/docker/data/B_Filter/GRCh38.d1.vd1`

## 3. download COSMIC v88 coding mutations VCF

Instructions for scripted data downloads from COSMIC are [here](https://cancer.sanger.ac.uk/cosmic/download).  Note that
this requires an account.  Basic steps are below, with the resulting data saved to `CosmicCodingMuts.v88.vcf.gz`

```
> echo 'USERNAME:PASSWORD' | base64
VVNFUk5BTUU6UEFTU1dPUkQK

> curl -H "Authorization: Basic VVNFUk5BTUU6UEFTU1dPUkQK" https://cancer.sanger.ac.uk/cosmic/file_download/GRCh38/cosmic/v88/VCF/CosmicCodingMuts.vcf.gz
"url" : "https://cog.sanger.ac.uk/cosmic/GRCh38/cosmic/v88/VCF/CosmicNonCodingVariants.vcf.gz?AWSAccessKeyId=KFGH85D9KLWKC34GSl88&Expires=1521726406&Signature=Jf834Ck0%8GSkwd87S7xkvqkdfUV8%3D"

> curl -o /home/mwyczalk_test/data/docker/data/B_Filter/GRCh38.d1.vd1/CosmicCodingMuts.v88.vcf.gz "https://cog.sanger.ac.uk/cosmic/GRCh38/cosmic/v88/VCF/CosmicNonCodingVariants.vcf.gz?AWSAccessKeyId=KFGH85D9KLWKC34GSl88&Expires=1521726406&Signature=Jf834Ck0%8GSkwd87S7xkvqkdfUV8%3D"
```

Note that this has chromosomes with Ensembl names like `1`, which need to be converted to UCSC style (`chr1`)

## 4. Process COSMIC VCF

Conversion of Ensembl chromosome names to UCSC style is done with script `4_convert_cosmic.sh`.  This writes to
`/home/mwyczalk_test/data/docker/data/B_Filter/GRCh38.d1.vd1/CosmicCodingMuts.v88.UCSC.vcf.gz`

## 5. Remove COSMIC variants from dbSnP list

`5_make_variant_filter.sh` uses SnpSift package to
1. Annotate the dbSnP VCF to indicate those variants in COSMIC
2. Create new VCF by filtering out variants which are annotated

This is a relatively time-consuming step, on the order of several hours

## 6. Cleanup

Intermediate files can be removed.  This not currently automated, but will result in 50% decrease in storage used (currently 13Gb total)

The following intermediate files can be removed:
* CosmicCodingMuts.v88.UCSC.vcf.gz
* CosmicCodingMuts.v88.UCSC.vcf.gz.tbi
* CosmicCodingMuts.v88.vcf.gz
* dbSnP.5col.UCSC.vcf.gz
* dbSnP.5col.UCSC.vcf.gz.tbi




