# Currently built on denali

#IMAGE="mwyczalkowski/somatic-wrapper:cwl"
IMAGE="cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core"

docker build -t $IMAGE -f Dockerfile .
