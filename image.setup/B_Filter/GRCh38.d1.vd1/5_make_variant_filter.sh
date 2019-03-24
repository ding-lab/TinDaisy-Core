#!/bin/bash

# remove DBSNP variants which exist in the COSMIC database
# Creates dbSnP-COSMIC.GRCh38.d1.vd1.vcf.gz, which is to be used by TinDaisy

SNPSIFT_JAR="/diskmnt/Projects/Users/mwyczalk/pkg/snpEff/SnpSift.jar"
OUTD="/home/mwyczalk_test/data/docker/data/B_Filter/GRCh38.d1.vd1"

DBSNP="$OUTD/dbSnP.5col.UCSC.vcf.gz"
COSMICDB="$OUTD/CosmicCodingMuts.v88.UCSC.vcf.gz"
OUT="$OUTD/dbSnP-COSMIC.GRCh38.d1.vd1.vcf.gz"

if [ -e $OUT ]; then
	>&2 echo $OUT exists.  Please delete before running this again.
	exit
fi

>&2 echo Processing $DBSNP and $COSMICDB
>&2 echo Writing to $OUT

#te given command CMD either as dry run or for real
function run_cmd {
    CMD=$@
#    CMD=$(echo "$CMD" | sed 's/"/\\"/g' )   # This will escape the quotes in $CMD


    if [ "$DRYRUN" == "d" ]; then
        >&2 echo Dryrun: $CMD
    else
        >&2 echo Running: $CMD
        eval "$CMD"
    echo here
        test_exit_status
    fi
}

function test_exit_status {
    # Evaluate return value for chain of pipes; see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
    rcs=${PIPESTATUS[*]};
    for rc in ${rcs}; do
        if [[ $rc != 0 ]]; then
            >&2 echo Fatal ERROR.  Exiting.
            exit $rc;
        fi;
    done
}


# if ANNO is defined, write out this intermediate file and don't compress final VCF.  useful for debugging
# if ANNO is undefined (by commenting it out), will use pipeline vesion which does not generate an
#   intermediate file.  also compresses and indexes resulting file

#ANNO="$DATD/dbsnp_cosmic_anno.vcf"

if [ ! -z "$ANNO" ]; then
    # Remove .gz extension if it exists, since not saving compressed file here
    OUT=${OUT%.gz}

    >&2 echo Writing intermediate $ANNO

#    java -jar $SNPSIFT_JAR annotate -id $COSMICDB $DBSNP  > $ANNO
    CMD="java -jar $SNPSIFT_JAR annotate -id $COSMICDB $DBSNP  > $ANNO"
    run_cmd "$CMD"


#    java -jar $SNPSIFT_JAR filter -n " (exists ID) & (ID =~ 'COSM' ) " -f $ANNO > $OUT
    CMD="java -jar $SNPSIFT_JAR filter -n \" (exists ID) & (ID =~ 'COSM' ) \" -f $ANNO > $OUT"
    run_cmd "$CMD"

    >&2 echo Written to $OUT
else
#    java -jar $SNPSIFT_JAR annotate -id $COSMICDB $DBSNP  | java -jar $SNPSIFT_JAR filter -n " (exists ID) & (ID =~ 'COSM' ) " | bgzip > $OUT
    CMD="java -jar $SNPSIFT_JAR annotate -id $COSMICDB $DBSNP  | java -jar $SNPSIFT_JAR filter -n \" (exists ID) & (ID =~ 'COSM' ) \" | bgzip > $OUT"
    run_cmd "$CMD"

    CMD="tabix -p vcf $OUT"
    run_cmd "$CMD"

    >&2 echo Written and indexed $OUT
fi


