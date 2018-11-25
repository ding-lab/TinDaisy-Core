Build docker image containing TinDaisy-Core and all
necessary software to run it.

`../docker.testing` includes scripts to start docker image and execute
specific steps from within the docker environment.  This is useful for
debugging and feature development.

`./StrelkaDemo.dat` includes small test dataset (`StrelkaDemo`) which is used
for testing of workflow.

[TinDaisy](https://github.com/ding-lab/TinDaisy) is an associated CWL-based workflow wrapper
which includes TinDaisy-Core

## Tags

Currently TinDaisy-Core has the following image:
`cgc-images.sbgenomics.com/m_wyczalkowski/tindaisy-core`

These should be tagged with specific versions.

