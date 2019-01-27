IMG="cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core:dev"


CONFIG="project_data.sh"
source $CONFIG

OUTD="/diskmnt/Projects/cptac_downloads_4/TinDaisy-Core"
>&2 echo Output directory: $OUTD
mkdir -p $OUTD

# From project_config.sh
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

# All entries below are paths to directories
BAMD_H="/diskmnt/Projects/cptac/GDC_import/data"
REFD_H="/diskmnt/Datasets/Reference"

TINDAISY_H="/home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core"
PARAMD_H="$TINDAISY_H/params"
CENTROMERED_H="$TINDAISY_H/demo/demo_data/etc"
DBSNPD_H="/diskmnt/Datasets/dbSNP/SomaticWrapper/B_Filter/"
VEPD_H="/diskmnt/Datasets/VEP"

DATA1=$OUTD
DATA2=$BAMD_H
DATA3=$BAMD_H
DATA4=$REFD_H
DATA5=$PARAMD_H
DATA6=$CENTROMERED_H
DATA7=$DBSNPD_H
DATA8=$VEPD_H


bash $TINDAISY_H/src/start_docker.sh  -I $IMG $@ \
    $DATA1 $DATA2 $DATA3 $DATA4 $DATA5 $DATA6 $DATA7 $DATA8

