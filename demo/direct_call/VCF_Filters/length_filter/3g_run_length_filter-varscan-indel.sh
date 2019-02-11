source ../project_data.sh

# Useful argument is --debug.  It can be set when calling this script, `bash 1a...sh --debug`
ERR="tmp/3g.log.err"
OUT="tmp/3g.log.out"
mkdir -p tmp

bash run_length_filter.sh $VARSCAN_INDEL_VCF $VARSCAN_VCF_FILTER_CONFIG "$@"  1>$OUT 2>$ERR

echo Written to $OUT and $ERR

