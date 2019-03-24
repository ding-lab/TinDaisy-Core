#!/bin/bash

VCFGZ="CosmicCodingMuts.v88.vcf.gz"
VCFBGZ="CosmicCodingMuts.v88.UCSC.vcf.gz"  # file as processed
OUTD="/home/mwyczalk_test/data/docker/data/B_Filter/GRCh38.d1.vd1"
MAPPING="dat/Ensembl_2_UCSC.dat"

OUT="$OUTD/$VCFBGZ"
IN="$OUTD/$VCFGZ"

>&2 echo Reading VCF $IN and mapping file $MAPPING
>&2 echo Writing $OUT
# Now convert to bgz format and index.  Note that extension needs to be .gz for downstream
# java snpsift code to work
gunzip -c $IN | \
awk 'BEGIN{FS="\t";OFS="\t"} NR==FNR{map[$1]=$2;next} { for (i=1;i<=NF;i++) $i=($i in map ? map[$i] : $i) } 1' $MAPPING - | bgzip > $OUT

tabix -p vcf $OUT

echo Written to $OUT


