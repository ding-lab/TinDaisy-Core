# build tindaisy-vep

source docker_image.vep.sh

# Build needs to take place in root directory of project
cd ..

CMD=" docker build -t $DOCKER_IMAGE -f docker/Dockerfile.vep ."
echo $CMD
eval $CMD
