source ../project_data.sh

# Useful argument is --debug.  It can be set when calling this script, `bash 1a...sh --debug`
ERR="tmp/1a.log.err"
OUT="tmp/1a.log.out"
mkdir -p tmp

bash run_vaf_filter.sh $MUTECT_VCF $MUTECT_VCF_FILTER_CONFIG $@ 1>$OUT 2>$ERR

echo Written to $OUT and $ERR

