Interpreting STRELKA2 VCF, obtaining VAF:

# SNV 

Data file: /data5/somatic.snvs.vcf.gz

Header and first line: 
```
##priorSomaticSnvRate=0.0001
##INFO=<ID=QSS,Number=1,Type=Integer,Description="Quality score for any somatic snv, ie. for the ALT allele to be present at a significantly different frequency in the tumor and normal">
##INFO=<ID=TQSS,Number=1,Type=Integer,Description="Data tier used to compute QSS">
##INFO=<ID=NT,Number=1,Type=String,Description="Genotype of the normal in all data tiers, as used to classify somatic variants. One of {ref,het,hom,conflict}.">
##INFO=<ID=QSS_NT,Number=1,Type=Integer,Description="Quality score reflecting the joint probability of a somatic variant and NT">
##INFO=<ID=TQSS_NT,Number=1,Type=Integer,Description="Data tier used to compute QSS_NT">
##INFO=<ID=SGT,Number=1,Type=String,Description="Most likely somatic genotype excluding normal noise states">
##INFO=<ID=SOMATIC,Number=0,Type=Flag,Description="Somatic mutation">
##INFO=<ID=DP,Number=1,Type=Integer,Description="Combined depth across samples">
##INFO=<ID=MQ,Number=1,Type=Float,Description="RMS Mapping Quality">
##INFO=<ID=MQ0,Number=1,Type=Integer,Description="Total Mapping Quality Zero Reads">
##INFO=<ID=ReadPosRankSum,Number=1,Type=Float,Description="Z-score from Wilcoxon rank sum test of Alt Vs. Ref read-position in the tumor">
##INFO=<ID=SNVSB,Number=1,Type=Float,Description="Somatic SNV site strand bias">
##INFO=<ID=PNOISE,Number=1,Type=Float,Description="Fraction of panel containing non-reference noise at this site">
##INFO=<ID=PNOISE2,Number=1,Type=Float,Description="Fraction of panel containing more than one non-reference noise obs at this site">
##INFO=<ID=SomaticEVS,Number=1,Type=Float,Description="Somatic Empirical Variant Score (EVS) expressing the phred-scaled probability of the call being a false positive observation.">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Read depth for tier1 (used+filtered)">
##FORMAT=<ID=FDP,Number=1,Type=Integer,Description="Number of basecalls filtered from original read depth for tier1">
##FORMAT=<ID=SDP,Number=1,Type=Integer,Description="Number of reads with deletions spanning this site at tier1">
##FORMAT=<ID=SUBDP,Number=1,Type=Integer,Description="Number of reads below tier1 mapping quality threshold aligned across this site">
##FORMAT=<ID=AU,Number=2,Type=Integer,Description="Number of 'A' alleles used in tiers 1,2">
##FORMAT=<ID=CU,Number=2,Type=Integer,Description="Number of 'C' alleles used in tiers 1,2">
##FORMAT=<ID=GU,Number=2,Type=Integer,Description="Number of 'G' alleles used in tiers 1,2">
##FORMAT=<ID=TU,Number=2,Type=Integer,Description="Number of 'T' alleles used in tiers 1,2">
##FILTER=<ID=LowEVS,Description="Somatic Empirical Variant Score (SomaticEVS) is below threshold">
##FILTER=<ID=LowDepth,Description="Tumor or normal sample read depth at this locus is below 2">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	NORMAL	TUMOR
chr1    17626   .   G   A   .   LowEVS  SOMATIC;QSS=14;TQSS=1;NT=ref;QSS_NT=14;TQSS_NT=1;SGT=GG->AG;DP=2216;MQ=12.32;MQ0=1919;ReadPosRankSum=2.05;SNVSB=0.00;SomaticEVS=0.32    DP:FDP:SDP:SUBDP:AU:CU:GU:TU    95:0:0:0:3,22:0,0:92,948:0,0    125:0:0:0:10,48:0,0:115,1197:0,1
```

Population of REF values:
    41009 A
    52299 C
    52456 G
    41275 T
Population of ALT values:
    52359 A
    42532 C
    41730 G
    50418 T

