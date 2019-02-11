source ../project_data.sh

# Useful argument is --debug.  It can be set when calling this script, `bash 1a...sh --debug`
ERR="tmp/4a.log.err"
OUT="tmp/4a.log.out"
VCF="tmp/4a.out.vcf"
mkdir -p tmp

bash run_combined_filter.sh $MUTECT_VCF $MUTECT_VCF_FILTER_CONFIG $VCF "$@" 1>$OUT 2>$ERR

echo Written to $VCF, $OUT, $ERR

