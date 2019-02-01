Interpreting STRELKA2 VCF, obtaining VAF:

# Strelka2 SNV 

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

## REF and ALT values:

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

Parsing in detail first variant:
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

## INFO fields
SOMATIC                 Somatic mutation
QSS=14                  Quality score for any somatic snv, ie. for the ALT allele to be present at a significantly different frequency in the tumor and normal
TQSS=1                  Data tier used to compute QSS
NT=ref                  Genotype of the normal in all data tiers, as used to classify somatic variants. One of {ref,het,hom,conflict}.
QSS_NT=14               Quality score reflecting the joint probability of a somatic variant and NT
TQSS_NT=1               Data tier used to compute QSS_NT
SGT=GG->AG              Most likely somatic genotype excluding normal noise states
DP=2216                 Combined depth across samples
MQ=12.32                RMS Mapping Quality
MQ0=1919                Total Mapping Quality Zero Reads
ReadPosRankSum=2.05     Z-score from Wilcoxon rank sum test of Alt Vs. Ref read-position in the tumor
SNVSB=0.00              Somatic SNV site strand bias
SomaticEVS=0.32         Somatic Empirical Variant Score (EVS) expressing the phred-scaled probability of the call being a false positive observation.

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

Here, 
    REF - G   
    ALT - A   

In this case, for normal:
    refCounts = value of GU = "92,948"
    altCounts = value of AU = "3,22"
    tier1RefCounts = 92
    tier1AltCounts = 3
    VAF = 3 / (3 + 92) = 0.031578947368421

For tumor:
    t1RefCounts GU = 115
    t1AltCounts AU = 10
    VAF = 10 / (10 + 115) = 0.08


# Indel


## Header and example line:
/data5/somatic.indels.vcf.gz
```
##fileformat=VCFv4.1
##fileDate=20190127
##source=strelka
##source_version=2.9.10
##startTime=Sun Jan 27 19:31:17 2019
##cmdline=/usr/local/strelka2/bin/configureStrelkaSomaticWorkflow.py --exome --normalBam /data3/1dee4e84-b617-43a2-add1-c68c5e36bcec/1561b97d-8c8f-4fe6-a244-06452760074d_gdc_realn.bam --tumorBam /data2/524d1cea-62cd-483c-8137-19450faf72b6/82ccdf4e-4527-47ca-8151-7e1248f1da09_gdc_realn.bam --referenceFasta /data4/GRCh38.d1.vd1/GRCh38.d1.vd1.fa --config /data5/strelka.WES.ini --runDir /data1/C3L-00004.demo/strelka2/strelka_out
##reference=file:///data4/GRCh38.d1.vd1/GRCh38.d1.vd1.fa
...
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
chr1	1641578	.	TC	T	.	LowEVS	SOMATIC;QSI=2;TQSI=1;NT=ref;QSI_NT=2;TQSI_NT=1;SGT=ref->ref;MQ=9.32;MQ0=159;RU=C;RC=5;IC=4;IHP=8;SomaticEVS=4.78	DP:DP2:TAR:TIR:TOR:DP50:FDP50:SUBDP50:BCN50	11:11:11,77:0,0:0,1:21.85:0.00:0.00:0.00	10:10:5,87:2,16:4,7:24.50:0.00:0.00:0.00
```

CHROM chr1
POS 1641578
ID .
REF TC
ALT T
QUAL .
FILTER LowEVS
INFO SOMATIC;QSI=2;TQSI=1;NT=ref;QSI_NT=2;TQSI_NT=1;SGT=ref->ref;MQ=9.32;MQ0=159;RU=C;RC=5;IC=4;IHP=8;SomaticEVS=4.78
FORMAT DP:DP2:TAR:TIR:TOR:DP50:FDP50:SUBDP50:BCN50
NORMAL 11:11:11,77:0,0:0,1:21.85:0.00:0.00:0.00
TUMOR 10:10:5,87:2,16:4,7:24.50:0.00:0.00:0.00



