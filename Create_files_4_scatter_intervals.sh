#Create the files for scatter/gather in BQSR and Mutect2 calling.
#

GATK4 ScatterIntervalsByNs -R ~/data/BasicResource/Ref/Homo_sapiens_assembly38.fasta \ #Reference file; with .dict
    -O ~/data/BasicResource/GATK_bundle/Scatter_files/Homo_sapiens_assembly38_gatk.SIBN.interval_list 
    
GATK4 SplitIntervals \
    -R ~/data/BasicResource/Ref/Homo_sapiens_assembly38.fasta \
    -L ~/data/BasicResource/GATK_bundle/Scatter_files/Homo_sapiens_assembly38_gatk.SIBN.interval_list \
    --scatter-count 20 \ #The number to split. set as 20 in these scripts
    -O ~/data/BasicResource/GATK_bundle/hg38_scatter_interval_files/
