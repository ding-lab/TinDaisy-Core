# Build tindaisy-core

source docker_image.core.sh

# Build needs to take place in root directory of project
cd ..

CMD=" docker build -t $DOCKER_IMAGE -f docker/Dockerfile.core ."
echo $CMD
eval $CMD
