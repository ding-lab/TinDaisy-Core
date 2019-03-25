#!/bin/bash

# Matthew Wyczalkowski <m.wyczalkowski@wustl.edu>
# https://dinglab.wustl.edu/

read -r -d '' USAGE <<'EOF'
Run Pindel, optionally in parallel runs by chromosome
Output directory is specified by -o, will write files like pindel_CHR_XXX,
  where CHR is chromosome name and XXX is extension given by pindel.
  In the case of processing entire bam, output is pindel_XXX
Generates configuration file OUTD/pindel.config

Usage: 
  run_pindel_parallel.sh [options] TUMOR_BAM NORMAL_BAM REF 

Options:
-d : dry-run. Print commands but do not execute them
-1 : stop after one chromosome if CHRLIST defined, launch only one job and proceed
-c CHRLIST: Filename of file listing genomic reqions which will be processed in parallel, of format 'chr', 'chr:START', 'chr:START-END', or 'ALL'.
   Default is to process all chromosomes at once (equivalent to "-c NONE").  Implies parallel mode
-j JOBS: if parallel run, number of jobs to run at any one time.  Default: 4
-o OUTD: set output root directory.  Default is ./pindel/pindel_out
-J CENTROMERE: optional bed file passed to pindel to exclude regions
-A PINDEL_ARGS: Arguments passed to Pindel.  Default: "-T 4 -m 6 -w 1"
-b PINDEL: path to pindel executable.  Default: /usr/local/pindel/pindel
-C CONFIG_FN: Config file to use instead of one created here

In parallel mode, will use GNU parallel to loop across all chromosomes (as defined by CHRLIST), script will block until all jobs completed.
Output logs written to OUTD/logs/pindel.$CHR.log
EOF

function test_exit_status {
    # Evaluate return value for chain of pipes; see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
    rcs=${PIPESTATUS[*]};
    for rc in ${rcs}; do
        if [[ $rc != 0 ]]; then
            NOW=$(date)
            >&2 echo [ $NOW ] $SCRIPT Fatal ERROR.  Exiting.
            exit $rc;
        fi;
    done
}

function confirm {
    FN=$1
    WARN=$2
    NOW=$(date)
    if [ ! -s $FN ]; then
        if [ -z $WARN ]; then
            >&2 echo [ $NOW ] ERROR: $FN does not exist or is empty
            exit 1
        else
            >&2 echo [ $NOW ] WARNING: $FN does not exist or is empty.  Continuing
        fi
    fi
}

# Evaluate given command CMD either as dry run or for real with
#     CMD="tabix -p vcf $OUT"
#     run_cmd "$CMD"
function run_cmd {
    CMD=$@

    NOW=$(date)
    if [ "$DRYRUN" ]; then
        >&2 echo [ $NOW ] Dryrun: $CMD
    else
        >&2 echo [ $NOW ] Running: $CMD
        eval $CMD
        test_exit_status
        NOW=$(date)
        >&2 echo [ $NOW ] Completed successfully
    fi
}

# Background on `parallel` and details about blocking / semaphores here:
#    O. Tange (2011): GNU Parallel - The Command-Line Power Tool,
#    ;login: The USENIX Magazine, February 2011:42-47.
# [ https://www.usenix.org/system/files/login/articles/105438-Tange.pdf ]

SCRIPT=$(basename $0)

# set defaults
PARALLEL_JOBS=4
OUTD="./pindel/pindel_out"
PINDEL_ARGS=" -T 4 -m 6 -w 1"
PINDEL_BIN="/usr/local/pindel/pindel"

# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":hdc:1fj:o:J:A:b:C:" opt; do
  case $opt in
    h)
      echo "$USAGE"
      exit 0
      ;;
    d)  # example of binary argument
      >&2 echo "Dry run" 
      DRYRUN=1
      ;;
    c) 
      CHRLIST_ARG=$OPTARG
      ;;
    1) 
      >&2 echo "Will stop after one element of CHRLIST" 
      JUSTONE=1
      ;;
    f) 
      FORCE_OVERWRITE=1
      ;;
    j) 
      PARALLEL_JOBS=$OPTARG  
      ;;
    o) 
      OUTD=$OPTARG
      ;;
    J) 
      confirm $OPTARG
      CENTROMERE_ARG="-f $OPTARG"
      ;;
    A) 
      PINDEL_ARGS="$OPTARG"
      ;;
    b) 
      PINDEL_BIN="$OPTARG"
      ;;
    C) 
      CONFIG_FN="$OPTARG"
      confirm $CONFIG_FN
      ;;
    \?)
      >&2 echo "$SCRIPT: ERROR: Invalid option: -$OPTARG"
      >&2 echo "$USAGE"
      exit 1
      ;;
    :)
      >&2 echo "$SCRIPT: ERROR: Option -$OPTARG requires an argument."
      >&2 echo "$USAGE"
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))


