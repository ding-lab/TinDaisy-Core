Development of pindel parallel code using MantaDemo data, which is a good platform for it.
NOte that pindel seems to crash when a chromosome has no data associated with it.  May consider
adding `ulimit -c 0` to script to prevent large coredumps during testing

chrlist.txt was created on denali directly from NCBI assembly report on denali.  Obtained from
denali:/home/mwyczalk_test/Projects/TinDaisy/TinDaisy-Core/image.setup/B_Filter/GRCh38.d1.vd1/dat/chrlist.txt
