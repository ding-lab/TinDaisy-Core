# Basic script to start bash in a SomaticWrapper container in standard Docker 

# Directory below maps to /data in container
DATD="test_data"

IMAGE="cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core"

# Get absolute path in system-independent way
# see https://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-of-gnus-readlink-f-on-a-mac
ADATD=$(python -c 'import os,sys;print(os.path.realpath(sys.argv[1]))' $DATD)

>&2 echo Starting docker image $IMAGE
>&2 echo Mapping $ADATD to /data

docker run -v $ADATD:/data -it $IMAGE

# To start another terminal in running container, first get name of running container with `docker ps`,
# then start bash in it with,
# `docker exec -it <container_name> bash`

