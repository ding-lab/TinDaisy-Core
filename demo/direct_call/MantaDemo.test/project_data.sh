# Define data for this run
# * paths to external datasets
# * all paths are specific to container

SAMPLE_NAME="MantaDemo"
RESULTS_DIR="/data1/$SAMPLE_NAME"

# Mapping volumes
# /data1: output volume
# /data2: tumor BAM
# /data3: normal BAM
# /data4: location of parameters.  This should be mapped, even if using standard parameters installed in container
# /data5: location of reference
# /data6: location of DBSNP_DB
# /data7: location of centromere for pindel
# /data8: location of VEP_CACHE

# on Katmai
# /data1:/diskmnt/Projects/cptac_downloads_4/TinDaisy-Core
# /data2,/data3,/data8 - StrelkaDemo.dat directory = /home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/demo/test_data/MantaDemo.dat
# /data4:/home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/params
# /data5,/data6 - MantaDemo.dat
# /data7:/home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/demo/demo_data/etc

# PARAMD="/usr/local/somaticwrapper/params"
# PARAMD should be a mapped volume


TUMOR_BAM="/data2/G15512.HCC1954.1.COST16011_region.bam"
NORMAL_BAM="/data3/HCC1954.NORMAL.30x.compare.COST16011_region.bam"

REFERENCE_FASTA="/data5/Homo_sapiens_assembly19.COST16011_region.fa"

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
CENTROMERE_BED="/data7/ucsc-centromere.GRCh37.bed"


#DBSNP_DB="/data6/dbsnp-MantaDemo.noCOSMIC.vcf.gz"

#VEP_CACHE_DIR="/data7"
ASSEMBLY="GRCh37"


