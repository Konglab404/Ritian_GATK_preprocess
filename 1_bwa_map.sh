#!/bin/bash
#PBS -o ~/data/cmds/pbs_out/test22_bwamap.o 
#PBS -e ~/data/cmds/pbs_out/test22_bwamap.e 
#PBS -N test22_bwamap 
#PBS -q workq  
#PBS -l mem=250gb,walltime=15:00:00 
#PBS -l nodes=1:ppn=40 
 
bwa mem -t 40 -R '@RG\tID:test22\tPL:ILLUMINA\tSM:test22' \
    ~/data/BasicResource/Ref/Homo_sapiens_assembly38_gatk.fasta \
    ~/data/Data/$filename_R1.fq.gz \
    ~/data/Data/$filename_R2.fq.gz | samtools view -Sb - > ~/data/Data/0_bwa_bam/$filename.unsorted.bam #the file to output
    
#I add the PBS header to help the estimate of resource-consuming 
# $filename should be change by yourself. For example, my fq files' names are GL11_R1.fq.gz/GL11_R2.fq.gz
