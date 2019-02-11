# Testing depth filter using pyvcf's exensible vcf_flter.py framework
# run within docker container with A_start_docker.sh
#
# Useful arguments:
# --debug
# --bypass

# Usage:
# bash run_depth_filter.sh VCF CONFIG [args]

export PYTHONPATH="/usr/local/somaticwrapper/src/vcf_filters:$PYTHONPATH"

VCF=$1; shift
CONFIG=$1; shift
XARGS="$@"

RUN="/usr/local/somaticwrapper/src/vcf_filters/run_vaf_length_depth_filters.sh"
CMD="bash $RUN $VCF $CONFIG $OUT $XARGS"

>&2 echo Running: $CMD
eval $CMD


