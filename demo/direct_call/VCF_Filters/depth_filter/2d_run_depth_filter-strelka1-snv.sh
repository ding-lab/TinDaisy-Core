source ../project_data.sh

# Useful argument is --debug.  It can be set when calling this script, `bash 1a...sh --debug`
ERR="tmp/2d.log.err"
OUT="tmp/2d.log.out"
mkdir -p tmp

bash run_depth_filter.sh $STRELKA1_SNV_VCF $STRELKA_VCF_FILTER_CONFIG "$@"  1>$OUT 2>$ERR

echo Written to $OUT and $ERR

