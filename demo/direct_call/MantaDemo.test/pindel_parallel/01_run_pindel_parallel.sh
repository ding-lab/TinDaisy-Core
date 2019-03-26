source ../project_data.sh

BIN="/usr/local/somaticwrapper/src/run_pindel_parallel.sh"

# --tumor_bam $TUMOR_BAM \
# --normal_bam $NORMAL_BAM \
# --reference_fasta $REFERENCE_FASTA \
# --centromere_bed $CENTROMERE_BED \
# --results_dir $RESULTS_DIR \


# adding `ulimit -c 0` to script to prevent large coredumps during testing
ulimit -c 0

bash /usr/local/somaticwrapper/src/run_pindel_parallel.sh $@ $TUMOR_BAM $NORMAL_BAM $REFERENCE_FASTA
