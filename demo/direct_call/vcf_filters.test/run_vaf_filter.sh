# Testing vaf filter using pyvcf's exensible vcf_flter.py framework
# run within docker container with A_start_docker.sh
#
# Useful arguments:
# --debug
# --bypass

# Usage:
# bash run_vaf_filter.sh VCF CONFIG [args]

export PYTHONPATH="$PROJECT_ROOT/src/vcf_filters:$PYTHONPATH"

VCF=$1; shift
CONFIG=$1; shift
XARGS="$@"

MAIN_FILTER="vcf_filter.py --no-filtered" # Assuming in path
FILTER_LOCAL="vaf_filter.py"  # filter module

$MAIN_FILTER --local-script $FILTER_LOCAL $VCF vaf $CONFIG $XARGS

#MUTECT_VCF="/data/misc/mutect_result.short.vcf "
##MUTECT_VCF="/data/misc/mutect_result.filtered.vcf "
#STRELKA_VCF="/data/StrelkaDemo-results/strelka/filter_out/strelka.somatic.snv.all.dbsnp_pass.vcf"
#VARSCAN_VCF="/data/StrelkaDemo-results/varscan/filter_out/varscan.out.som_snv.Somatic.hc.somfilter_pass.dbsnp_pass.vcf"
#VARSCAN_INDEL_VCF="/data/StrelkaDemo-results/varscan/filter_out/varscan.out.som_indel.Somatic.hc.dbsnp_pass.vcf"
#PINDEL_VCF="/data/StrelkaDemo-results/pindel/filter_out/pindel.out.current_final.dbsnp_pass.vcf"
#
#run_vaf_filter $MUTECT_VCF $MUTECT_CONFIG --debug "$@"
#
#run_vaf_filter $STRELKA_VCF $STRELKA_CONFIG --debug "$@"
#
#run_vaf_filter $VARSCAN_VCF $VARSCAN_CONFIG --bypass --debug "$@"
#
#run_vaf_filter $VARSCAN_INDEL_VCF $VARSCAN_CONFIG --bypass --debug "$@"
#
#run_vaf_filter $PINDEL_VCF $PINDEL_CONFIG --bypass --debug "$@"
