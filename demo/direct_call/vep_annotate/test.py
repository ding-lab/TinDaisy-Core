import filecmp
import os
import subprocess

import pytest


INPUT_VCF = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/input.vcf'
EXPECTED_VCF = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/output_vep.vcf'
EXPECTED_VCF_PICK_ORDER = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/output_vep_pick_order.vcf'
RESULTS_DIRECTORY = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/results'
REFERENCE_FASTA = '/usr/local/somaticwrapper/demo/direct_call/vep_annotate/data/demo20.fa'
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

def test_output_nonsense():
    """make sure output file is as expected"""
    cli_args = ['/usr/bin/perl', '/usr/local/somaticwrapper/SomaticWrapper.pl']
    cli_args += ['--results_dir', RESULTS_DIRECTORY,
            '--assembly', 'GRCh37',
            '--input_vcf', NONSENSE_VCF,
            '--reference_fasta', REFERENCE_FASTA,
            '--vep_cache_version', '90',
            '--vep_opts', '"--pick --pick_order tsl"',
            'vep_annotate']
    subprocess.check_output(cli_args)

    assert 'stop_gained' in open(OUTPUT_VCF).read()
