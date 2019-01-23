# Define data for this run
# * paths to external datasets
# * all paths are specific to container


# Mapping volumes
# /data1: output volume
# /data2: tumor BAM
# /data3: normal BAM
# /data4: location of parameters.  This should be mapped, even if using standard parameters installed in container
# /data5: location of reference
# /data6: location of DBSNP_DB
# /data7: location of VEP_CACHE

# on Katmai, assume for StrelkaDemo run:
# /data1:/diskmnt/Projects/cptac_downloads_4/TinDaisy-Core
# /data2,/data3,/data8 - StrelkaDemo.dat directory = /home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/demo/test_data/StrelkaDemo.dat
# /data4:/home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/params
# /data5,/data6 - StrelkaDemo.dat
# /data7 is not mapped, not using VEP_CACHE

# PARAMD="/usr/local/somaticwrapper/params"
# PARAMD should be a mapped volume

SAMPLE_NAME="StrelkaDemo"

TUMOR_BAM="/data2/StrelkaDemoCase.T.bam"
NORMAL_BAM="/data3/StrelkaDemoCase.N.bam"

PARAMD="/data4"
STRELKA_CONFIG="$PARAMD/strelka.WES.ini"
VARSCAN_CONFIG="$PARAMD/varscan.WES.ini"
PINDEL_CONFIG="$PARAMD/pindel.WES.ini"
STRELKA_VCF_FILTER_CONFIG="$PARAMD/vcf_filter_config-strelka.ini"
VARSCAN_VCF_FILTER_CONFIG="$PARAMD/vcf_filter_config-varscan.ini"
PINDEL_VCF_FILTER_CONFIG="$PARAMD/vcf_filter_config-pindel.ini"
AF_FILTER_CONFIG="$PARAMD/af_filter_config.ini"
CLASS_FILTER_CONFIG="$PARAMD/classification_filter_config.ini"

# Centromere is also found with reference
CENTROMERE_BED="/data5/ucsc-centromere.GRCh37.bed"

REFERENCE_FASTA="/data5/demo20.fa"
DBSNP_DB="/data6/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz"

#VEP_CACHE_DIR="/data7"
ASSEMBLY="GRCh37"

RESULTS_DIR="/data1/$SAMPLE_NAME"

