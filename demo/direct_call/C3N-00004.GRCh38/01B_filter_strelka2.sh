source project_data.sh

STEP="vaf_length_depth_filters"

# vaf_length_depth_filters: apply VAF, indel length, and read depth filters to a VCF
#     --input_vcf s: VCF file to process.  Required
#     --output_vcf s: Name of output VCF file (written to results_dir/vaf_length_depth_filters/output_vcf).  Required.
#     --caller s: one of strelka, pindel, varscan - ignoring this, will come from config file
#     --vcf_filter_config: Configuration file for VCF filtering (depth, VAF, read count).  Required
#     --bypass_vaf: skip VAF filter
#     --bypass_length: skip length filter
#     --bypass_depth: skip depth filter
#     --bypass: skip all filters
#     --debug: print out processing details to STDERR

function test_exit_status {
    # Evaluate return value for chain of pipes; see https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
    rcs=${PIPESTATUS[*]};
    for rc in ${rcs}; do
        if [[ $rc != 0 ]]; then
            >&2 echo Fatal error.  Exiting.
            exit $rc;
        fi;
    done
}


function run_vld_filter {
# Usage: run_vld_filter INPUT_VCF OUTPUT_VCF XARG

ARGS="\
--input_vcf $1 \
--output_vcf $2 \
--vcf_filter_config $3 \
--results_dir $RESULTS_DIR \
$5 \
"

BIN="/usr/local/somaticwrapper/SomaticWrapper.pl"
perl $BIN $ARGS $STEP
test_exit_status

}

echo Skipping SNV filtering for testing
#INPUT_VCF="$RESULTS_DIR/strelka2/strelka_out/results/variants/somatic.snvs.vcf.gz"
#run_vld_filter $INPUT_VCF strelka.snv.vcf $STRELKA_VCF_FILTER_CONFIG

INPUT_VCF="$RESULTS_DIR/strelka2/strelka_out/results/variants/somatic.indels.vcf.gz"
run_vld_filter $INPUT_VCF strelka.snv.vcf $STRELKA_VCF_FILTER_CONFIG

