source ../project_data.sh

# Suggest --pass_only for STRELKA2 because the output contains spurious non-pass variants 

# Useful argument is --debug
ERR="tmp/1c.log.err"
OUT="tmp/1c.log.out"
mkdir -p tmp

ARG="--pass_only"

bash run_vaf_filter.sh $STRELKA2_INDEL_VCF $STRELKA_VCF_FILTER_CONFIG $ARG $@  1>$OUT 2>$ERR

echo Written to $OUT and $ERR

