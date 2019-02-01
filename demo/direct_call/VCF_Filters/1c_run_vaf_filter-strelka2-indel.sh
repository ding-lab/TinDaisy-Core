source project_data.sh

# We require --pass_only for STRELKA2 because the output contains spurious non-pass variants 

bash run_vaf_filter.sh $STRELKA2_INDEL_VCF $STRELKA_VCF_FILTER_CONFIG $@ 

