#DOCKER_SYSTEM="compute1"
DOCKER_SYSTEM="MGI"

# volume mapping is of form PATH_HOST:PATH_CONTAINER
# want to map /gscmnt/gc7202/dinglab/common/databases/VEP to /data
# Note, we will want to put cache files in /data/v99
DATA_HOST="/gscmnt/gc7202/dinglab/common/databases/VEP"

VOLUME_MAPPING="$DATA_HOST:/data"

# Use the tindaisy-vep image
source ../../docker/docker_image.vep.sh

>&2 echo Launching $DOCKER_IMAGE on $DOCKER_SYSTEM
DOCKER_CMD="bash ../start_docker.sh -I $DOCKER_IMAGE -M $DOCKER_SYSTEM $VOLUME_MAPPING"
echo Running: $DOCKER_CMD
eval $DOCKER_CMD

