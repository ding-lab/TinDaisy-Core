IMG="cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core:dev"

CONFIG="project_data.sh"
source $CONFIG

OUTD="/diskmnt/Projects/cptac_downloads_4/TinDaisy-Core"
>&2 echo Output directory: $OUTD
mkdir -p $OUTD

# See project_data.sh details.  

# All entries below are paths to directories
PROJECT_PATH="/home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core"

DATA1=$OUTD
DATA2="$PROJECT_PATH/demo/direct_call/Merge_VCF/origdata"


bash $PROJECT_PATH/src/start_docker.sh  -I $IMG $@ \
    $DATA1 $DATA2 