Translating:
CHROM - chr1
POS - 17626   
ID - .   
REF - G   
ALT - A   
QUAL - .   
FILTER - LowEVS  
INFO - SOMATIC;QSS=14;TQSS=1;NT=ref;QSS_NT=14;TQSS_NT=1;SGT=GG->AG;DP=2216;MQ=12.32;MQ0=1919;ReadPosRankSum=2.05;SNVSB=0.00;SomaticEVS=0.32    
FORMAT - DP:FDP:SDP:SUBDP:AU:CU:GU:TU    
NORMAL - 95:0:0:0:3,22:0,0:92,948:0,0    
TUMOR - 125:0:0:0:10,48:0,0:115,1197:0,1

Values for NORMAL, TUMOR, resp.
DP      95      125             Read depth for tier1 (used+filtered)
FDP     0       0               Number of basecalls filtered from original read depth for tier1
SDP     0       0               Number of reads with deletions spanning this site at tier1
SUBDP   0       0               Number of reads below tier1 mapping quality threshold aligned across this site
AU      3,22    10,48           Number of 'A' alleles used in tiers 1,2
CU      0,0     0,0             Number of 'C' alleles used in tiers 1,2
GU      92,948  115,1197        Number of 'G' alleles used in tiers 1,2
TU      0,0     0,1             Number of 'T' alleles used in tiers 1,2

Calculating VAF.  From https://github.com/Illumina/strelka/blob/v2.9.x/docs/userGuide/README.md#somatic-variant-allele-frequencies

    refCounts = Value of FORMAT column $REF + "U" (e.g. if REF="A" then use the value in FOMRAT/AU)
    altCounts = Value of FORMAT column $ALT + "U" (e.g. if ALT="T" then use the value in FOMRAT/TU)
    tier1RefCounts = First comma-delimited value from $refCounts
    tier1AltCounts = First comma-delimited value from $altCounts
    Somatic allele freqeuncy is $tier1AltCounts / ($tier1AltCounts + $tier1RefCounts)

In this case, for normal:
    refCounts = value of GU = "92,948"
    altCounts = value of AU = "3,22"
    tier1RefCounts = 92
    tier1AltCounts = 3
    VAF = 3 / (3 + 92) = 0.0315

For tumor:
    t1RefCounts = 115
    t1AltCounts = 10
    VAF = 10 / (10 + 115) = 0.080

# Indel

