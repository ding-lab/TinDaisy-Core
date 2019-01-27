# Define data for this run
# * paths to external datasets
# * all paths are specific to container

SAMPLE_NAME="C3L-00004.demo"
RESULTS_DIR="/data1/$SAMPLE_NAME"

# Paths based on /home/mwyczalk_test/Projects/TinDaisy/TinDaisy/testing/YAML/katmai/C3L-00004.katmai.yaml

# Mapping volumes
# /data1: output volume
# /data2: mapped volume of tumor BAM
# /data3: mapped volume of normal BAM
# /data4: mapped volume of reference
# /data5: mapped volume of variant caller and filter parameters
# /data6: mapped volume of centromere BED
# /data7: mapped volume of DBSNP_DB
# /data8: mapped volume of VEP_CACHE

# on Katmai
# /data1:/diskmnt/Projects/cptac_downloads_4/TinDaisy-Core
# /data2,/data3 - CPTAC3 data directory /diskmnt/Projects/cptac/GDC_import/data
# /data4: /diskmnt/Datasets/Reference
# /data5: /home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/params
# /data6: /home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/demo/demo_data/etc
# /data7: /diskmnt/Datasets/dbSNP/SomaticWrapper/B_Filter/
# /data8: /diskmnt/Datasets/VEP

# C3L-00004 specific
# tumor_bam: /diskmnt/Projects/cptac/GDC_import/data/524d1cea-62cd-483c-8137-19450faf72b6/82ccdf4e-4527-47ca-8151-7e1248f1da09_gdc_realn.bam
# normal_bam: /diskmnt/Projects/cptac/GDC_import/data/1dee4e84-b617-43a2-add1-c68c5e36bcec/1561b97d-8c8f-4fe6-a244-06452760074d_gdc_realn.bam
# reference_fasta: /diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa

TUMOR_BAM="/data2/524d1cea-62cd-483c-8137-19450faf72b6/82ccdf4e-4527-47ca-8151-7e1248f1da09_gdc_realn.bam"
NORMAL_BAM="/data3/1dee4e84-b617-43a2-add1-c68c5e36bcec/1561b97d-8c8f-4fe6-a244-06452760074d_gdc_realn.bam"
REFERENCE_FASTA="/data4/GRCh38.d1.vd1/GRCh38.d1.vd1.fa"

# Caller and filter parameters
PARAMD="/data5"
STRELKA_CONFIG="$PARAMD/strelka.WES.ini"
VARSCAN_CONFIG="$PARAMD/varscan.WES.ini"
PINDEL_CONFIG="$PARAMD/pindel.WES.ini"
STRELKA_VCF_FILTER_CONFIG="$PARAMD/vcf_filter_config-strelka.ini"
VARSCAN_VCF_FILTER_CONFIG="$PARAMD/vcf_filter_config-varscan.ini"
PINDEL_VCF_FILTER_CONFIG="$PARAMD/vcf_filter_config-pindel.ini"
AF_FILTER_CONFIG="$PARAMD/af_filter_config.ini"
CLASS_FILTER_CONFIG="$PARAMD/classification_filter_config.ini"

# Centromere is needed for Pindel
CENTROMERE_BED="/data6/ucsc-centromere.GRCh37.bed"

# From /home/mwyczalk_test/Projects/TinDaisy/TinDaisy/testing/YAML/katmai/C3L-00004.katmai.yaml:
# There are a couple oversions of dbSnP filter.  One is generated using scripts with somaticwrapper:
# Has a hg38 version:
#   Created on denali: /home/mwyczalk_test/src/SomaticWrapper/somaticwrapper/image.setup/B_Filter
#   Stored on denali: /home/mwyczalk_test/data/docker/data/B_Filter
#   Stored on MGI: /gscuser/mwyczalk/projects/SomaticWrapper/data/image.data

# Note that this is somewhat different from Song's version:
#   MGI:/gscmnt/gc3027/dinglab/medseq/cosmic/00-All.brief.pass.cosmic.vcf
#     equivalent, but with .gz and .gz.tbi: /gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/B_Filter/00-All.brief.pass.cosmic.vcf.gz
#   denali:/diskmnt/Projects/Users/hsun/data/dbsnp/00-All.brief.pass.cosmic.vcf.gz
#   Details about how this is generated:  MGI:/gscmnt/gc3027/dinglab/medseq/cosmic/work_log_hg38
#
# Both are stored on katmai here: /diskmnt/Datasets/dbSNP/SomaticWrapper/B_Filter.  See also README there for additional details
DBSNP_DB="/data7/dbsnp.noCOSMIC.GRCh38.vcf.gz"

# Direct calls can take advantage of prestaged VEP Cache.  Note that CWL calls typically need to stage cache GZ file
# More details: /home/mwyczalk_test/Projects/TinDaisy/TinDaisy/testing/YAML/katmai/C3L-00004.katmai.yaml
VEP_CACHE_DIR="/data8"
ASSEMBLY="GRCh38"
# VEP_CACHE_VERSION="90"  # not clear this is needed

