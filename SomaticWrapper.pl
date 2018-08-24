######### Song Cao and Matt Wyczalkowski ###########
## pipeline for somatic variant calling ##

#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long qw(GetOptions);
use File::Basename;

#use POSIX;

# submodule information
# https://stackoverflow.com/questions/1712016/how-do-i-include-functions-from-another-file-in-my-perl-script
require('src/run_strelka.pl');
require("src/run_varscan.pl");
require("src/parse_strelka.pl");
require("src/parse_varscan.pl");
require("src/run_pindel.pl");
require("src/parse_pindel.pl");
require("src/merge_vcf.pl");
require("src/vep_annotate.pl");
require("src/vcf_2_maf.pl");

(my $usage = <<OUT) =~ s/\t+//g;
This script will evaluate variants for WGS and WXS data
Usage: perl $0 [options] step_number 

step_number executes given step of pipeline:
* [1 or run_strelka]  Run streka
* [2 or run_varscan]  Run Varscan
* [3 or parse_strelka]  Parse streka result
* [4 or parse_varscan]  Parse VarScan result
* [5 or run_pindel]  Run Pindel
* [7 or parse_pindel]  Parse Pindel
* [8 or merge_vcf]  Merge vcf files 
* [9 or vep_annotate]  Run VEP annotation on a given file
* [10 or vcf_2_maf]  Run vcf_2_maf on VCF

Required and optional arguments per step

1 run_strelka:
    --tumor_bam s:  path to tumor BAM.  Required
    --normal_bam s: path to normal BAM.  Required
    --reference_fasta s: path to reference.  Required
    --strelka_config s: path to strelka.ini file.  Required
    --results_dir s: Per-sample analysis results location. Often same as sample name [.] 
    --is_strelka2: run stelka2 instead of strelka version 1 
2 run_varscan:
    --tumor_bam s:  path to tumor BAM.  Required
    --normal_bam s: path to normal BAM.  Required
    --reference_fasta s: path to reference.  Required
    --varscan_config s: path to varscan.ini file.  Required
    --results_dir s: Per-sample analysis results location. Often same as sample name [.] 
5 run_pindel:
    --tumor_bam s:  path to tumor BAM.  Required
    --normal_bam s: path to normal BAM.  Required
    --reference_fasta s: path to reference.  Required
    --pindel_config s: path to pindel.ini file.  Required
    --results_dir s: Per-sample analysis results location. Often same as sample name [.] 
    --no_delete_temp : if defined, do not delete temp files
    --centromere_bed s: path to BED file describing centromere regions to exclude for pindel analysis.  
3 parse_strelka:
    --strelka_snv_raw s: SNV output file generated by Stelka run.  Required
    --strelka_config s: path to strelka.ini file.  Required
    --strelka_vcf_filter_config: Configuration file for strelka VCF filtering (depth, VAF, read count).  Required
    --dbsnp_db s: database for dbSNP filtering.  Required
    --results_dir s: Per-sample analysis results location. Often same as sample name [.] 
4 parse_varscan:
    --varscan_snv_raw s: Path to SNV output file generated by varscan run.  Required.
    --varscan_indel_raw s: Indel output file generated by varscan run.  Required
    --varscan_config s: path to varscan.ini file.  Required
    --dbsnp_db s: database for dbSNP filtering.  Required
    --varscan_vcf_filter_config: Configuration file for varscan VCF filtering.  Required
    --results_dir s: Per-sample analysis results location. Often same as sample name [.] 
7 parse_pindel:
    --pindel_vcf_filter_config: Configuration file for pindel VCF filtering 
    --pindel_config s: path to pindel.ini file.  Required
    --pindel_raw s: raw output file generated by pindel run.  Required 
    --reference_fasta s: path to reference.  Required
    --dbsnp_db s: database for dbSNP filtering.  Required
    --results_dir s: Per-sample analysis results location. Often same as sample name [.] 
    --no_delete_temp : if defined, do not delete temp files
8 merge_vcf:
    --strelka_snv_vcf s: output file generated by parse_strelka.  Required
    --varscan_snv_vcf s: output file generated by parse_varscan.  Required
    --varscan_indel_vcf s: output file generated by parse_varscan.  Required
    --pindel_vcf s: output file generated by parse_pindel.  Required
    --reference_fasta s: path to reference.  Required
    --results_dir s: Per-sample analysis results location. Often same as sample name [.] 
    --bypass: Bypass filter by retaining all reads
