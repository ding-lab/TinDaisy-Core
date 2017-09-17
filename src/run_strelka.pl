
sub run_strelka {
    my $sample_name = shift;
    my $sample_full_path = shift;
    my $job_files_dir = shift;
    my $bsub = shift;
    my $STRELKA_DIR = shift;
    my $REF = shift;

    $current_job_file = "j1_streka_".$sample_name.".sh"; 
    my $IN_bam_T = $sample_full_path."/".$sample_name.".T.bam";
    my $IN_bam_N = $sample_full_path."/".$sample_name.".N.bam";
    if (! -e $IN_bam_T) {#make sure there is a input fasta file 
        print $red,  "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n";
        print "Warning: Died because there is no input bam file for bwa:\n";
        print "File $IN_bam_T does not exist!\n";
        die "Please check command line argument!", $normal, "\n\n";

    }
    if (! -s $IN_bam_T) {#make sure input fasta file is not empty
        print $red, "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n";
        die "Warning: Died because $IN_bam_T is empty!", $normal, "\n\n";
    }
    if (! -e $IN_bam_N) {#make sure there is a input fasta file 
        print $red,  "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n";
        print "Warning: Died because there is no input bam file for bwa:\n";
        print "File $IN_bam_N does not exist!\n";
        die "Please check command line argument!", $normal, "\n\n";

    }
    if (! -s $IN_bam_N) {#make sure input fasta file is not empty
        print $red, "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n";
        die "Warning: Died because $IN_bam_N is empty!", $normal, "\n\n";
    }

    my $strelka_config = "/usr/local/somaticwrapper/config/strelka.ini";
    my $strelka_out=$sample_full_path."/strelka/strelka_out";
    my $strelka_bin="$STRELKA_DIR/bin/configureStrelkaWorkflow.pl";


    my $outfn = "$job_files_dir/$current_job_file";
    print("Writing to $outfn\n");
    open(OUT, ">$outfn") or die $!;

    print OUT <<"EOF";
#!/bin/bash

if [ -d $strelka_out ] ; then
    rm -rf $strelka_out
fi

$strelka_bin --normal $IN_bam_N --tumor $IN_bam_T --ref $REF --config $strelka_config --output-dir $strelka_out

cd $strelka_out
make -j 16
EOF

    close OUT;
    my $bsub_com = "$bsub < $job_files_dir/$current_job_file\n";

    print($bsub_com."\n");
    system ( $bsub_com );
}

1;