source project_config.sh

# Bugfix to new pindel2vcf, which leaves off "FORMAT" column header.  Simply adding it on.  Hopefully real fix will be available soon
function reheader_pindel {
mDAT=$1

# HAVE:
#CHROM  POS ID  REF ALT QUAL    FILTER  INFO        NORMAL  TUMOR

# WANT:
#CHROM  POS ID  REF ALT QUAL    FILTER  INFO    FORMAT  NORMAL  TUMOR

awk 'BEGIN{FS="\t";OFS="\t"}{if ($1 == "#CHROM") print $1, $2, $3, $4, $5, $6, $7, $8, "FORMAT", $10, $11; else print $0}' $mDAT 
}

STEP="parse_pindel"
#7 parse_pindel:
#    --pindel_vcf_filter_config: Configuration file for pindel VCF filtering 
#    --pindel_config s: path to pindel.ini file.  Required
#    --pindel_raw s: raw output file generated by pindel run.  Required 
#    --reference_fasta s: path to reference.  Required
#    --dbsnp_db s: database for dbSNP filtering.  Required
#    --results_dir s: Per-sample analysis results location. Often same as sample name [.] 
#    --no_delete_temp : if defined, do not delete temp files

PINDEL_RAW="results/pindel/pindel_out/pindel-raw.dat"

ARGS="\
--pindel_vcf_filter_config $PINDEL_VCF_FILTER_CONFIG \
--pindel_config $PINDEL_CONFIG \
--pindel_raw $PINDEL_RAW \
--reference_fasta $REFERENCE_FASTA \
--dbsnp_db $DBSNP_DB \
--results_dir $RESULTS_DIR \
--no_delete_temp \
"

BIN="/usr/local/somaticwrapper/SomaticWrapper.pl"
perl $BIN $ARGS $STEP

#echo Doing pindel2vcf FORMAT column bugfix
#TMP="results/pindel/filter_out/pindel.out.current_final.dbsnp_pass.filtered.badheader.vcf"
#DAT="results/pindel/filter_out/pindel.out.current_final.dbsnp_pass.filtered.vcf"
#mv -v $DAT $TMP
#echo Reheadering $TMP 
#reheader_pindel $TMP  > $DAT
#rm -v $TMP

# Output: results/pindel/filter_out/pindel.out.current_final.dbsnp_pass.filtered.vcf