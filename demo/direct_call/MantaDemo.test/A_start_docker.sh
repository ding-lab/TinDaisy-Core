IMG="cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core:dev"


:ONFIG="project_data.sh"
source $CONFIG

OUTD="/diskmnt/Projects/cptac_downloads_4/TinDaisy-Core"
>&2 echo Output directory: $OUTD
mkdir -p $OUTD

# See project_data.sh details.  

# All entries below are paths to directories
PROJECT_PATH="/home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core"
MANTA_DEMO_DATAD_H="$PROJECT_PATH/demo/demo_data/MantaDemo.dat"
PARAMD_H="$PROJECT_PATH/params"
CENTROMERED_H="$PROJECT_PATH/demo/demo_data/MantaDemo.dat"

DATA1=$OUTD
DATA2=$MANTA_DEMO_DATAD_H
DATA3=$MANTA_DEMO_DATAD_H
DATA4=$PARAMD_H
DATA5=$MANTA_DEMO_DATAD_H
DATA6=$MANTA_DEMO_DATAD_H
DATA7=$CENTROMERED_H


bash $PROJECT_PATH/src/start_docker.sh  -I $IMG $@ \
    $DATA1 $DATA2 $DATA3 $DATA4 $DATA5 $DATA6 $DATA7

