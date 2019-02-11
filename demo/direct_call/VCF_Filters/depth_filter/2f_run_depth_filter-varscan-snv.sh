source ../project_data.sh

# Useful argument is --debug.  It can be set when calling this script, `bash 1a...sh --debug`
ERR="tmp/2f.log.err"
OUT="tmp/2f.log.out"
mkdir -p tmp

bash run_depth_filter.sh $VARSCAN_SNV_VCF $VARSCAN_VCF_FILTER_CONFIG "$@"  1>$OUT 2>$ERR

echo Written to $OUT and $ERR