## Header and example line:
```
    ##content=strelka somatic indel calls
    ##priorSomaticIndelRate=1e-06
    ##INFO=<ID=QSI,Number=1,Type=Integer,Description="Quality score for any somatic variant, ie. for the ALT haplotype to be present at a significantly different frequency in the tumor and normal">
    ##INFO=<ID=TQSI,Number=1,Type=Integer,Description="Data tier used to compute QSI">
    ##INFO=<ID=NT,Number=1,Type=String,Description="Genotype of the normal in all data tiers, as used to classify somatic variants. One of {ref,het,hom,conflict}.">
    ##INFO=<ID=QSI_NT,Number=1,Type=Integer,Description="Quality score reflecting the joint probability of a somatic variant and NT">
    ##INFO=<ID=TQSI_NT,Number=1,Type=Integer,Description="Data tier used to compute QSI_NT">
    ##INFO=<ID=SGT,Number=1,Type=String,Description="Most likely somatic genotype excluding normal noise states">
    ##INFO=<ID=RU,Number=1,Type=String,Description="Smallest repeating sequence unit in inserted or deleted sequence">
    ##INFO=<ID=RC,Number=1,Type=Integer,Description="Number of times RU repeats in the reference allele">
    ##INFO=<ID=IC,Number=1,Type=Integer,Description="Number of times RU repeats in the indel allele">
    ##INFO=<ID=IHP,Number=1,Type=Integer,Description="Largest reference interrupted homopolymer length intersecting with the indel">
    ##INFO=<ID=MQ,Number=1,Type=Float,Description="RMS Mapping Quality">
    ##INFO=<ID=MQ0,Number=1,Type=Integer,Description="Total Mapping Quality Zero Reads">
    ##INFO=<ID=SOMATIC,Number=0,Type=Flag,Description="Somatic mutation">
    ##INFO=<ID=OVERLAP,Number=0,Type=Flag,Description="Somatic indel possibly overlaps a second indel.">
    ##INFO=<ID=SomaticEVS,Number=1,Type=Float,Description="Somatic Empirical Variant Score (EVS) expressing the phred-scaled probability of the call being a false positive observation.">
    ##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Read depth for tier1">
    ##FORMAT=<ID=DP2,Number=1,Type=Integer,Description="Read depth for tier2">
    ##FORMAT=<ID=TAR,Number=2,Type=Integer,Description="Reads strongly supporting alternate allele for tiers 1,2">
    ##FORMAT=<ID=TIR,Number=2,Type=Integer,Description="Reads strongly supporting indel allele for tiers 1,2">
    ##FORMAT=<ID=TOR,Number=2,Type=Integer,Description="Other reads (weak support or insufficient indel breakpoint overlap) for tiers 1,2">
    ##FORMAT=<ID=DP50,Number=1,Type=Float,Description="Average tier1 read depth within 50 bases">
    ##FORMAT=<ID=FDP50,Number=1,Type=Float,Description="Average tier1 number of basecalls filtered from original read depth within 50 bases">
    ##FORMAT=<ID=SUBDP50,Number=1,Type=Float,Description="Average number of reads below tier1 mapping quality threshold aligned across sites within 50 bases">
    ##FORMAT=<ID=BCN50,Number=1,Type=Float,Description="Fraction of filtered reads within 50 bases of the indel.">
    ##FILTER=<ID=LowEVS,Description="Somatic Empirical Variant Score (SomaticEVS) is below threshold">
    ##FILTER=<ID=LowDepth,Description="Tumor or normal sample read depth at this locus is below 2">
    #CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	NORMAL	TUMOR
    chr1	4465928	.	GA	G	.	PASS	SOMATIC;QSI=1;TQSI=1;NT=ref;QSI_NT=1;TQSI_NT=1;SGT=het->het;MQ=55.80;MQ0=1;RU=A;RC=13;IC=12;IHP=18;SomaticEVS=10.28	DP:DP2:TAR:TIR:TOR:DP50:FDP50:SUBDP50:BCN50	5:5:4,5:0,0:1,1:4.40:0.00:0.00:0.00	5:5:1,1:4,4:1,1:6.22:0.38:0.00:0.00
```

CHROM - chr1	
POS - 4465928	
ID - .	
REF - GA	
ALT - G	
QUAL - .	
FILTER - PASS	
INFO - SOMATIC;QSI=1;TQSI=1;NT=ref;QSI_NT=1;TQSI_NT=1;SGT=het->het;MQ=55.80;MQ0=1;RU=A;RC=13;IC=12;IHP=18;SomaticEVS=10.28
FORMAT - DP:DP2:TAR:TIR:TOR:DP50:FDP50:SUBDP50:BCN50
NORMAL - 5:5:4,5:0,0:1,1:4.40:0.00:0.00:0.00
TUMOR - 5:5:1,1:4,4:1,1:6.22:0.38:0.00:0.00

Values for Normal, Tumor:
DP      5       5       Read depth for tier1
DP2     5       5       Read depth for tier2
TAR     4,5     1,1     Reads strongly supporting alternate allele for tiers 1,2
TIR     0,0     4,4     Reads strongly supporting indel allele for tiers 1,2
TOR     1,1     1,1     Other reads (weak support or insufficient indel breakpoint overlap) for tiers 1,2
DP50    4.40    6.22    Average tier1 read depth within 50 bases
FDP50   0.00    0.38    Average tier1 number of basecalls filtered from original read depth within 50 bases
SUBDP50 0.00    0.00    Average number of reads below tier1 mapping quality threshold aligned across sites within 50 bases
BCN50   0.00    0.00    Fraction of filtered reads within 50 bases of the indel.

From https://github.com/Illumina/strelka/blob/v2.9.x/docs/userGuide/README.md#somatic-variant-allele-frequencies:
    tier1RefCounts = First comma-delimited value from FORMAT/TAR
    tier1AltCounts = First comma-delimited value from FORMAT/TIR
    Somatic allele freqeuncy is $tier1AltCounts / ($tier1AltCounts + $tier1RefCounts)

Calculating VAF:
    NORMAL
    tier1RefCounts = 4
    tier1AltCounts = 0
    VAF = 0 / (0 + 4) = 0

    TUMOR
    t1RefCount = 1
    t1AltCount = 4
    VAF = 4 / (4 + 1) = 0.8 
