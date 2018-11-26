# Currently built on denali

#IMAGE="mwyczalkowski/somatic-wrapper:cwl"
IMAGE="cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core:20181126"

docker build -t $IMAGE -f Dockerfile .
