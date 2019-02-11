source ../project_data.sh

# Useful argument is --debug
ERR="tmp/1e.log.err"
OUT="tmp/1e.log.out"
mkdir -p tmp

ARG="--pass_only"

bash run_vaf_filter.sh $STRELKA1_INDEL_VCF $STRELKA_VCF_FILTER_CONFIG $ARG $@  1>$OUT 2>$ERR

echo Written to $OUT and $ERR

