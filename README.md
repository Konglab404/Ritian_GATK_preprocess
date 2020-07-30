这些脚本里面默认的是下机文件未经merge，也就是说公司返回的时候已经是\*\_1.fq.gz和\*\_2.fq.gz了，不是各条lane各有fq文件。    
我这里资源消耗是基于～30x的人重测序

Assume that the fq files are just obtained by _ONE_ lane. The procedure for fq files from multiple lanes can be found in Broad's GATK best practise. My test file was 30x human genomic re-sequencing.


这里面用了Scatter-gather的方法进行BQSR，当把#scatter数目设成20的时候，可以在半个小时时间里做完bqsr，再花20分钟gather、sort和index，加起来只用50分钟。不设置scatter的话BQSR需要大概10小时,这种操作也只能是在线程数和内存足够的情况下才能用，如果实验室的服务器比较紧张，那也别scattergather了，不然容易引发内部矛盾。    

Scatter-gather method can reduce the BQSR time from ~10h to ~50min.

