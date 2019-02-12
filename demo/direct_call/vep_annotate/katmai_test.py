import filecmp
import os
import subprocess

import pytest


RESULTS_DIRECTORY = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/results'
OUTPUT_VCF = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/results/vep/output_vep.vcf'

KATMAI_NONSENSE_VCF = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/nonsense.grch38.vcf'
KATMAI_CACHE_GZ = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/katmai/cache/vep-cache.90_GRCh38.tar.gz'
KATMAI_CACHE_VERSION = '90'
KATMAI_REFERENCE_FASTA = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/katmai/reference/GRCh38.d1.vd1.fa'
KATMAI_ASSEMBLY = 'GRCh38'

#make results directory
try:
    os.mkdir(RESULTS_DIRECTORY)
except OSError:
    print RESULTS_DIRECTORY + ' already exists'


def test_nonsense_vcf():
    cli_args = ['/usr/bin/perl', '/usr/local/somaticwrapper/SomaticWrapper.pl']
    cli_args += ['--results_dir', RESULTS_DIRECTORY,
            '--assembly', KATMAI_ASSEMBLY,
            '--input_vcf', KATMAI_NONSENSE_VCF,
            '--reference_fasta', KATMAI_REFERENCE_FASTA, # shouldn't matter for online lookup
            '--vep_cache_version', KATMAI_CACHE_VERSION,
            '--vep_cache_gz', KATMAI_CACHE_GZ,
            '--vep_opts', '"--pick --pick_order tsl"',
            'vep_annotate']
    r = subprocess.check_output(cli_args).decode('utf-8')

    f = open(OUTPUT_VCF)
    l = [l for l in f if '52587448' in l][0]
    
    assert 'stop_gained' in l
