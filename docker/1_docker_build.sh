# Currently built on denali

# Build needs to take place in root directory of project
cd ..

#IMAGE="mwyczalkowski/somatic-wrapper:cwl"
IMAGE="cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core:dev"

docker build -t $IMAGE -f docker/Dockerfile .
