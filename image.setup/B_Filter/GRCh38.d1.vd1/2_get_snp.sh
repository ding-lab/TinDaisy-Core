
SRC="ftp://ftp.ncbi.nih.gov/snp/latest_release/VCF/GCF_000001405.38.bgz"
OUTD="/home/mwyczalk_test/data/docker/data/B_Filter/GRCh38.d1.vd1"
mkdir -p $OUTD

OUTFN="dbSnP.5col.UCSC.vcf.gz"
MAPPING="dat/NCBI_2_UCSC.dat"

OUT="$OUTD/$OUTFN"

# See here for file types and sources of links
# https://www.ncbi.nlm.nih.gov/variation/docs/human_variation_vcf/#table-1

if [ -e $OUT ]; then
    echo File $OUT exists.  Please delete it if you want to download again.
    exit
fi


echo downloading $SRC, writing to $OUT

#WD=`pwd`
#cd $OUTD

# Download dbSnP VCF, uncompress, retain headers and first 5 columns, remap chromosome names, compress, and write to OUT
# awk remapping: https://www.biostars.org/p/98582/
wget -q -O - $SRC | gunzip | perl -lane 'if($_=~/^#/){print $_} else {print join("\t",@F[0..4])}' | \
awk 'BEGIN{FS="\t";OFS="\t"} NR==FNR{map[$1]=$2;next} { for (i=1;i<=NF;i++) $i=($i in map ? map[$i] : $i) } 1' $MAPPING - | bgzip > $OUT

echo Creating TBI file
tabix -p vcf $OUT

cd $WD
