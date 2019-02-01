# Define data for this run
# * paths to external datasets
# * all paths are specific to container

SAMPLE_NAME="vcf_filters.demo"
RESULTS_DIR="/data1/$SAMPLE_NAME"

# Paths based on /home/mwyczalk_test/Projects/TinDaisy/TinDaisy/testing/YAML/katmai/C3L-00004.katmai.yaml

# Mapping volumes
# /data1: output volume
# /data2: Location of test data.  Should be mapped even if using canned data
# /data3: path to reference
# /data4: mapped volume of variant caller and filter parameters
# /data5: Location of strelka2 VCF
# /data6: Location of strelka1 VCF

# on Katmai
# /data1:/diskmnt/Projects/cptac_downloads_4/TinDaisy-Core
# /data2: /home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/demo/direct_call/Merge_VCF/origdata
# /data3: /diskmnt/Datasets/Reference
# /data4: /home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/params
# /data5: /diskmnt/Projects/cptac_downloads_4/TinDaisy-Core/C3L-00004.demo/strelka2/strelka_out/results/variants
# /data6: /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2018-11-26-202516.404/root/run_strelka/results/strelka/strelka_out/results

# These are the same as Merge_VCF/project_data.sh, with the exception of STRELKA_*.  These are large and 
# are used ad hoc from another run
STRELKA1_SNV_VCF="/data6/passed.somatic.snvs.vcf"
STRELKA1_INDEL_VCF="/data6/passed.somatic.indels.vcf"
STRELKA2_SNV_VCF="/data5/somatic.snvs.vcf.gz"
STRELKA2_INDEL_VCF="/data5/somatic.indels.vcf.gz"
VARSCAN_SNV_VCF="/data2/varscan_snv.vcf"
VARSCAN_INDEL_VCF="/data2/varscan_indel.vcf"
MUTECT_VCF="/data2/mutect_result.vcf"
PINDEL_VCF="/data2/pindel.vcf"

REFERENCE_FASTA="/data3/GRCh38.d1.vd1/GRCh38.d1.vd1.fa"

# Caller and filter parameters
PARAMD="/data4"
STRELKA_VCF_FILTER_CONFIG="$PARAMD/vcf_filter_config-strelka.ini"
VARSCAN_VCF_FILTER_CONFIG="$PARAMD/vcf_filter_config-varscan.ini"
PINDEL_VCF_FILTER_CONFIG="$PARAMD/vcf_filter_config-pindel.ini"
MUTECT_VCF_FILTER_CONFIG="$PARAMD/vcf_filter_config-mutect.ini"

AF_FILTER_CONFIG="$PARAMD/af_filter_config.ini"
CLASS_FILTER_CONFIG="$PARAMD/classification_filter_config.ini"

