# Testing depth filter using pyvcf's exensible vcf_filter.py framework
source common_config.sh

# Note: require the --flag_pick flag when running vep
VEP_VCF="../C3N-01649.test/C3N-01649.results/vep/output.unfiltered.vcf"
CONFIG="--config ../../params/classification_filter_config.ini"

AF_FILTER_LOCAL="classification_filter.py"  # filter module

MAIN_FILTER="vcf_filter.py --no-filtered" # Assuming in path

# arguments to depth filter
ARGS="classification --input_vcf $VEP_VCF --debug"

$MAIN_FILTER --local-script $AF_FILTER_LOCAL $VEP_VCF $ARGS $CONFIG
