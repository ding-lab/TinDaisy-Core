# Run Strelka2

    # Strelka 2 SNV results: $results_dir/strelka2/strelka_out/results/variants/somatic.snvs.vcf.gz
    # Strelka 2 Indel results: $results_dir/strelka2/strelka_out/results/variants/somatic.indels.vcf.gz (confirm this)

# Optional arg manta_vcf is explained in best practice here; https://github.com/Illumina/strelka/blob/master/docs/userGuide/README.md#configuration
# implemented only for is_strelka2
# num_parallel defines number of jobs to run at once, default is 4
sub run_strelka2 {
    my $IN_bam_T = shift;
    my $IN_bam_N = shift;
    my $results_dir = shift;
    my $job_files_dir = shift;
    my $ref = shift;
    my $strelka_config = shift;
    my $manta_vcf = shift;    
    my $num_parallel = shift;

    print STDERR "Running Strelka 2\n";
    $strelka_bin="$SWpaths::strelka2_dir/bin/configureStrelkaSomaticWorkflow.py";

    die "Error: Tumor BAM $IN_bam_T does not exist\n" if (! -e $IN_bam_T);
    die "Error: Tumor BAM $IN_bam_T is empty\n" if (! -s $IN_bam_T);
    die "Error: Normal BAM $IN_bam_N does not exist\n" if (! -e $IN_bam_N);
    die "Error: Normal BAM $IN_bam_N is empty\n" if (! -s $IN_bam_N);

    my $strelka_out=$results_dir."/strelka2/strelka_out";

    # Read configuration file into %params
    # Same format as used for varscan 
    my %params = get_config_params($strelka_config, 0);

    # currently strelka_flags used only for strelka2
    my $strelka_flags = "";
    if ($params{'is_exome'}) {
        $strelka_flags .= " --exome ";
    }
    if ($manta_vcf) {
        $strelka_flags .= " --indelCandidates $manta_vcf ";
    }

    my $expected_out;

    my $runfn = "$job_files_dir/j1b_streka2.sh"; 
    print STDERR "Writing to $runfn\n";
    open(OUT, ">$runfn") or die $!;

#
# strelka 2.  FYI:
#
# Usage: runWorkflow.py [options]
# 
# Version: 2.9.10-4-gd737744
# 
# Options:
#   --version             show program's version number and exit
#   -h, --help            show this help message and exit
#   -m MODE, --mode=MODE  select run mode (local|sge)
#   -q QUEUE, --queue=QUEUE
#                         specify scheduler queue name
#   -j JOBS, --jobs=JOBS  number of jobs, must be an integer or 'unlimited'
#                         (default: Estimate total cores on this node for local
#                         mode, 128 for sge mode)
#   -g MEMGB, --memGb=MEMGB
#                         gigabytes of memory available to run workflow -- only
#                         meaningful in local mode, must be an integer (default:
#                         Estimate the total memory for this node for local
#                         mode, 'unlimited' for sge mode)
#   -d, --dryRun          dryRun workflow code without actually running command-
#                         tasks
#   --quiet               Don't write any log output to stderr (but still write
#                         to workspace/pyflow.data/logs/pyflow_log.txt)
# 
#   development debug options:
#     --rescore           Reset task list to re-run hypothesis generation and
#                         scoring without resetting graph generation.
# 
#   extended portability options (should not be needed by most users):
#     --maxTaskRuntime=hh:mm:ss
#                         Specify scheduler max runtime per task, argument is
#                         provided to the 'h_rt' resource limit if using SGE (no
#                         default)

    $run_args = "";
    if ($num_parallel) {
        $run_args = "-j $num_parallel";
    } else {
        $run_args = "-j 4";
    }

    print STDERR "Executing Strelka 2\n";
    print OUT <<"EOF";
#!/bin/bash

if [ -d $strelka_out ] ; then
    rm -rf $strelka_out
fi

$strelka_bin $strelka_flags --normalBam $IN_bam_N --tumorBam $IN_bam_T --referenceFasta $ref --config $strelka_config --runDir $strelka_out
rc=\$?
if [[ \$rc != 0 ]]; then
    >&2 echo Fatal error \$rc: \$!.  Exiting.
    exit \$rc;
fi


cd $strelka_out
ls
./runWorkflow.py -m local -g 4 $run_args
rc=\$?
if [[ \$rc != 0 ]]; then
    >&2 echo Fatal error \$rc: \$!.  Exiting.
    exit \$rc;
fi

EOF
    close OUT;

    $expected_out="$strelka_out/results/variants/somatic.snvs.vcf.gz";

    my $cmd = "bash < $runfn\n";

    print STDERR $cmd."\n";
    my $return_code = system ( $cmd );
    die("Exiting ($return_code).\n") if $return_code != 0;

    printf STDERR "Testing output $expected_out\n";
    die "Error: Did not find expected output file $expected_out\n" if (! -e $expected_out);
    printf STDERR "OK\n";
}

1;
