#!/bin/bash 
#PBS -o ~/data/cmds/pbs_out/sample275.preprocess.o
#PBS -e ~/data/cmds/pbs_out/sample275.preprocess.e
#PBS -N sample275.pre
#PBS -q workq  
#PBS -l mem=250gb,walltime=25:00:00
#PBS -l nodes=1:ppn=40

sample='sample275'

bwa mem -t 40 -R '@RG\tID:nowsample\tPL:ILLUMINA\tSM:nowsample' \
    ~/data/BasicResource/Ref/Homo_sapiens_assembly38_gatk.fasta \
    ~/data/Data/fqs/${sample}_R1.fq.gz \
    ~/data/Data/fqs/${sample}_R1.fq.gz | samtools view -Sb - > ~/data/Data/0_bwa_bam/${sample}.unsorted.bam
	
samtools sort -@ 40 -m 4G -n -O bam -T ${sample}.tmp -o ~/data/Data/0_bwa_bam/${sample}.sortedN.bam \
    ~/data/Data/0_bwa_bam/${sample}.unsorted.bam

samtools fixmate -m -@ 40 ~/data/Data/0_bwa_bam/${sample}.sortedN.bam ~/data/Data/0_bwa_bam/${sample}.fixmate.bam
samtools sort -@ 40 -m 6G -o ~/data/Data/0_bwa_bam/${sample}.sorted.bam ~/data/Data/0_bwa_bam/${sample}.fixmate.bam  
samtools markdup -s -@ 40 ~/data/Data/0_bwa_bam/${sample}.sorted.bam ~/data/Data/0_bwa_bam/${sample}.dedup.bam  
samtools index -@ 40 ~/data/Data/0_bwa_bam/${sample}.dedup.bam

for i in `seq -f '%04g' 0 19` 
do
    outfile=~/data/Data/0_bwa_bam/${sample}_dedup_recal_data_$i.table  
    gatk BaseRecalibrator -L ~/data/BasicResource/GATK_bundle/hg38_scatter_interval_files/$i-scattered.interval_list -R ~/data/BasicResource/Ref/Homo_sapiens_assembly38_gatk.fasta -I ~/data/Data/0_bwa_bam/${sample}.dedup.bam --known-sites ~/data/BasicResource/GATK_bundle/Homo_sapiens_assembly38.dbsnp138.vcf --known-sites ~/data/BasicResource/GATK_bundle/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz -O $outfile &
done
wait

for i in `seq -f '%04g' 0 19`
do
    bqfile=~/data/Data/0_bwa_bam/${sample}_dedup_recal_data_$i.table
    output=~/data/Data/0_bwa_bam/${sample}_dedup_recal_$i.bam
    gatk ApplyBQSR -R ~/data/BasicResource/Ref/Homo_sapiens_assembly38_gatk.fasta -I ~/data/Data/0_bwa_bam/${sample}.dedup.bam -L ~/data/BasicResource/GATK_bundle/hg38_scatter_interval_files/$i-scattered.interval_list  -bqsr $bqfile --static-quantized-quals 10 --static-quantized-quals 20 --static-quantized-quals 30 -O $output &
done
wait

gatk GatherBamFiles -O ~/data/Data/0_bwa_bam/${sample}_dedup.BQSR.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0000.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0001.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0002.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0003.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0004.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0005.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0006.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0007.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0008.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0009.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0010.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0011.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0012.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0013.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0014.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0015.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0016.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0017.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0018.bam \
    -I ~/data/Data/0_bwa_bam/${sample}_dedup_recal_0019.bam
	
samtools sort -@ 40 -m 6G -o ~/data/Data/0_bwa_bam/${sample}.dedup.BQSR.sorted.bam ~/data/Data/0_bwa_bam/${sample}_dedup.BQSR.bam
samtools index -@ 40 ~/data/Data/0_bwa_bam/${sample}.dedup.BQSR.sorted.bam
