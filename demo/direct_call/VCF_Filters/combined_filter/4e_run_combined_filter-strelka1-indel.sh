source ../project_data.sh

# Useful argument is --debug.  It can be set when calling this script, `bash 1a...sh --debug`
ERR="tmp/4e.log.err"
OUT="tmp/4e.log.out"
VCF="tmp/4e.out.vcf"
mkdir -p tmp

bash run_combined_filter.sh $STRELKA1_INDEL_VCF $STRELKA_VCF_FILTER_CONFIG $VCF "$@"  # 1>$OUT 2>$ERR

echo Written to $VCF, $OUT, $ERR
