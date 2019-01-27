source project_data.sh 

STEP="run_strelka2"

# run_strelka2:
#     --tumor_bam s:  path to tumor BAM.  Required
#     --normal_bam s: path to normal BAM.  Required
#     --reference_fasta s: path to reference.  Required
#     --strelka_config s: path to strelka.ini file.  Required
#     --manta_vcf: pass Manta VCF calls to Strelka2 as input.  Optional

ARGS="\
--tumor_bam $TUMOR_BAM \
--normal_bam $NORMAL_BAM \
--reference_fasta $REFERENCE_FASTA \
--strelka_config $STRELKA_CONFIG \
--results_dir $RESULTS_DIR \
"

BIN="/usr/local/somaticwrapper/SomaticWrapper.pl"
perl $BIN $ARGS $STEP

# Output (--is_strelka2): results/strelka/strelka_out/results/variants/somatic.snvs.vcf.gz
# With Strelka1: results/strelka/strelka_out/results/passed.somatic.snvs.vcf
