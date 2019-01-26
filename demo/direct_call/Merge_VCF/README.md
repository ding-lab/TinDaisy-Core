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
* `/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2018-11-26-202516.404/root/run_strelka/results/strelka/strelka_out/results/passed.somatic.snvs.vcf`

### Varscan

* /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2018-11-26-202516.404/root/varscan_indel_vaf_length_depth_filters/results/vaf_length_depth_filters/filtered.vcf
    -> copied here as varscan_indel.vcf
* /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2018-11-26-202516.404/root/varscan_snv_vaf_length_depth_filters/results/vaf_length_depth_filters/filtered.vcf
    -> copied here as varscan_snv.vcf

### Pindel
* /diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2018-11-26-202516.404/root/pindel_vaf_length_depth_filters/results/vaf_length_depth_filters/filtered.vcf
    -> copied here as pindel.vcf

