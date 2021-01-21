#!/bin/bash
#pipeline for getting 4fold degenerate sites
#from gff and fasta, using python, awk, and bedtools
#Tyler Kent
#14 March 2017

###################################
# SET UP PATHS
#
# This is the only portion of the
# pipeline that needs to be
# adjusted. Assume gff is gzipped.
###################################

gff='/scratch/research/references/trifolium/repens/GCA_005869975.1_AgR_To_v5/annotation_file/TrR.v5.renamed_reformated.gtf.gz'
# gff='/scratch/research/references/trifolium/repens/GCA_005869975.1_AgR_To_v5/0fold_test/Oryza_sativa.IRGSP-1.0.49.chr.gff3.gz'
fasta='/scratch/research/references/trifolium/repens/GCA_005869975.1_AgR_To_v5/GCA_005869975.1_AgR_To_v5_genomic.fna'
# fasta='/scratch/research/references/trifolium/repens/GCA_005869975.1_AgR_To_v5/0fold_test/Oryza_sativa.IRGSP-1.0.dna.toplevel.fa'
# CDSbedout='/scratch/research/references/trifolium/repens/GCA_005869975.1_AgR_To_v5/0fold_test/Os_CDS.bed'
CDSbedout='/scratch/research/references/trifolium/repens/GCA_005869975.1_AgR_To_v5/0fold_4fold/Os_CDS.bed'
fastaCDSout='/scratch/research/references/trifolium/repens/GCA_005869975.1_AgR_To_v5/0fold_4fold/Os_CDS.tab'
# fastaCDSout='/scratch/research/references/trifolium/repens/GCA_005869975.1_AgR_To_v5/0fold_test/Os_CDS.tab'
fourfoldbedout='/scratch/research/references/trifolium/repens/GCA_005869975.1_AgR_To_v5/0fold_4fold/Trepens'
# fourfoldbedout='/scratch/research/references/trifolium/repens/GCA_005869975.1_AgR_To_v5/0fold_test/sites.4fold'

###################################
# STEP 1: GET BED FILE OF CDS AND
# SHIFT TO MATCH PHASE
#
# CDS sequence in GFF format
# contains sections of translated
# sequence, with phase info, which
# indicates the start of the first
# codon.:w

###################################

# bash gff2bed.sh <(zcat ${gff}) CDS | awk -f gffphaseshift.awk - > ${CDSbedout} 

###################################
# STEP 2: USE BED FILE AND FASTA
# TO GET FILE OF POS AND SEQUENCE
#
# Use bedtools to get relevant 
# fasta sequence into useable
# format.
###################################

# bedtools getfasta -s -tab -name -fi ${fasta} -bed ${CDSbedout} > ${fastaCDSout} 

###################################
# STEP 3: KEEP ONLY LONGEST 
# ISOFORM
#
# Drop all alternate isoforms but
# the longest.
###################################

# DEPRECATED--DONT DO THIS STEP
###python keep_longest_isoform.py -i ${fastaCDSout} -o ${longestonly}

###################################
# STEP 4: CONVERT FASTA DNA
# SEQUENCE INTO CODONS, FLIP FOR
# PHASE, AND REPORT 4FOLD SITES
#
# Using python and a codon table
###################################

python degeneracy.py -i ${fastaCDSout} -o ${fourfoldbedout}

###################################
# STEP 5: SORT OUTPUT
#
# Just need to sort the python 
# output like you would a normal
# bed file, and drop mistake dups.
###################################

# DEPRECATED--DONT DO THIS STEP
#cat ${fourfoldbedout}.bed | sort -k1,1 -k2,2n | uniq > ${fourfoldbedout}.sorted.bed
