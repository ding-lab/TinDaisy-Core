# Output is to pindel/pindel_out

# CWL addition:
# the `grep ChrID` step which was in the parse_pindel step (see SomaticWrapper.v2.Combined.pdf) has
# been moved to the run_pindel step
# The output of this step is then 
# * output port: pindel/pindel_out/pindel_raw.dat

# After running Pindel, pull out all reads from pindel raw output with the label ChrID
#   http://gmt.genome.wustl.edu/packages/pindel/user-manual.html

sub run_pindel{
    my $IN_bam_T = shift;
    my $IN_bam_N = shift;
    my $sample_full_path = shift;
    my $job_files_dir = shift;
    my $REF = shift;
    my $pindel_dir = shift;
    my $f_centromere = shift;

    my $bsub = "bash";
    $current_job_file = "j5_pindel.sh";  
    my $step_output_fn = "pindel_raw.dat";

    my $pindel_out = "$sample_full_path/pindel/pindel_out";
    system("mkdir -p $pindel_out");

    my $config_fn = "$pindel_out/pindel.config";
    print("Writing to $config_fn\n");
    open(OUT, ">$config_fn") or die $!;
    print OUT <<"EOF";
$IN_bam_T\t500\tpindel.T
$IN_bam_N\t500\tpindel.N
EOF

    my $pindel_args = " -T 4 -m 6 -w 1 ";

    my $out = "$job_files_dir/$current_job_file";
    print("Writing to $out\n");
    open(OUT, ">$out") or die $!;
    print OUT <<"EOF";
#!/bin/bash

$pindel_dir/pindel -f $REF -i $config_fn -o $pindel_out/pindel $pindel_args -J $f_centromere

# This step from parse_pindel
# old, weird
#echo Collecting results in $pindel_results
#find $pindel_results -name \'*_D\' -o -name \'*_SI\' -o -name \'*_INV\' -o -name \'*_TD\'  > $outlist
#list=\$(xargs -a  $outlist)
#cat \$list | grep ChrID > $pin_var_file

    cd $pindel_out 
    grep ChrID pindel_D pindel_SI pindel_INV pindel_TD > $step_output_fn;
    

EOF

    close OUT;

    my $bsub_com = "$bsub < $job_files_dir/$current_job_file\n";
    print("Executing:\n $bsub_com \n");

    system ( $bsub_com );   
}

1;
