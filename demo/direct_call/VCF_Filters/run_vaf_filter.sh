# Testing vaf filter using pyvcf's exensible vcf_flter.py framework
# run within docker container with A_start_docker.sh
#
# Useful arguments:
# --debug
# --bypass

# Usage:
# bash run_vaf_filter.sh VCF CONFIG [args]

export PYTHONPATH="/usr/local/somaticwrapper/src/vcf_filters:$PYTHONPATH"

VCF=$1; shift
CONFIG=$1; shift
XARGS="$@"

MAIN_FILTER="vcf_filter.py --no-filtered" # Assuming in path
FILTER_LOCAL="vaf_filter.py"  # filter module

CMD="$MAIN_FILTER --local-script $FILTER_LOCAL $VCF vaf --config $CONFIG $XARGS"

>&2 echo Running: $CMD
eval $CMD

