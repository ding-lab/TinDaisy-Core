source ../project_data.sh

# Suggest --pass_only for STRELKA2 because the output contains spurious non-pass variants 

# Useful argument is --debug
ERR="tmp/1g.log.err"
OUT="tmp/1g.log.out"
mkdir -p tmp

ARG="--pass_only"

bash run_vaf_filter.sh $VARSCAN_INDEL_VCF $VARSCAN_VCF_FILTER_CONFIG $ARG $@  1>$OUT 2>$ERR

echo Written to $OUT and $ERR

