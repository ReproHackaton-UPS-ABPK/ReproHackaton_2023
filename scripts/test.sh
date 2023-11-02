#--------- TELECHARGEMENT DES SÉQUENCES RNA EN FORMAT FASTQ --------------
#fasterq-dump SRR10379721
#fasterq-dump SRR10379722
#fasterq-dump SRR10379723
#fasterq-dump SRR10379724
#fasterq-dump SRR10379725
#fasterq-dump SRR10379726

#---------- TELECHARGEMENT DE LA SÉQUENCE DE REFERENCE + ANNOTATION ---------------------
#gzip *.fastq 
#wget -q -O ~/ReproHackaton_2023/ressources/genomes/reference.fasta "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP000253.1&rettype=fasta"
#wget -O ~/ReproHackaton_2023/ressources/genomes/reference.gff "https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?db=nuccore&report=gff3&id=CP000253.1"

#---------- CRÉATION DE L'INDEX ---------------------
#bowtie2-build reference.fasta aureusIndex

#---------- TRIMMING : suppression des gènes indésirables ---------------------
#trim_galore -q 20 --phred33 --length 25 SRR10379726.fastq.gz

#---------- MAPPING ---------------------
#bowtie2 -x aureusIndex -U SRR10379726_trimmed.fq.gz -S SRR10379726_mapped.sam

#---------- CONVERSION DU SAM EN BAM et CRÉATION DE L'INDEX DU BAM ---------------------
#samtools view -bS -o output.bam SRR10379726_test.sam
#samtools sort -O bam -o sorted_output.bam output.bam
#samtools index sorted_output.bam

#---------- CONVERSION DES ANNOTATIONS GFF EN GTF ---------------------
#gffread reference.gff -T -o reference.gtf

#---------- COUNTING (SUBREAD) ---------------------
#featureCounts -p -O -a reference.gtf -o output_count.txt sorted_output.bam

