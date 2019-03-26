# Output is to pindel/pindel_out

# The output of this step is 
# * output port: pindel/pindel_out/pindel-raw.dat

# After running Pindel, pull out all reads from pindel raw output with the label ChrID
#   http://gmt.genome.wustl.edu/packages/pindel/user-manual.html

# runs pindel with arguments -T 4 -m 6 -w 1
# f_centromere is optional bed file passed to pindel to exclude regions
#   if it is defined, must exist
# will delete temporary files (pindel_D, etc) unless no_delete_temp is true
#
# chrlist is a path to a file listing chromosomes to be processed in parallel, e.g.,
#   chr1
#   chr2
#   ...
# If defined, multiple chromsomes will be processed simultaneously using GNU Parallel.
# The number of chromosomes to run at once is determined by num_parallel
# See run_pindel_parallel.sh for details.

#   Contents of chrlist are passed to pindel's -c argument; its documentation states,
#      -c/--chromosome
#      Which chr/fragment. Pindel will process reads for one chromosome each
#      time. ChrName must be the same as in reference sequence and in read
#      file. '-c ALL' will make Pindel loop over all chromosomes. The search
#      for indels and SVs can also be limited to a specific region; -c
#      20:10,000,000 will only look for indels and SVs after position
#      10,000,000 = [10M, end], -c 20:5,000,000-15,000,000 will report
#      indels in the range between and including the bases at position
#      5,000,000 and 15,000,000 = [5M, 15M]. (default ALL)

sub run_pindel {
    my $IN_bam_T = shift;
    my $IN_bam_N = shift;
    my $results_dir = shift;
    my $job_files_dir = shift;
    my $REF = shift;
    my $f_centromere = shift;
    my $no_delete_temp = shift;
    my $chrlist = shift;
    my $num_parallel = shift;

    if (! $no_delete_temp) {
        $no_delete_temp = 0; # avoid empty variables
    }


    my $args = "";
    if ($f_centromere) {
        die "Error: Centromere BED file $f_centromere does not exist\n" if (! -e $f_centromere);
        $args = "$args -J $f_centromere";
        print STDERR "Using centromere BED $f_centromere\n";
    } else {
        print STDERR "No centromere BED\n";
    }

    if ($num_processes) {
        $args += "$args -j $num_processes";
    } 

    if ($chrlist) {     # rely on run_pindel_parallel for file existence check
        $args += "$args -c $chrlist";
    } 


    my $pindel_out = "$results_dir/pindel/pindel_out";
    system("mkdir -p $pindel_out");
    $args="$args -o $pindel_out"

    my $step_output_fn = "pindel-raw.dat";

    my $runfn = "$job_files_dir/j5_pindel.sh";  
    print STDERR "Writing to $runfn\n";
    open(OUT, ">$runfn") or die $!;
    print OUT <<"EOF";
#!/bin/bash

# $SWpaths::pindel_dir/pindel -f $REF -i $config_fn -o $pindel_out/pindel $pindel_args $centromere_arg

bash run_pindel_parallel.sh $args $IN_bam_T $IN_BAM_N $REF

rc=\$?
if [[ \$rc != 0 ]]; then
    >&2 echo Fatal error \$rc: \$!.  Exiting.
    exit \$rc;
fi

cd $pindel_out 
# pulling all output together 
grep ChrID pindel_\*D pindel_\*SI pindel_\*INV pindel_\*TD > $step_output_fn
rc=\$?
if [[ \$rc != 0 ]]; then
    >&2 echo Fatal error \$rc: \$!.  Exiting.
    exit \$rc;
fi

if [[ $no_delete_temp == 1 ]]; then

>&2 echo Not deleting intermediate pindel files

else

>&2 echo Deleting intermediate pindel files
rm -f pindel_*

fi

echo Final result written to $pindel_out/$step_output_fn


EOF

    close OUT;

die("Die before running");

    my $cmd = "bash < $runfn\n";
    print STDERR "Executing:\n $cmd \n";

    my $return_code = system ( $cmd );
    die("Exiting ($return_code).\n") if $return_code != 0;
}

1;
