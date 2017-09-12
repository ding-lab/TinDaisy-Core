
# Note that DATA_DIR is mapped to the container
# SomaticWrapper work directory is $DATA_DIR/data
#   This allows directories not executed by SomaticWrapper (e.g., A_Reference) to exist on the data partition too
DATA_DIR="/home/mwyczalk_test/src/SomaticWrapper/data"
IMAGE="somatic-wrapper"

docker run -v $DATA_DIR:/data -it $IMAGE

# To start another terminal in running container, first get name of running container with `docker ps`,
# then start bash in it with,
# `docker exec -it <container_name> bash`
