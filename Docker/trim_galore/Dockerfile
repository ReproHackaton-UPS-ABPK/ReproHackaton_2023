#DockerFile
#Using as OS Ubuntu 20.04.6 LTS (Focal Fossa)
#---------------Check that cutadapt is installed DONE
#cutadapt --version
#---------------Check that FastQC is installed NOP, many dependencies are requeried
#fastqc -v
#---------------Install Trim Galore This could be easy the real problem is at the fastQC stage!!!
#curl -fsSL https://github.com/FelixKrueger/TrimGalore/archive/0.6.10.tar.gz -o trim_galore.tar.gz
#tar xvzf trim_galore.tar.gz
#---------------Run Trim Galore
#~/TrimGalore-0.6.10/trim_galore
# ------------------------------------------------------------------------------------------------------------
FROM ubuntu:20.04
RUN apt-get update \
&& cd /usr/local \
&& apt install wget curl tar unzip bzip2 FindBin -y \
&& apt install python3.8 -y \
&& apt install cutadapt -y \
&& apt install default-jre -y \
&& curl https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip -o fastqc_v.0.12.1.zip  \
&& unzip fastqc_v.0.12.1.zip \