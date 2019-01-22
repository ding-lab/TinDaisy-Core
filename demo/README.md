Scripts here are used to start Somatic Wrapper docker container and run Somatic Wrapper directly from within it.
Provides a test bed using StrelkaDemo test dataset for development and testing

## Quick start
1. Start Docker container and mount volumes with `start_docker.sh`
2. Once within container, update TinDaisy-Core project with
   `git pull origin master`
3. Test individual steps.  For instance,
```
   cd testing/vcf_filters.test
   bash 1_test_vaf_filter.sh
```

## Docker testing and development

The Docker image `cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core` incorporates the core algorithms
of TinDaisy, based on CWL branch of SomaticWrapper, and is the image used for all work here.

To start a docker container,
```
docker run -it cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core bash
```
To open another terminal in a running container (with container ID `03e59caeeb98`):
```
docker exec -it 03e59caeeb98 bash
```
Use `docker ps -a` and `docker start` to discover and restart stopped containers

## Editing and committing
Editing TinDaisy-Core within the docker image is very helpful for development and debugging.  It requires at least
one terminal running in the container.  Once edits are made in the container, they need to be incorporated into the image.
This can be done in one of two ways:

### Docker Commit
```
docker commit 03e59caeeb98 cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core
```
will incorporate them into the image.  Such edits will then be available the next time the image runs.
These can be pushed to cgc-images with,  
```
docker push cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core
```

### Docker Build

A preferred alternative (to maintain reproducibility) is to `git push` to the
repository from within the container, then re-generate the image using
`1_docker_build.sh` and `2_push_docker.sh` in `somaticwrapper/docker`, which 
clones the github repository.
