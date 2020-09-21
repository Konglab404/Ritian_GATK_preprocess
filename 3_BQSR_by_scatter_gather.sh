#!/bin/bash

for i in `seq -f '%04g' 0 19`
do
    outfile=/home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_data_$i.table
    gatk BaseRecalibrator -L /home/wanght/refNome/BasicResource/GATK_bundle/hg38_scatter_interval_files/$i-scattered.interval_list -R /home/wanght/refNome/BasicResource/Ref/Homo_sapiens_assembly38_gatk.fasta -I /home/wanght/Data/WGS/0_bwa_bam/${sample}.dedup.bam --known-sites /home/wanght/refNome/BasicResource/GATK_bundle/Homo_sapiens_assembly38.dbsnp138.vcf --known-sites /home/wanght/refNome/BasicResource/GATK_bundle/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz -O $outfile &
done
wait



for i in `seq -f '%04g' 0 19`
do
    bqfile=/home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_data_$i.table
    output=/home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_$i.bam
    gatk ApplyBQSR -R /home/wanght/refNome/BasicResource/Ref/Homo_sapiens_assembly38_gatk.fasta -I /home/wanght/Data/WGS/0_bwa_bam/${sample}.dedup.bam -L /home/wanght/refNome/BasicResource/GATK_bundle/hg38_scatter_interval_files/$i-scattered.interval_list  -bqsr $bqfile --static-quantized-quals 10 --static-quantized-quals 20 --static-quantized-quals 30 -O $output &
done
wait

rm /home/wanght/Data/WGS/0_bwa_bam/${sample}.dedup.bam
rm /home/wanght/Data/WGS/0_bwa_bam/${sample}.dedup.bam.bai
gatk GatherBamFiles -O /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup.BQSR.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0000.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0001.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0002.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0003.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0004.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0005.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0006.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0007.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0008.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0009.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0010.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0011.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0012.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0013.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0014.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0015.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0016.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0017.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0018.bam \
    -I /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup_recal_0019.bam

rm /home/wanght/Data/WGS/0_bwa_bam/${sample}*recal*
samtools sort -@ 20 -m 6G -o /home/wanght/Data/WGS/0_bwa_bam/${sample}.dedup.BQSR.sorted.bam /home/wanght/Data/WGS/0_bwa_bam/${sample}_dedup.BQSR.bam

rm /home/wanght/Data/WGS/0_bwa_bam/${sample}*.BQSR.bam

samtools index -@ 20 /home/wanght/Data/WGS/0_bwa_bam/${sample}.dedup.BQSR.sorted.bam
