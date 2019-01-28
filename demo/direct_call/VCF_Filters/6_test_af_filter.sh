# Testing AF filter using pyvcf's exensible vcf_filter.py framework
source common_config.sh

# This will break on a standard demo run with the following:
#   Exception: CSQ field MAX_AF not found in /data/StrelkaDemo-results/vep/output.unfiltered.vcf
# That's because need to use data obtained with --flag_pick

# output.vcf was generated with 
# Note: require the --flag_pick flag when running vep
VCF="/data/StrelkaDemo-results/vep/output.unfiltered.vcf"
CONFIG="--config ../../params/af_filter_config.ini"

AF_FILTER_LOCAL="af_filter.py"  # filter module

MAIN_FILTER="vcf_filter.py --no-filtered" # Assuming in path

# arguments to depth filter
ARGS="af --debug --input_vcf $VCF" # --bypass_if_missing"

$MAIN_FILTER --local-script $AF_FILTER_LOCAL $VCF $ARGS $CONFIG
