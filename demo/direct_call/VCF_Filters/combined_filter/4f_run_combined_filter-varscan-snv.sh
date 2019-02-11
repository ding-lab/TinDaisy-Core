source ../project_data.sh

# Useful argument is --debug.  It can be set when calling this script, `bash 1a...sh --debug`
ERR="tmp/4f.log.err"
OUT="tmp/4f.log.out"
VCF="tmp/4f.out.vcf"
mkdir -p tmp

bash run_combined_filter.sh $VARSCAN_SNV_VCF $VARSCAN_VCF_FILTER_CONFIG $VCF "$@"  # 1>$OUT 2>$ERR

echo Written to $VCF, $OUT, $ERR
