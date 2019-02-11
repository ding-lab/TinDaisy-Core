export PYTHONPATH="../../src/vcf_filters:$PYTHONPATH"

# This won't work because C3N-01649 data not distributed with this project

VEP_VCF="/data/StrelkaDemo-results/C3N-01649-results/vep_annotate/results/output.unfiltered.vcf"
AF_CONFIG="../../params/af_filter_config.ini"
CLASS_CONFIG="../../params/classification_filter_config.ini"
#ARGS="--debug --bypass"

RUN="../../src/vcf_filters/run_vep_filters.sh"


#   bash run_combined_af_classification_filter.sh input.vcf af_config.ini classification_config.ini output.vcf [args]

ARGS="--debug"
OUT_VCF="-"
bash $RUN $VEP_VCF $AF_CONFIG $CLASS_CONFIG $OUT_VCF $ARGS

ARGS="--bypass_af"
OUT_VCF="tmp/tmp1.vcf"
bash $RUN $VEP_VCF $AF_CONFIG $CLASS_CONFIG $OUT_VCF $ARGS

ARGS="--bypass_classification"
OUT_VCF="tmp/tmp2.vcf"
bash $RUN $VEP_VCF $AF_CONFIG $CLASS_CONFIG $OUT_VCF $ARGS

ARGS="--bypass"
OUT_VCF="tmp/tmp3.vcf"
bash $RUN $VEP_VCF $AF_CONFIG $CLASS_CONFIG $OUT_VCF $ARGS
