IMG="cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core:dev"


CONFIG="project_data.sh"
source $CONFIG

OUTD="/diskmnt/Projects/cptac_downloads_4/TinDaisy-Core"
>&2 echo Output directory: $OUTD
mkdir -p $OUTD

# From project_config.sh
# Mapping volumes
# /data1: output volume
# /data2: Location of test data.  Should be mapped even if using canned data
# /data3: path to reference
# /data4: mapped volume of variant caller and filter parameters
# /data5: Location of strelka2 VCF

# on Katmai
# /data1:/diskmnt/Projects/cptac_downloads_4/TinDaisy-Core
# /data2: /home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/demo/direct_call/Merge_VCF/origdata
# /data3: /diskmnt/Datasets/Reference
# /data4: /home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/params
# /data5: /diskmnt/Projects/cptac_downloads_4/TinDaisy-Core/C3L-00004.demo/strelka2/strelka_out/results/variants

TINDAISY_H="/home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core"

# All entries below are paths to directories
VCFD_H="$TINDAISY_H/demo/direct_call/Merge_VCF/origdata"
REFD_H="/diskmnt/Datasets/Reference"
STRELKAD_H="/diskmnt/Projects/cptac_downloads_4/TinDaisy-Core/C3L-00004.demo/strelka2/strelka_out/results/variants"

PARAMD_H="$TINDAISY_H/params"

DATA1=$OUTD
DATA2=$VCFD_H
DATA3=$REFD_H
DATA4=$PARAMD_H
DATA5=$STRELKAD_H

bash $TINDAISY_H/src/start_docker.sh  -I $IMG $@ \
    $DATA1 $DATA2 $DATA3 $DATA4 $DATA5 $DATA6 $DATA7 $DATA8
