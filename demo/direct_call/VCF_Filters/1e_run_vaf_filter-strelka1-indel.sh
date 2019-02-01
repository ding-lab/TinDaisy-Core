source project_data.sh

# We suggest --pass_only for STRELKA2 because the output contains spurious non-pass variants 
# TODO: direct output somewhere

#bash run_vaf_filter.sh $STRELKA_SNV_VCF $STRELKA_VCF_FILTER_CONFIG $@ 

bash run_vaf_filter.sh $STRELKA1_INDEL_VCF $STRELKA_VCF_FILTER_CONFIG $@ 

