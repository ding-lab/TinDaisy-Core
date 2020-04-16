source docker_image.vep.sh

if [ $NO_PUSH != 0 ]; then
    >&2 echo docker push not permitted
    exit 1
fi

CMD="docker push $DOCKER_IMAGE"
echo $CMD
eval $CMD

