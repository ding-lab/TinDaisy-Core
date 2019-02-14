# Image name associated with docker build and push

#DOCKER_IMAGE="mwyczalkowski/somatic-wrapper:cwl"

# Note that we do not want to push this image.  Policy is to make all public images on katmai
#DOCKER_IMAGE="cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core:mutect"
DOCKER_IMAGE="mwyczalkowski/tindaisy-core:mutect"

# If variable below evaluates to true, prevent `docker push`
NO_PUSH=0