9 vep_annotate:  
    --input_vcf s: VCF file to be annotated with vep_annotate.  Required
    --reference_fasta s: path to reference.  Required
    --results_dir s: Per-sample analysis results location. Often same as sample name [.] 
    --assembly s: either "GRCh37" or "GRCh38", used to identify cache file. Optional if not ambigous 
    --vep_cache_version s: Cache version, e.g. '90', used to identify cache file.  Optional if not ambiguous
    --vep_cache_gz: is a file ending in .tar.gz containing VEP cache tarball
    --vep_cache_dir s: location of VEP cache directory
        VEP Cache logic:
        * If vep_cache_dir is defined, it indicates location of VEP cache 
        * if vep_cache_dir is not defined, and vep_cache_gz is defined, extract vep_cache_gz contents into "./vep-cache" and use VEP cache
        * if neither vep_cache_dir nor vep_cache_gz defined, will perform online VEP DB lookups
        NOTE: Online VEP database lookups a) uses online database (so cache isn't installed) b) does not use tmp files
          It is meant to be used for testing and lightweight applications.  Use the cache for better performance.
          See discussion: https://www.ensembl.org/info/docs/tools/vep/script/vep_cache.html 
    --vep_output: Define output format after annotation.  Allowed values: vcf, vep.  [vcf]
10 vcf_2_maf:
    --input_vcf s: VCF file to be annotated with vep_annotate.  Required
    --reference_fasta s: path to reference.  Required
    --results_dir s: Per-sample analysis results location. Often same as sample name [.] 
    --assembly s: either "GRCh37" or "GRCh38", used to identify cache file. Optional if not ambigous 
    --vep_cache_version s: Cache version, e.g. '90', used to identify cache file.  Optional if not ambiguous
    --vep_cache_gz: is a file ending in .tar.gz containing VEP cache tarball
    --vep_cache_dir s: location of VEP cache directory
        VEP Cache logic:
        * If vep_cache_dir is defined, it indicates location of VEP cache 
        * if vep_cache_dir is not defined, and vep_cache_gz is defined, extract vep_cache_gz contents into "./vep-cache" and use VEP cache
        * if neither vep_cache_dir nor vep_cache_gz defined, error.  vcf_2_maf does not support online vep_cache lookups
    --vep_output: Define output format after annotation.  Allowed values: vcf, vep.  [vcf]

Note that logic of boolean arguments can be reversed with "no" prefix, e.g. --nois_strelka2 
OUT

# Argument parsing reference: http://perldoc.perl.org/Getopt/Long.html
# https://perlmaven.com/how-to-process-command-line-arguments-in-perl
my $tumor_bam;
my $normal_bam;
my $assembly;
my $vep_cache_version;
my $reference_fasta;
my $results_dir = ".";  
my $vep_cache_dir;
my $vep_output;   
my $is_strelka2;    # Boolean
my $bypass;    # Boolean
my $no_delete_temp; # Boolean
my $strelka_config; 
my $varscan_config; 
my $pindel_config; 
my $centromere_bed; 
my $dbsnp_db;
my $strelka_snv_raw;
my $varscan_indel_raw;
my $varscan_snv_raw;
my $pindel_raw;
my $strelka_snv_vcf;
my $varscan_snv_vcf;
my $varscan_indel_vcf;
my $pindel_vcf;
my $input_vcf;
my $strelka_vcf_filter_config; 
my $varscan_vcf_filter_config; 
my $pindel_vcf_filter_config;

# parameters below based on Docker image locations.  It would perhaps be useful to define these in a configuration file.
my $sw_dir = "/usr/local/somaticwrapper";
my $gvip_dir="$sw_dir/GenomeVIP";
my $filter_dir="$sw_dir/vcf_filters";
my $strelka_dir = "/usr/local/strelka";
my $strelka2_dir = "/usr/local/strelka2";
my $gatk_jar = "/usr/local/GenomeAnalysisTK/GenomeAnalysisTK.jar";
my $perl = "/usr/bin/perl";
my $vep_cmd = "/usr/local/ensembl-vep/vep";
my $pindel_dir = "/usr/local/pindel";
my $snpsift_jar = "/usr/local/snpEff/SnpSift.jar";
my $varscan_jar = "/usr/local/VarScan.jar";


GetOptions(
    'tumor_bam=s' => \$tumor_bam,
    'normal_bam=s' => \$normal_bam,
    'reference_fasta=s' => \$reference_fasta,
    'assembly=s' => \$assembly,
    'vep_cache_version=s' => \$vep_cache_version,
    'results_dir=s' => \$results_dir,
    'vep_cache_dir=s' => \$vep_cache_dir,
    'vep_cache_gz=s' => \$vep_cache_gz,
    'strelka_config=s' => \$strelka_config,
    'varscan_config=s' => \$varscan_config,
    'pindel_config=s' => \$pindel_config,
    'centromere_bed=s' => \$centromere_bed,
    'strelka_dir=s' => \$strelka_dir,
    'strelka2_dir=s' => \$strelka2_dir,
    'dbsnp_db=s' => \$dbsnp_db,
    'strelka_snv_raw=s' => \$strelka_snv_raw,
    'varscan_indel_raw=s' => \$varscan_indel_raw,
    'varscan_snv_raw=s' => \$varscan_snv_raw,
    'pindel_raw=s' => \$pindel_raw,
    'strelka_snv_vcf=s' => \$strelka_snv_vcf,
    'varscan_snv_vcf=s' => \$varscan_snv_vcf,
    'pindel_vcf=s' => \$pindel_vcf,
    'varscan_indel_vcf=s' => \$varscan_indel_vcf,
    'input_vcf=s' => \$input_vcf,
    'vep_output=s' => \$vep_output,
    'no_delete_temp!' => \$no_delete_temp,
    'is_strelka2!' => \$is_strelka2,
    'bypass!' => \$bypass,
    'strelka_vcf_filter_config=s' => \$strelka_vcf_filter_config,
    'varscan_vcf_filter_config=s' => \$varscan_vcf_filter_config,
    'pindel_vcf_filter_config=s' => \$pindel_vcf_filter_config,
) or die "Error parsing command line args.\n$usage\n";

die $usage unless @ARGV >= 1;
my ( $step_number ) = @ARGV;

# filter_xargs can be a model for passing other common args along, like --debug
my $filter_xargs;

# automatically generated scripts in runtime
my $job_files_dir="$results_dir/runtime";  # OUTPUT PORT
system("mkdir -p $job_files_dir");

#print("Using reference $reference_fasta\n");
print("SomaticWrapper dir: $sw_dir \n");
print("Analysis dir: $results_dir\n");
print("Run script dir: $job_files_dir\n");

# so far, only merge_filter has bypass implemented
if ($bypass) {
    print("Running filter bypass (if implemented).  All reads retained\n");
    $filter_xargs = "$filter_xargs --bypass"; 
}

if (($step_number eq '1') || ($step_number eq 'run_strelka')) {
    die("tumor_bam undefined \n") unless $tumor_bam;
    die("normal_bam undefined \n") unless $normal_bam;
    die("strelka_config undefined \n") unless $strelka_config;
    die("reference_fasta undefined \n") unless $reference_fasta;
    my $strelka_bin;
    if ($is_strelka2) {
        print("Running Strelka 2\n");
        $strelka_bin="$strelka2_dir/bin/configureStrelkaSomaticWorkflow.py";
    } else {
        print("Running Strelka 1\n");
        $strelka_bin="$strelka_dir/bin/configureStrelkaWorkflow.pl";
    }
    run_strelka($tumor_bam, $normal_bam, $results_dir, $job_files_dir, $strelka_bin, $reference_fasta, $strelka_config, $is_strelka2);
} elsif (($step_number eq '2') || ($step_number eq 'run_varscan')) {
    die("tumor_bam undefined \n") unless $tumor_bam;
    die("normal_bam undefined \n") unless $normal_bam;
    die("varscan_config undefined \n") unless $varscan_config;
    die("reference_fasta undefined \n") unless $reference_fasta;
    run_varscan($tumor_bam, $normal_bam, $results_dir, $job_files_dir, $reference_fasta, $varscan_config, $varscan_jar);
} elsif (($step_number eq '3') || ($step_number eq 'parse_strelka')) {
    die("Strelka SNV Raw input file not specified \n") unless $strelka_snv_raw;
    die("strelka_config undefined \n") unless $strelka_config;
    die("strelka_vcf_filter_config undefined \n") unless $strelka_vcf_filter_config;
    parse_strelka($results_dir, $job_files_dir, $perl, $gvip_dir, $filter_dir, $dbsnp_db, $snpsift_jar, $strelka_snv_raw, $strelka_vcf_filter_config);
} elsif (($step_number eq '4') || ($step_number eq 'parse_varscan')) {
    die("Varscan Indel Raw input file not specified \n") unless $varscan_indel_raw;
    die("Varscan SNV Raw input file not specified \n") unless $varscan_snv_raw;
    die("varscan_config undefined \n") unless $varscan_config;
    die("varscan_vcf_filter_config undefined \n") unless $varscan_vcf_filter_config;
    parse_varscan($results_dir, $job_files_dir, $perl, $gvip_dir, $filter_dir, $dbsnp_db, $snpsift_jar, $varscan_jar, $varscan_indel_raw, $varscan_snv_raw, $varscan_config, $varscan_vcf_filter_config);
} elsif (($step_number eq '5') || ($step_number eq 'run_pindel')) {
    die("tumor_bam undefined \n") unless $tumor_bam;
    die("normal_bam undefined \n") unless $normal_bam;
    die("reference_fasta undefined \n") unless $reference_fasta;
    run_pindel($tumor_bam, $normal_bam, $results_dir, $job_files_dir, $reference_fasta, $pindel_dir, $centromere_bed, $no_delete_temp);
} elsif (($step_number eq '7') || ($step_number eq 'parse_pindel')) {
    die("pindel_config undefined \n") unless $pindel_config;
    die("pindel raw input file not specified \n") unless $pindel_raw;
    die("reference_fasta undefined \n") unless $reference_fasta;
    die("pindel_vcf_filter_config undefined \n") unless $pindel_vcf_filter_config;
    parse_pindel($results_dir, $job_files_dir, $reference_fasta, $perl, $gvip_dir, $filter_dir, $pindel_dir, $dbsnp_db, $snpsift_jar, $pindel_config, $pindel_raw, $no_delete_temp, $pindel_vcf_filter_config);
} elsif (($step_number eq '8') || ($step_number eq 'merge_vcf')) {
    die("strelka_snv_vcf undefined \n") unless $strelka_snv_vcf;
    die("varscan_snv_vcf undefined \n") unless $varscan_snv_vcf;
    die("pindel_vcf undefined \n") unless $pindel_vcf;
    die("varscan_indel_vcf undefined \n") unless $varscan_indel_vcf;
    die("reference_fasta undefined \n") unless $reference_fasta;
    merge_vcf($results_dir, $job_files_dir, $filter_dir, $reference_fasta, $gatk_jar, $strelka_snv_vcf, $varscan_indel_vcf, $varscan_snv_vcf, $pindel_vcf, $filter_xargs);
} elsif (($step_number eq '9') || ($step_number eq 'vep_annotate')) {
    die("input_vcf undefined \n") unless $input_vcf;
    die("reference_fasta undefined \n") unless $reference_fasta;
    vep_annotate($results_dir, $job_files_dir, $reference_fasta, $gvip_dir, $vep_cmd, $assembly, $vep_cache_version, $vep_cache_dir, $vep_cache_gz, $vep_output, $input_vcf, "af_exec", "af_gnomad")
} elsif (($step_number eq '10') || ($step_number eq 'vcf_2_bam')) {
    die("input_vcf undefined \n") unless $input_vcf;
    die("reference_fasta undefined \n") unless $reference_fasta;
    vcf_2_maf($results_dir, $job_files_dir, $reference_fasta, $gvip_dir, $vep_cmd, $assembly, $vep_cache_version, $vep_cache_dir, $vep_cache_gz, $vep_output, $input_vcf, "exac_vcf")
} else {
    die("Unknown step number $step_number\n");
}
