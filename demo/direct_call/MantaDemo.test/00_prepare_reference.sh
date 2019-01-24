# MantaDemo needs to have the reference extracted 
# This script does that, if reference does not yet exist

source project_data.sh 

if [ ! -e $REFERENCE_FASTA ]; then
    TARBALL="${REFERENCE_FASTA}.tar.bz2"
    if [ -e $TARBALL ]; then
        DIRNAME=$(dirname $TARBALL)
        >&2 echo Uncompressing $TARBALL into $DIRNAME
        tar -C $DIRNAME -xvjf $TARBALL
        rc=$?
        if [[ $rc != 0 ]]; then
            >&2 echo ERROR $rc: $!.  Exiting.
            exit $rc;
        fi

    else
        >&2 echo ERROR: Reference does not exist $REFERENCE_FASTA
        >&2 echo "    and unable to uncompress $TARBALL"
        exit
    fi
else
    >&2 echo Reference $REFERENCE_FASTA exists.  Nothing to do
fi

