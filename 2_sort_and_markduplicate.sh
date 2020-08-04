#!/bin/bash
#PBS -o ~/data/cmds/pbs_out/sort_mdp.o 
#PBS -e ~/data/cmds/pbs_out/sort_mdp.e 
#PBS -N sort_mdp
#PBS -q workq  
#PBS -l mem=250gb,walltime=15:00:00 
#PBS -l nodes=1:ppn=40 

samtools sort -@ 40 -m 4G -n -O bam -T test.tmp -o ~/data/Data/0_bwa_bam/$filename.sortedN.bam \ #In samtools, sort by names is required before fixmate
    ~/data/Data/0_bwa_bam/$filename.unsorted.bam 

samtools fixmate -m -@ 40 ~/data/Data/0_bwa_bam/$filename.sortedN.bam ~/data/Data/0_bwa_bam/$filename.fixmate.bam
samtools sort -@ 40 -m 6G -o ~/data/Data/0_bwa_bam/$filename.sorted.bam ~/data/Data/0_bwa_bam/$filename.fixmate.bam  
samtools markdup -s -@ 40 ~/data/Data/0_bwa_bam/$filename.sorted.bam ~/data/Data/0_bwa_bam/$filename.dedup.bam  
samtools index -@ 40 ~/data/Data/0_bwa_bam/$filename.dedup.bam
