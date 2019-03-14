import filecmp
import os
import subprocess

import pytest


INPUT_VCF = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/input.vcf'
EXPECTED_VCF = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/output_vep.vcf'
EXPECTED_VCF_PICK_ORDER = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/output_vep_pick_order.vcf'
RESULTS_DIRECTORY = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/results'
REFERENCE_FASTA = '/usr/local/somaticwrapper/demo/demo_data/StrelkaDemo.dat/demo20.fa'
OUTPUT_VCF = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/results/vep/output_vep.vcf'

NONSENSE_VCF = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/nonsense.grch37.small.vcf'

#make results directory
try:
    os.mkdir(RESULTS_DIRECTORY)
except OSError:
    print RESULTS_DIRECTORY + ' already exists'


def test_output_vcf():
    """make sure output file is as expected"""
    # actually run command
    cli_args = ['/usr/bin/perl', '/usr/local/somaticwrapper/SomaticWrapper.pl']
    cli_args += ['--results_dir', RESULTS_DIRECTORY,
            '--assembly', 'GRCh37',
            '--input_vcf', INPUT_VCF,
            '--reference_fasta', REFERENCE_FASTA,
            '--vep_cache_version', '90',
            'vep_annotate']
    r = subprocess.check_output(cli_args).decode('utf-8')
    #assert 'blah' == r
 
    s1 = open(EXPECTED_VCF).read()
    s2 = open(OUTPUT_VCF).read()
 
    # skip to header so filtering is easier
    s1 = s1[s1.find('#CHROM'):]
    s2 = s2[s2.find('#CHROM'):]
 
    assert s1 == s2
 
def test_output_vcf_flag_pick():
    """make sure output file is as expected"""
    cli_args = ['/usr/bin/perl', '/usr/local/somaticwrapper/SomaticWrapper.pl']
    cli_args += ['--results_dir', RESULTS_DIRECTORY,
            '--assembly', 'GRCh37',
            '--input_vcf', INPUT_VCF,
            '--reference_fasta', REFERENCE_FASTA,
            '--vep_cache_version', '90',
            '--vep_opts', '"--flag_pick"',
            'vep_annotate']
    subprocess.check_output(cli_args)

    # just make sure it runs
    assert True

# Pick order
# The default pick order: canonical,tsl,biotype,rank,length,ensembl,refseq
# The pick order ranking algorithm in the Ensembl VEP source code:
# https://github.com/Ensembl/ensembl-vep/blob/bf6a76309b022f197e0c2327ae09065c252d3f2c/modules/Bio/EnsEMBL/VEP/OutputFactory.pm#L654
#
# Our current order:
# - tsl: Transcript Support Level (TSL). Prefer TSL1 > TSL2 > NA
# - biotype: Biotype of the transcript. Prefer protein coding over the rest
# - rank: Rank of the variant consequence using SO (Sequence Ontolog) order at
#         http://www.ensembl.org/info/genome/variation/prediction/predicted_data.html
# - canonical: Whether Ensembl thinks the transcript is canonical of the gene. Prefer canonical over the rest
# - ccds: Whether the transcript has the CCDS identifier. Prefer one with CCDS ID over none
# - length: Transcript length. Prefer longer
def test_output_nonsense():
    """make sure output file is as expected"""
    cli_args = ['/usr/bin/perl', '/usr/local/somaticwrapper/SomaticWrapper.pl']
    cli_args += ['--results_dir', RESULTS_DIRECTORY,
            '--assembly', 'GRCh37',
            '--input_vcf', NONSENSE_VCF,
            '--reference_fasta', REFERENCE_FASTA,  # shouldn't matter for online lookup
            '--vep_cache_version', '90',
            '--vep_opts', '"--pick --pick_order tsl,biotype,rank,canonical,ccds,length"',
            'vep_annotate']
    subprocess.check_output(cli_args)

    assert 'stop_gained' in open(OUTPUT_VCF).read()
