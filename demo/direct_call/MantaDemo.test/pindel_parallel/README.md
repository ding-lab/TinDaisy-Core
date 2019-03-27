Development of pindel parallel code using MantaDemo data, which is a good platform for it.
NOte that pindel seems to crash when a chromosome has no data associated with it.  May consider
adding `ulimit -c 0` to script to prevent large coredumps during testing

GRCh38.d1.vd1.chrlist.txt was created on denali directly from NCBI assembly report on denali.  Obtained from
denali:/home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/image.setup/B_Filter/GRCh38.d1.vd1/dat/GRCh38.d1.vd1.chrlist.txt

Testing parallel run.  C3N-00560 completed successfully with pindel_run doing 4 chrom simultaneously.  Timing:
* Strelka2 (-j 8) - 2.5hrs
* Mutect 4.25 hrs
* Varscan - 5.5 hrs
* pindel (-j 4) - 6.1 hrs
Total run time - 6.75 hrs

We want all jobs to finish roughly at the same time, to optimize CPU usage.  As a result, try
* Strelka2 with -j 4
* pindel with -j 5

This will require a new parameter to control strelka2 job count
