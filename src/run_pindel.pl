# Output is to pindel/pindel_out

# The output of this step is 
# * output port: pindel/pindel_out/pindel-raw.dat

# After running Pindel, pull out all reads from pindel raw output with the label ChrID
#   http://gmt.genome.wustl.edu/packages/pindel/user-manual.html

# runs pindel with arguments -T 4 -m 6 -w 1
# f_centromere is optional bed file passed to pindel to exclude regions
#   if it is defined, must exist
# will delete temporary files (pindel_D, etc) unless no_delete_temp is true

# pindel_chrom is an optional argument which defines which chromosome Pindel should process; 
# it is passed verbatim to pindel -c argument, which is described as,
#
#   -c/--chromosome
#   Which chr/fragment. Pindel will process reads for one chromosome each
#   time. ChrName must be the same as in reference sequence and in read
#   file. '-c ALL' will make Pindel loop over all chromosomes. The search
#   for indels and SVs can also be limited to a specific region; -c
#   20:10,000,000 will only look for indels and SVs after position
#   10,000,000 = [10M, end], -c 20:5,000,000-15,000,000 will report
#   indels in the range between and including the bases at position
#   5,000,000 and 15,000,000 = [5M, 15M]. (default ALL)

sub run_pindel {
    my $IN_bam_T = shift;
    my $IN_bam_N = shift;
    my $results_dir = shift;
    my $job_files_dir = shift;
    my $REF = shift;
    my $f_centromere = shift;
    my $no_delete_temp = shift;
    my $pindel_chrom = shift;

    if (! $no_delete_temp) {
        $no_delete_temp = 0; # avoid empty variables
    }


    my $step_output_fn = "pindel-raw.dat";

    my $pindel_out = "$results_dir/pindel/pindel_out";
    system("mkdir -p $pindel_out");

# This step the original invocation from parse_pindel
#echo Collecting results in $pindel_results
#find $pindel_results -name \'*_D\' -o -name \'*_SI\' -o -name \'*_INV\' -o -name \'*_TD\'  > $outlist
#list=\$(xargs -a  $outlist)
#cat \$list | grep ChrID > $pin_var_file

    my $runfn = "$job_files_dir/j5_pindel.sh";  
    print STDERR "Writing to $runfn\n";
    open(OUT, ">$runfn") or die $!;
    print OUT <<"EOF";
#!/bin/bash

# $SWpaths::pindel_dir/pindel -f $REF -i $config_fn -o $pindel_out/pindel $pindel_args $centromere_arg

bash run_pindel_parallel.sh $IN_bam_T $IN_BAM_N $REF


rc=\$?
if [[ \$rc != 0 ]]; then
    >&2 echo Fatal error \$rc: \$!.  Exiting.
    exit \$rc;
fi

cd $pindel_out 
grep ChrID pindel_D pindel_SI pindel_INV pindel_TD > $step_output_fn
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

    my $cmd = "bash < $runfn\n";
    print STDERR "Executing:\n $cmd \n";

    my $return_code = system ( $cmd );
    die("Exiting ($return_code).\n") if $return_code != 0;
}

# NOTE from Sunantha, how to run per chrom in parallel

#ORIG
#echo "$IN_bam_T\t500\t$sample_name.T" > \${CONFIG}
#echo "$IN_bam_N\t500\t$sample_name.N" >> \${CONFIG}
#$pindel -T 4 -f $h37_REF -i \${CONFIG} -o \${myRUNDIR}"."/$sample_name"." -m 6 -w 1 -J $f_centromere
#
#NEW
#echo "$IN_bam_T\t500\t$sample_name.T" > \${CONFIG}
#echo "$IN_bam_N\t500\t$sample_name.N" >> \${CONFIG}
#for chr in {1..22} X 
#do 
#nohup $pindel -T 4 -c \$chr -f $h37_REF -i \${CONFIG} -o \${myRUNDIR}"."/$sample_name"."_\${chr}"." -m 6 -w 1 -J $f_centromere > \${myRUNDIR}"."/$sample_name"."_\${chr}_pindel.log"." & 
#done 
#
#PINDEL options:
#           -c/--chromosome
#           Which chr/fragment. Pindel will process reads for one chromosome each
#           time. ChrName must be the same as in reference sequence and in read
#           file. '-c ALL' will make Pindel loop over all chromosomes. The search
#           for indels and SVs can also be limited to a specific region; -c
#           20:10,000,000 will only look for indels and SVs after position
#           10,000,000 = [10M, end], -c 20:5,000,000-15,000,000 will report
#           indels in the range between and including the bases at position
#           5,000,000 and 15,000,000 = [5M, 15M]. (default ALL)
#


1;