if [ "$#" -ne 3 ]; then
    >&2 echo ERROR: Wrong number of arguments
    >&2 echo "$USAGE"
    exit 1
fi

TUMOR_BAM=$1;   confirm $TUMOR_BAM
NORMAL_BAM=$2;  confirm $NORMAL_BAM
REF=$3;         confirm $REF

if [ $CHRLIST_ARG ]; then
    if [ "$CHRLIST" == "NONE" ]; then
        CHRLIST=""
    else
        CHRLIST=$CHRLIST_ARG
        confirm $CHRLIST 
    fi
fi

# Output, tmp, and log files go here
mkdir -p $OUTD
TMPD="$OUTD/tmp"
mkdir -p $TMPD



# Simple direct processing of BAM
function run_pindel_serial {
    OUT="$OUTD/pindel"
    PINOUT="$OUTD/pindel.out.gz"
    CMD="$PINDEL_BIN -f $REF -i $CONFIG_FN -o $OUT $PINDEL_ARGS $CENTROMERE_ARG | gzip > $PINOUT"
    run_cmd "$CMD"
}

# Using semaphores to block as described here: https://www.usenix.org/system/files/login/articles/105438-Tange.pdf
function run_pindel_parallel {

    # CHRLIST newline-separated list of regions passed to samtools, e.g., 'chr1'
    #   Note that each line passed verbatim to `pindel -c xxx`
    LOGD="$OUTD/logs"
    TMPD="$OUTD/tmp"
    mkdir -p $LOGD
    mkdir -p $TMPD

    # Processing chrom by chrom
    # background about parallel: https://www.usenix.org/system/files/login/articles/105438-Tange.pdf
    # Man page: https://www.gnu.org/software/parallel/man.html
    NOW=$(date)
    MYID=$(date +%Y%m%d%H%M%S)
    >&2 echo [ $NOW ]: Parallel run of uniquely mapped reads
    >&2 echo . 	  Looping over $CHRLIST
    >&2 echo . 	  Parallel jobs: $PARALLEL_JOBS
    >&2 echo . 	  Log files: $LOGD
    >&2 echo . 	  Temp directory: $TMPD
    while read CHR; do

        JOBLOG="$LOGD/pindel.$CHR.log"

        OUT="$OUTD/pindel_${CHR}"
        PINOUT="$OUTD/pindel_${CHR}.out.gz"
        CMD="$PINDEL_BIN -c $CHR -f $REF -i $CONFIG_FN -o $OUT $PINDEL_ARGS $CENTROMERE_ARG | gzip > $PINOUT"

        CMDP="parallel --no-notice --semaphore -j$PARALLEL_JOBS --id $MYID --joblog $JOBLOG --tmpdir $TMPD \"$CMD\" "
        >&2 echo Launching $CHR
        if [ $DRYRUN ]; then
            >&2 echo Dryrun: $CMDP
        else
            >&2 echo Running: $CMDP
            eval $CMDP
        fi
        test_exit_status

        if [ $JUSTONE ]; then
            break
        fi

    done<$CHRLIST

    NOW=$(date)
    >&2 echo [ $NOW ] All jobs launched.  Waiting for them to complete

    # this will wait until all jobs completed
    if [ ! $DRYRUN ]; then
        parallel --no-notice --semaphore --wait --id $MYID
        test_exit_status
    fi

    NOW=$(date)
    >&2 echo [ $NOW ] All jobs have completed, written to $OUTD
}

# Create default configuration file if one is not provided
if [ -z $CONFIG_FN ]; then

    CONFIG_FN="$OUTD/pindel.config"
    >&2 echo Writing configuration file $CONFIG_FN
    TAB="$(printf '\t')"
    cat << EOF > $CONFIG_FN
$TUMOR_BAM${TAB}500${TAB}TUMOR
$NORMAL_BAM${TAB}500${TAB}NORMAL
EOF

fi

if [ ! $CHRLIST ]; then
# no chrom list
    >&2 echo Running pindel all chromosomes
    run_pindel_serial 
else
    >&2 echo Processing BAM in parallel
    run_pindel_parallel 
fi

NOW=$(date)
>&2 echo [ $NOW ] SUCCESS
