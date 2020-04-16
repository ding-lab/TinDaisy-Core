Build docker image containing TinDaisy-Core and all necessary software to run it.

Currently building two images:
* mwyczalkowski/tindaisy-core
* mwyczalkowski/tindaisy-vep

the tindaisy-vep image is a subset of tindaisy-core, with only VEP annotation-specific installation

Note that re-building tindaisy-core may fail because of updated versions of downloaded software
May be necessary to update Dockerfile dependencies or specify specific software versions

[TinDaisy](https://github.com/ding-lab/TinDaisy) is an associated CWL-based workflow wrapper
which includes TinDaisy-Core

