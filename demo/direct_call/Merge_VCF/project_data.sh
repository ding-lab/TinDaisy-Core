# Define data for this run
# * paths to external datasets
# * all paths are specific to container


# Mapping volumes
# /data1: output volume
# /data2: Location of test data.  Should be mapped even if using canned data

# on Katmai, assume for StrelkaDemo run:
# /data1:/diskmnt/Projects/cptac_downloads_4/TinDaisy-Core
# /data2: /home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/demo/direct_call/Merge_VCF/origdata


SAMPLE_NAME="C3L-00004.Merge_VCF"
RESULTS_DIR="/data1/$SAMPLE_NAME"


STRELKA_SNV_VCF="/data2/strelka_snv.vcf"
STRELKA_INDEL_VCF="/data2/strelka_indel.vcf"
VARSCAN_SNV_VCF="/data2/varscan_snv.vcf"
VARSCAN_INDEL_VCF="/data2/varscan_indel.vcf"
MUTECT_VCF="/data2/mutect_result.vcf"
PINDEL_VCF="/data2/pindel.vcf"

