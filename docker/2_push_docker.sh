# May need to do the following first:
# docker login cgc-images.sbgenomics.com
#
# Password is authentication token obtained from https://cgc.sbgenomics.com/developer#token

source docker_image.sh

if [ $NO_PUSH ]; then
    >&2 echo docker push not permitted
    exit 1
fi

CMD="docker push $DOCKER_IMAGE"
echo $CMD
eval $CMD

