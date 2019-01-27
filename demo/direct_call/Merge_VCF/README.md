Goal of this analysis project is to run `merge_vcf` step using VCFs obtained from test runs of C3L-00004
Specifically, VCFs are from run of non-Mutect TinDaisy together with VCF generated with mutect-tool

# Collecting C3L-00004 VCFs 

## Mutect

From shiso: /Users/mwyczalk/Projects/TinDaisy/mutect-tool/C3L-00004.results/README
    C3L-00004 run 12/12/18 has the PASS filter and TUMOR / NORMAL columns implemented.
    Run started on kamai with, /home/mwyczalk_test/Projects/TinDaisy/mutect-tool/testing/cwl_call/rabix_C3L-00004.sh
    VCF is here:
        katmai:/diskmnt/Projects/cptac_downloads_4/Rabix/mutect-2018-12-12-162320.617/root/mutect_result.vcf
    and is copied here.

Copying above file to ./origdata

## TinDaisy output

Using output of TinDaisy CWL. **TODO** get run directory.  Output written here:
    /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2018-11-26-202516.404/root

### Strelka

Strelka1 was used for this run, and VAF/Length/Depth filters were not applied to the indel call.  Using 
VCF from `run_strelka` directly:
* `/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2018-11-26-202516.404/root/run_strelka/results/strelka/strelka_out/results/passed.somatic.indels.vcf`
    -> copied here as strelka_indel.vcf
* `/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2018-11-26-202516.404/root/run_strelka/results/strelka/strelka_out/results/passed.somatic.snvs.vcf`
    -> copied here as strelka_snv.vcf

### Varscan

* `/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2018-11-26-202516.404/root/varscan_indel_vaf_length_depth_filters/results/vaf_length_depth_filters/filtered.vcf`
    -> copied here as varscan_indel.vcf
* `/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2018-11-26-202516.404/root/varscan_snv_vaf_length_depth_filters/results/vaf_length_depth_filters/filtered.vcf`
    -> copied here as varscan_snv.vcf

### Pindel
* `/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2018-11-26-202516.404/root/pindel_vaf_length_depth_filters/results/vaf_length_depth_filters/filtered.vcf`
    -> copied here as pindel.vcf

# Debugging

## Reference problems

File `README.reference_error` has error output from mutect.  At issue is a reference mismatch in mutect VCF:

```
MESSAGE: Input files /data2/mutect_result.vcf and reference have incompatible contigs. ...
...
/data2/mutect_result.vcf contigs = [chrUn_GL000219v1, chrUn_KI270746v1,...
reference contigs = [chr1, chr2, chr3,...
```

### Mutect

Reference used: /diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa
All references have same md5sum
From `/home/mwyczalk_test/Projects/TinDaisy/mutect-tool/testing/cwl_call/C3L-00004.katmai.yaml`


### TinDaisy run
Reference used: /diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa
from `/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2018-11-26-202516.404/root/run_varscan/cmd.log`

## Conclusion

Sorted contigs from both compared:
* Mutect has 109 contigs
  - Has: chr1, .. chrY, chr14_GL000009v2_random, chrUn_KN707963v1_decoy, etc
* Reference has 2579 contigs
  - Has e.g.: chr11_KI270721v1_random, chr11_KI270721v1_random, etc
* Mutect is strict subset of Reference

It is not clear why mutect has these errors while other callers, which has no contigs listed, does not.
Assume that this is a warning which can be ignored.

As a result, adding the following flag in GATK CombineVariants, which turns error into a warning: 
`-U ALLOW_SEQ_DICT_INCOMPATIBILITY`

# Final testing

To evaluate filter performance, compared "set=" values in merged.vcf and merged.filtered.vcf.  

With `get_set.sh`: 
    grep -v "^#" $1 | cut -f 8 | tr ';' '\n' | grep "set=" 

To get count of all observed set= values:
    get_set.sh merged.vcf | sort | uniq -c > merged.set
    get_set.sh merged.filtered.vcf | sort | uniq -c > merged.filtered.set

Then compare, using vimdiff or:
    diff merged.set merged.filtered.set

For C3L-00004, this was:
    # diff merged.set merged.filtered.set
    1,3d0
    <    1082 set=mutect
    <      20 set=pindel
    <      11 set=sindel
    6d2
    <      92 set=strelka
    10,11d5
    <      36 set=varindel
    <     539 set=varscan

Indicating all single-caller variants were removed. The retained values of "set=" are:
      4 set=sindel-varindel
     11 set=sindel-varindel-pindel
     29 set=strelka-mutect
     17 set=strelka-varscan
    144 set=strelka-varscan-mutect
     94 set=varscan-mutect

This is what we expect.

Note, this will need to be repeated with Strelka2
