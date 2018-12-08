# Testing vaf filter using pyvcf's exensible vcf_flter.py framework
# Meant to be run within docker container; start with ../start_docker.sh

source common_config.sh

function run_vaf_filter {
VCF=$1; shift
CONFIG=$1; shift
XARGS="$@"

MAIN_FILTER="vcf_filter.py --no-filtered" # Assuming in path
FILTER_LOCAL="vaf_filter.py"  # filter module

$MAIN_FILTER --local-script $FILTER_LOCAL $VCF vaf $CONFIG $XARGS

}

MUTECT_CONFIG="--config ../../params/vcf_filter_config-mutect.ini"
STRELKA_CONFIG="--config ../../params/vcf_filter_config-strelka.ini"
VARSCAN_CONFIG="--config ../../params/vcf_filter_config-varscan.ini"
PINDEL_CONFIG="--config ../../params/vcf_filter_config-pindel.ini"

MUTECT_VCF="/data/misc/mutect_result.short.vcf "
#MUTECT_VCF="/data/misc/mutect_result.filtered.vcf "
STRELKA_VCF="/data/StrelkaDemo-results/strelka/filter_out/strelka.somatic.snv.all.dbsnp_pass.vcf"
VARSCAN_VCF="/data/StrelkaDemo-results/varscan/filter_out/varscan.out.som_snv.Somatic.hc.somfilter_pass.dbsnp_pass.vcf"
VARSCAN_INDEL_VCF="/data/StrelkaDemo-results/varscan/filter_out/varscan.out.som_indel.Somatic.hc.dbsnp_pass.vcf"
PINDEL_VCF="/data/StrelkaDemo-results/pindel/filter_out/pindel.out.current_final.dbsnp_pass.vcf"

run_vaf_filter $MUTECT_VCF $MUTECT_CONFIG --debug "$@"

run_vaf_filter $STRELKA_VCF $STRELKA_CONFIG --debug "$@"

run_vaf_filter $VARSCAN_VCF $VARSCAN_CONFIG --bypass --debug "$@"

run_vaf_filter $VARSCAN_INDEL_VCF $VARSCAN_CONFIG --bypass --debug "$@"

run_vaf_filter $PINDEL_VCF $PINDEL_CONFIG --bypass --debug "$@"
