# May need to do the following first:
# docker login cgc-images.sbgenomics.com
#
# Password is authentication token obtained from https://cgc.sbgenomics.com/developer#token

IMAGE="cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core:dev"
docker push $IMAGE

