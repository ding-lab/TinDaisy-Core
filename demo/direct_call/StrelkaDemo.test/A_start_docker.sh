IMG="cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core:dev"


:ONFIG="project_data.sh"
source $CONFIG

OUTD="/diskmnt/Projects/cptac_downloads_4/TinDaisy-Core"
>&2 echo Output directory: $OUTD
mkdir -p $OUTD

# See project_data.sh details.  Paths specific to katmai
# /data1:/diskmnt/Projects/cptac_downloads_4/TinDaisy-Core
# /data2,/data3 - StrelkaDemo.dat directory = /home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/demo/test_data/StrelkaDemo.dat
# /data4:/home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/params
# /data5,/data6 - StrelkaDemo.dat

# Note that we're repeating a lot of mount paths, but that will be the case only for StrelkaDemo
PROJECT_PATH="/home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core"
PARAMS_H="$PROJECT_PATH/params"
STRELKA_DEMO_DATA_H="$PROJECT_PATH/demo/test_data"

bash $PROJECT_PATH/src/start_docker.sh  $@ \
    $OUTD \                         # /data1
    $STRELKA_DEMO_DATA_H \          # /data2
    $STRELKA_DEMO_DATA_H \          # /data3
    $PARAMS_H \                     # /data4
    $STRELKA_DEMO_DATA_H \          # /data6
    $STRELKA_DEMO_DATA_H            # /data7

