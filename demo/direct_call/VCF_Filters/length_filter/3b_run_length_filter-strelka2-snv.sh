source ../project_data.sh

# Useful argument is --debug.  It can be set when calling this script, `bash 1a...sh --debug`
ERR="tmp/3b.log.err"
OUT="tmp/3b.log.out"
mkdir -p tmp

bash run_length_filter.sh $STRELKA2_SNV_VCF $STRELKA_VCF_FILTER_CONFIG "$@"  1>$OUT 2>$ERR

echo Written to $OUT and $ERR

