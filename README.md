# TinDaisy-Core

Somatic variant caller based on SomaticWrapper (CWL branch).
Detect somatic variants from tumor and normal exome data.

TinDaisy pipeline is a fully automated and modular software package
designed for detection of somatic variants from tumor and normal exome data. 
It was developed from GenomeVIP. Incorprates varscan, strelka, and pindel for variant calling.

## Installation

See [TinDaisy](https://github.com/ding-lab/TinDaisy) for details
about installation and usage of TinDaisy-Core in a CWL environment

## Implementation

Visual outline of canonical workflow.  Note that the actual workflow is implemented at CWL level
in [TinDaisy](https://github.com/ding-lab/TinDaisy)

### Overall
![Somatic Wrapper Overview](docs/Overall.png)
### Strelka
![Somatic Wrapper Strelka Details](docs/Strelka_Detail.png)
### Varscan
![Somatic Wrapper Varscan Details](docs/Varscan_Detail.png)
### Pindel
![Somatic Wrapper Pindel Details](docs/Pindel_Detail.png)

## SomaticWrapper CWL branch

TinDaisy-Core is a mirror from [SomaticWrapper cwl-dev branch](https://github.com/ding-lab/somaticwrapper/tree/cwl-dev)
Refer to documentation there for additional details.


## Authors

* Matthew Wyczalkowski
* Song Cao (SomaticWrapper)
