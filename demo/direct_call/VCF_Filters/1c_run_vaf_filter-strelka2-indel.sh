source project_data.sh

# We require --pass_only for STRELKA2 because the output contains spurious non-pass variants 
# TODO: continue work here: /usr/local/somaticwrapper/src/vcf_filters/vaf_filter.py

bash run_vaf_filter.sh $STRELKA_INDEL_VCF $STRELKA_VCF_FILTER_CONFIG --pass_only $@

