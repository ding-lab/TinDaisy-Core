# Testing for VEP annotate module

### File descriptions

There are two test files

test.py
- Can be run inside container without mounting volumes
- Will test basic vep annotate functionality with the vep annotate online database

katmai_test.py
- Can only be run if a reference fasta and tar.gz cache are mapped into the container test are being run from
- Will test basic vep annotate funcitonality with the cache (no online database lookup)

### Running the test cases

Test can be run in a docker image built off the TinDaisy-Core repository

###### test.py

```bash
$ docker run -it <image_name>
$ pytest demo/direct_call/vep_annotate/test.py -vv
```

OR

```bash
$ docker run -it <image_name> pytest demo/direct_call/vep_annotate/test.py -vv
```

###### katmai_test.py

Requires mapped reference and cache. At the time of writing these files exist in katmai.

```bash
$ docker run -it -v /diskmnt/Datasets/VEP/vep-cache.90_GRCh38.tar.gz:/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/katmai/cache/vep-cache.90_GRCh38.tar.gz -v /diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa:/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/katmai/reference/GRCh38.d1.vd1.fa <image_name>
$ pytest demo/direct_call/vep_annotate/katmai_test.py -vv
```

OR 

```bash
$ docker run -it -v /diskmnt/Datasets/VEP/vep-cache.90_GRCh38.tar.gz:/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/katmai/cache/vep-cache.90_GRCh38.tar.gz -v /diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa:/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/katmai/reference/GRCh38.d1.vd1.fa <image_name> pytest demo/direct_call/vep_annotate/katmai_test.py -vv
```
