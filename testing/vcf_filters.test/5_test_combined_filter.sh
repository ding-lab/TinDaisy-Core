# Testing combined filter.
# Combined filter executes vaf, length, and depth filters in a unix pipeline:
#   python vaf_filter ... | python length_filter ... | python depth_filter ... > output.vcf

source common_config.sh

# Caller should be passed in configuration file rather than command line
function run_combined_filter {
CONFIG=$1; shift
VCF=$1; shift
OUT=$1; shift
XARGS="$@"

RUN="../../src/vcf_filters/run_vaf_length_depth_filters.sh"
bash $RUN $VCF $CONFIG $OUT $XARGS

}

VARSCAN_CONFIG="../../params/vcf_filter_config-varscan.ini"
PINDEL_CONFIG="../../params/vcf_filter_config-pindel.ini"
MUTECT_CONFIG="../../params/vcf_filter_config-mutect.ini"
STRELKA_CONFIG="../../params/vcf_filter_config-strelka.ini"

STRELKA_VCF="/data/StrelkaDemo-results/strelka/filter_out/strelka.somatic.snv.all.dbsnp_pass.vcf"
VARSCAN_VCF="/data/StrelkaDemo-results/varscan/filter_out/varscan.out.som_snv.Somatic.hc.somfilter_pass.dbsnp_pass.vcf"
VARSCAN_INDEL_VCF="/data/StrelkaDemo-results/varscan/filter_out/varscan.out.som_indel.Somatic.hc.dbsnp_pass.vcf"
PINDEL_VCF="/data/StrelkaDemo-results/pindel/filter_out/pindel.out.current_final.dbsnp_pass.vcf"

mkdir -p tmp

# TODO: Implement some systematic way of checking output
run_combined_filter $STRELKA_CONFIG $STRELKA_VCF - --debug
run_combined_filter $VARSCAN_CONFIG $VARSCAN_VCF tmp/varscan.tmp.vcf --bypass_vaf
run_combined_filter $VARSCAN_CONFIG $VARSCAN_VCF tmp/varscan2.tmp.vcf --bypass_depth
run_combined_filter $VARSCAN_CONFIG $VARSCAN_VCF tmp/varscan3.tmp.vcf --bypass_depth --bypass
run_combined_filter $VARSCAN_CONFIG $VARSCAN_INDEL_VCF tmp/varindel.tmp.vcf --bypass
run_combined_filter $PINDEL_CONFIG $PINDEL_VCF tmp/pindel.tmp.vcf --bypass_length


