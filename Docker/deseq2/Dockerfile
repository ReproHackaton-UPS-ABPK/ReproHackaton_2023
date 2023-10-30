#install.packages("BiocManager")
#BiocManager::install("DESeq2")
# Using as OS Ubuntu 20.04.6 LTS (Focal Fossa)
FROM r-base:4.3.0
ENV DEBIAN_FRONTEND noninteractive
# Updating all the dependencies of the OS and R
RUN R -e "install.packages('BiocManager'); BiocManager::install('DESeq2');"