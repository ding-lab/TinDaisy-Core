DATAD="/usr/local/somaticwrapper/testing/StrelkaDemo.dat"
source project_config.sh $DATAD

STEP="vep_annotate"

# vep_annotate:  
#     --input_vcf s: VCF file to be annotated with vep_annotate.  Required
#     --reference_fasta s: path to reference.  Required
#     --assembly s: either "GRCh37" or "GRCh38", used to identify cache file. Optional if not ambigous 
#     --vep_cache_version s: Cache version, e.g. '90', used to identify cache file.  Optional if not ambiguous
#     --vep_cache_gz: is a file ending in .tar.gz containing VEP cache tarball
#     --vep_cache_dir s: location of VEP cache directory
#         VEP Cache logic:
#         * If vep_cache_dir is defined, it indicates location of VEP cache 
#         * if vep_cache_dir is not defined, and vep_cache_gz is defined, extract vep_cache_gz contents into "./vep-cache" and use VEP cache
#         * if neither vep_cache_dir nor vep_cache_gz defined, will perform online VEP DB lookups
#         NOTE: Online VEP database lookups a) uses online database (so cache isn't installed) b) does not use tmp files
#           It is meant to be used for testing and lightweight applications.  Use the cache for better performance.
#           See discussion: https://www.ensembl.org/info/docs/tools/vep/script/vep_cache.html 
#     --af_filter_config s: configuration file for af (allele frequency) filter.  Required.
#     --classification_filter_config s: configuration file for classification filter.  Required.
#     --bypass_af: Bypass AF filter by retaining all reads
#     --bypass_classification: Bypass Classification filter by retaining all reads
#     --bypass: Bypass all filters
#     --debug: print out processing details to STDERR

INPUT_VCF="results/merged/merged.filtered.vcf"

# We rely on online VEP cache lookup for StrelkaDemo testing, so vep_cache_dir is not specified
# AF filtering cannot be performed as a result, since that requires cache

# Parameters needed for cache use:
#--vep_cache_dir /image/D_VEP \
#--vep_cache_version 90 \
#--assembly GRCh37 \

ARGS="\
--input_vcf $INPUT_VCF \
--reference_fasta $REFERENCE_FASTA \
--results_dir $RESULTS_DIR \
--af_filter_config $AF_FILTER_CONFIG \
--classification_filter_config $CLASS_FILTER_CONFIG \
"
#--bypass \


BIN="/usr/local/somaticwrapper/SomaticWrapper.pl"
perl $BIN $ARGS $STEP

# output: results/vep/output.vcf