# DockerFile
# Using as OS Ubuntu 20.04.6 LTS (Focal Fossa)
FROM ubuntu:20.04
# Updating all the dependencies of the OS
RUN apt-get update \
# Installing the commands "wget" and "tar", to use them to download and unpack the sra-toolkit
&& apt-get install -y wget tar \
# Pointing to the /usr/local directory
&& cd /usr/local \
# Downloading and unzip the tool from the permanent direction at ncbi repository, we use the 3.0.7 version, because is the recentest version ( the 3.0.8 version is saved at the "current" link)
&& wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.7/sratoolkit.3.0.7-ubuntu64.tar.gz \
&& tar -vxzf sratoolkit.tar.gz \
# Deleting the .tar.gz file to have a smaller image 
&& rm sratoolkit.tar.gz \
# Cleaning downloaded package files
&& apt-get clean
# Changing the PATH direction to have direct acces to sratoolkit commands (It's mandatory to use ENV to obtain a global change of the PATH direction, using the most common "export" in a Dockerfile we obtain only a temporary change)
ENV PATH=$PATH:/usr/local/sratoolkit.3.0.7-ubuntu64/bin
