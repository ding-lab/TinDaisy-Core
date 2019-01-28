from common_filter import *
import sys

# Filter VCF files according to tumor, normal read depth
#
# the following parameters are required:
# * min_depth_tumor
# * min_depth_normal
# * tumor_name
# * normal_name
# * caller caller - specifies tool used for variant call. 'strelka', 'varscan', 'pindel', 'mutect'
#
# These may be specified on the command line (e.g., --min_depth_normal 10) or in
# configuration file, as specified by --config config.ini  Sample contents of config file:
#   [read_depth]
#   min_depth_normal = 10
#
# optional command line parameters
# --debug
# --config config.ini
# --bypass
#
# Note, parser just needs the leading unique string, so --bypass will generally work

class DepthFilter(ConfigFileFilter):
    'Filter variant sites by read depth'
    # Normally we would be able to use the built-in filter "dps"; however, pindel does not write the DP tag and depth filtering fails

    name = 'read_depth'

    @classmethod
    def customize_parser(self, parser):

        parser.add_argument('--min_depth_tumor', type=int, help='Retain sites where read depth for tumor > given value')
        parser.add_argument('--min_depth_normal', type=int, help='Retain sites where read depth for normal > given value')
        parser.add_argument('--tumor_name', type=str, help='Tumor sample name in VCF')
        parser.add_argument('--normal_name', type=str, help='Normal sample name in VCF')
        parser.add_argument('--caller', type=str, choices=['strelka', 'varscan', 'pindel', 'mutect'], help='Caller type')
        parser.add_argument('--debug', action="store_true", default=False, help='Print debugging information to stderr')
        parser.add_argument('--config', type=str, help='Optional configuration file')
        parser.add_argument('--bypass', action="store_true", default=False, help='Bypass filter by retaining all variants')

    def __init__(self, args):
        # These will not be set from config file (though could be)
        self.debug = args.debug
        self.bypass = args.bypass

        # Read arguments from config file first, if present.
        # Then read from command line args, if defined
        # Note that default values in command line args would
        #   clobber configuration file values so are not defined
        config = self.read_config_file(args.config)

        self.set_args(config, args, "caller")
        self.set_args(config, args, "min_depth_tumor", arg_type="int")
        self.set_args(config, args, "min_depth_normal", arg_type="int")
        self.set_args(config, args, "tumor_name")
        self.set_args(config, args, "normal_name")

        # below becomes Description field in VCF
        if self.bypass:
            self.__doc__ = "Bypassing Depth filter, retaining all reads. Caller = %s" % (self.caller)
        else:
            self.__doc__ = "Retain calls where read depth in tumor > %s and normal > %d. Caller = %s " % (self.min_depth_tumor, self.min_depth_normal, self.caller)

    def filter_name(self):
        return self.name

    def get_depth_strelka(self, VCF_data):
        depth = VCF_data.DP
        if self.debug:
            eprint("strelka depth = %d" % depth)
        return depth

    def get_depth_varscan(self, VCF_data):
        depth = VCF_data.DP
        if self.debug:
            eprint("varscan depth = %d" % depth)
        return depth

    def get_depth_pindel(self, VCF_data):
        rc_ref, rc_var = VCF_data.AD
        depth = rc_ref + rc_var
        if self.debug:
            eprint("pindel depth = %d" % depth)
        return depth

    def get_depth_mutect(self, VCF_data):
    # Depth can be obtained in one of two ways, with AD (allelic depths) or DP (read depth) values in VCF:
    # FORMAT=<ID=AD,Number=.,Type=Integer,Description="Allelic depths for the ref and alt alleles in the order listed">
    # FORMAT=<ID=DP,Number=1,Type=Integer,Description="Approximate read depth (reads with MQ=255 or with bad mates are filtered)">
    # Testing indicates these are very similar.  SomaticWrapper uses AD, so we'll use AD here too
        rc_ref, rc_var = VCF_data.AD
        depth = rc_ref + rc_var

#        depth_DP = VCF_data.DP
        if self.debug:
            eprint("mutect depth = %d" % depth)
#            eprint("mutect depth_AD = %d, depth_DP = %d " % (depth, depth_DP) )
        return depth

    def get_depth(self, VCF_record, sample_name):
        data=VCF_record.genotype(sample_name).data
        variant_caller = self.caller  
        if variant_caller == 'strelka':
            return self.get_depth_strelka(data)
        elif variant_caller == 'varscan':
            return self.get_depth_varscan(data)
        elif variant_caller == 'pindel':
            return self.get_depth_pindel(data)
        elif variant_caller == 'mutect':
            return self.get_depth_mutect(data)
        else:
            raise Exception( "Unknown caller: " + variant_caller)

    def __call__(self, record):

        depth_N = self.get_depth(record, self.normal_name)
        depth_T = self.get_depth(record, self.tumor_name)

        if (self.debug):
            eprint("Normal, Tumor depths: %d, %d" % (depth_N, depth_T))

        if self.bypass:
            if (self.debug): eprint("** Bypassing %s filter, retaining read **" % self.name )
            return

        if depth_N < self.min_depth_normal:
            if (self.debug): eprint("** FAIL NORMAL min_depth = %d ** " % depth_N)
            return "depth_N: %d" % depth_N
        if depth_T < self.min_depth_tumor:
            if (self.debug): eprint("** FAIL TUMOR min_depth = %d ** " % depth_T)
            return "depth_T: %d" % depth_T

        if (self.debug):
            eprint("** PASS read depth filter **")
