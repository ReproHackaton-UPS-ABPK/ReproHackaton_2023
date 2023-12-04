# Use an official R runtime as a parent image
FROM r-base:4.3.0
# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev
# Install R packages
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"
RUN R -e "BiocManager::install(version = '3.18')"
RUN R -e "BiocManager::install(c('DESeq2', 'ggplot2', 'dplyr'))"
RUN R -e "install.packages('ggrepel', version = '0.9.4')"
RUN R -e "install.packages('tidyr')"