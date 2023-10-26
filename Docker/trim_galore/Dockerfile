#DockerFile
#---------------Install Trim Galore This could be easy the real problem is at the fastQC stage!!!
#curl -fsSL https://github.com/FelixKrueger/TrimGalore/archive/0.6.10.tar.gz -o trim_galore.tar.gz
#tar xvzf trim_galore.tar.gz
#---------------Run Trim Galore
#~/TrimGalore-0.6.10/trim_galore
# ------------------------------------------------------------------------------------------------------------
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
&& cd /usr/local \
&& apt-get install -y wget curl tar unzip bzip2 \
#
&& apt-get install -y build-essential \
&& apt-get install -y python3.8 \
&& apt-get install -y python3-dev \
&& apt-get install -y cutadapt \
#
&& apt-get install -y default-jre \
&& curl https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip -o fastqc_v.0.12.1.zip  \
&& unzip fastqc_v.0.12.1.zip
ENV PATH=$PATH:/usr/local/FastQC
RUN cd /usr/local \
&& curl -fsSL https://github.com/FelixKrueger/TrimGalore/archive/0.6.10.tar.gz -o trim_galore.tar.gz \
&& tar -xvf trim_galore.tar.gz \
&& rm fastqc_v.0.12.1.zip \
&& rm trim_galore.tar.gz \
&& apt-get clean 
ENV PATH=$PATH:/usr/local/TrimGalore-0.6.10