Values for Normal, Tumor:
DP      11      10      Read depth for tier1
DP2     11      10      Read depth for tier2
TAR     11,77   5,87    Reads strongly supporting alternate allele for tiers 1,2
TIR     0,0     2,16    Reads strongly supporting indel allele for tiers 1,2
TOR     0,1     4,7     Other reads (weak support or insufficient indel breakpoint overlap) for tiers 1,2
DP50    21.85   24.50   Average tier1 read depth within 50 bases
FDP50   0.00    0.00    Average tier1 number of basecalls filtered from original read depth within 50 bases
SUBDP50 0.00    0.00    Average number of reads below tier1 mapping quality threshold aligned across sites within 50 bases
BCN50   0.00    0.00    Fraction of filtered reads within 50 bases of the indel.


From https://github.com/Illumina/strelka/blob/v2.9.x/docs/userGuide/README.md#somatic-variant-allele-frequencies:
    tier1RefCounts = First comma-delimited value from FORMAT/TAR
    tier1AltCounts = First comma-delimited value from FORMAT/TIR
    Somatic allele freqeuncy is $tier1AltCounts / ($tier1AltCounts + $tier1RefCounts)

Calculating VAF:
    NORMAL
    tier1RefCounts = 11
    tier1AltCounts = 0
    VAF = 0 / (0 + 11) = 0

    TUMOR
    t1RefCount = 5
    t1AltCount = 2
    VAF = 2 / (2 + 5) = 0.285714285714286

# Strelka 1 SNV

```
##fileformat=VCFv4.1
##fileDate=20181127
##source=strelka
##source_version=2.0.17.strelka2
##startTime=Tue Nov 27 02:37:56 2018
##reference=file:///diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa
...
##content=strelka somatic snv calls
##germlineSnvTheta=0.001
##priorSomaticSnvRate=1e-06
##INFO=<ID=QSS,Number=1,Type=Integer,Description="Quality score for any somatic snv, ie. for the ALT allele to be present at a significantly different frequency in the tumor and normal">
##INFO=<ID=TQSS,Number=1,Type=Integer,Description="Data tier used to compute QSS">
##INFO=<ID=NT,Number=1,Type=String,Description="Genotype of the normal in all data tiers, as used to classify somatic variants. One of {ref,het,hom,conflict}.">
##INFO=<ID=QSS_NT,Number=1,Type=Integer,Description="Quality score reflecting the joint probability of a somatic variant and NT">
##INFO=<ID=TQSS_NT,Number=1,Type=Integer,Description="Data tier used to compute QSS_NT">
##INFO=<ID=SGT,Number=1,Type=String,Description="Most likely somatic genotype excluding normal noise states">
##INFO=<ID=SOMATIC,Number=0,Type=Flag,Description="Somatic mutation">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Read depth for tier1 (used+filtered)">
##FORMAT=<ID=FDP,Number=1,Type=Integer,Description="Number of basecalls filtered from original read depth for tier1">
##FORMAT=<ID=SDP,Number=1,Type=Integer,Description="Number of reads with deletions spanning this site at tier1">
##FORMAT=<ID=SUBDP,Number=1,Type=Integer,Description="Number of reads below tier1 mapping quality threshold aligned across this site">
##FORMAT=<ID=AU,Number=2,Type=Integer,Description="Number of 'A' alleles used in tiers 1,2">
##FORMAT=<ID=CU,Number=2,Type=Integer,Description="Number of 'C' alleles used in tiers 1,2">
##FORMAT=<ID=GU,Number=2,Type=Integer,Description="Number of 'G' alleles used in tiers 1,2">
##FORMAT=<ID=TU,Number=2,Type=Integer,Description="Number of 'T' alleles used in tiers 1,2">
##FILTER=<ID=BCNoise,Description="Fraction of basecalls filtered at this site in either sample is at or above 0.4">
##FILTER=<ID=SpanDel,Description="Fraction of reads crossing site with spanning deletions in either sample exceeeds 0.75">
##FILTER=<ID=QSS_ref,Description="Normal sample is not homozygous ref or ssnv Q-score < 15, ie calls with NT!=ref or QSS_NT < 15">
##cmdline=/usr/local/strelka/libexec/consolidateResults.pl --config=/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2018-11-26-202516.404/root/run_strelka/results/strelka/strelka_out/config/run.config.ini
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	NORMAL	TUMOR
chr1    6209173 .   C   A   .   PASS    NT=ref;QSS=184;QSS_NT=184;SGT=CC->AC;SOMATIC;TQSS=1;TQSS_NT=1   DP:FDP:SDP:SUBDP:AU:CU:GU:TU    327:4:0:0:1,1:322,334:0,0:0,0   477:2:0:0:81,82:394,397:0,0:0,0
```
CHROM   chr1
POS     6209173
ID      .
REF     C
ALT     A
QUAL    .
FILTER  PASS
INFO    NT=ref;QSS=184;QSS_NT=184;SGT=CC->AC;SOMATIC;TQSS=1;TQSS_NT=1
FORMAT  DP:FDP:SDP:SUBDP:AU:CU:GU:TU
NORMAL  327:4:0:0:1,1:322,334:0,0:0,0
TUMOR   477:2:0:0:81,82:394,397:0,0:0,0

