source project_data.sh

STEP="merge_vcf"

# merge_vcf:
#     --strelka_snv_vcf s: output file generated by parse_strelka.  Required
#     --varscan_snv_vcf s: output file generated by parse_varscan.  Required
#     --varscan_indel_vcf s: output file generated by parse_varscan.  Required
#     --pindel_vcf s: output file generated by parse_pindel.  Required
#     --reference_fasta s: path to reference.  Required
#     --bypass_merge: Bypass filter by retaining all reads
#     --bypass: Same as --bypass_merge
#     --debug: print out processing details to STDERR


ARGS="\
--strelka_snv_vcf $STRELKA_SNV_VCF \
--strelka_indel_vcf $STRELKA_INDEL_VCF \
--varscan_snv_vcf $VARSCAN_SNV_VCF \
--varscan_indel_vcf $VARSCAN_INDEL_VCF \
--mutect_vcf $MUTECT_VCF \
--pindel_vcf $PINDEL_VCF \
--reference_fasta $REFERENCE_FASTA \
--results_dir $RESULTS_DIR \
"
#--bypass \

BIN="/usr/local/somaticwrapper/SomaticWrapper.pl"
echo perl $BIN $ARGS $STEP

# Result: $RESULTS_DIR/merged/merged.filtered.vcf