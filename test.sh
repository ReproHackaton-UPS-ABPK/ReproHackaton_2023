#fasterq-dump --threads 4 --progress GSM4145666
#gzip *.fastq
#wget -q -O ~/ReproHackaton_2023/ressources/genomes/reference.fasta "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP000253.1&rettype=fasta"
#wget -O ~/ReproHackaton_2023/ressources/genomes/reference.gff "https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?db=nuccore&report=gff3&id=CP000253.1"
#trim_galore -q 20 --phred33 --length 25 <FASTQ FILE>