DP      327     477
FDP     4       2
SDP     0       0
SUBDP   0       0
AU      1,1     81,82
CU      322,334 394,397
GU      0,0     0,0
TU      0,0     0,0

Note, same fields as Strelka 1

# Strelka 1 Indel

```
##fileformat=VCFv4.1
##fileDate=20181127
##source=strelka
##source_version=2.0.17.strelka2
##startTime=Tue Nov 27 02:37:56 2018
##reference=file:///diskmnt/Datasets/Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa
...
##content=strelka somatic indel calls
##germlineIndelTheta=0.0001
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
##INFO=<ID=SVTYPE,Number=1,Type=String,Description="Type of structural variant">
##INFO=<ID=SOMATIC,Number=0,Type=Flag,Description="Somatic mutation">
##INFO=<ID=OVERLAP,Number=0,Type=Flag,Description="Somatic indel possibly overlaps a second indel.">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Read depth for tier1">
##FORMAT=<ID=DP2,Number=1,Type=Integer,Description="Read depth for tier2">
##FORMAT=<ID=TAR,Number=2,Type=Integer,Description="Reads strongly supporting alternate allele for tiers 1,2">
##FORMAT=<ID=TIR,Number=2,Type=Integer,Description="Reads strongly supporting indel allele for tiers 1,2">
##FORMAT=<ID=TOR,Number=2,Type=Integer,Description="Other reads (weak support or insufficient indel breakpoint overlap) for tiers 1,2">
##FORMAT=<ID=DP50,Number=1,Type=Float,Description="Average tier1 read depth within 50 bases">
##FORMAT=<ID=FDP50,Number=1,Type=Float,Description="Average tier1 number of basecalls filtered from original read depth within 50 bases">
##FORMAT=<ID=SUBDP50,Number=1,Type=Float,Description="Average number of reads below tier1 mapping quality threshold aligned across sites within 50 bases">
##FILTER=<ID=Repeat,Description="Sequence repeat of more than 8x in the reference sequence">
##FILTER=<ID=iHpol,Description="Indel overlaps an interrupted homopolymer longer than 14x in the reference sequence">
##FILTER=<ID=BCNoise,Description="Average fraction of filtered basecalls within 50 bases of the indel exceeds 0.3">
##FILTER=<ID=QSI_ref,Description="Normal sample is not homozygous ref or sindel Q-score < 30, ie calls with NT!=ref or QSI_NT < 30">
##cmdline=/usr/local/strelka/libexec/consolidateResults.pl --config=/diskmnt/Projects/cptac_downloads_4/TinDaisy/tindaisy-2018-11-26-202516.404/root/run_strelka/results/strelka/strelka_out/config/run.config.ini
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	NORMAL	TUMOR
chr1	32331580	.	C	CA	.	PASS	IC=3;IHP=2;NT=ref;QSI=85;QSI_NT=85;RC=2;RU=A;SGT=ref->het;SOMATIC;TQSI=1;TQSI_NT=1	DP:DP2:TAR:TIR:TOR:DP50:FDP50:SUBDP50	151:151:136,144:0,0:10,7:151.93:1.36:0.00	187:187:126,127:29,29:30,30:188.96:0.34:0.00
```
Note that these format fields are same as for Strelka2, without BCN50.  Expect filters to work the same for both
