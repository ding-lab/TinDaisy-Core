CACHED="/data/v99"
mkdir -p $CACHED

# Where VEP is installed in docker image
VEPD="/usr/local/ensembl-vep"
#CWD=`pwd`
#cd /usr/local/ensembl-vep

#perl INSTALL.pl -a cf -s homo_sapiens -y GRCh37 --CACHEDIR $CACHED
perl $VEPD/INSTALL.pl -a cf -s homo_sapiens -y GRCh38 --CACHEDIR $CACHED

#cd $CWD
