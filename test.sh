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
#bowtie2 -x aureusIndex -U SRR10379726_trimmed.fq.gz -S SRR10379726_test.sam

#---------- COUNTING (SUBREAD) ---------------------
#featureCounts -p -O -T n -a <example_genome_annotation.gtf> -o fichier_output.txt <sorted_example_alignment.bam>
