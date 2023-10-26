#Creation of the docker images from the Dockerfiles 
docker build --tag sratoolkit_3.0.7 ~/ReproHackaton_2023/Docker/sratoolkit
docker build --tag trim_galore_0.6.10 ~/ReproHackaton_2023/Docker/trim_galore
# Creation of the .sif images (if neccesary)
singularity build ~/ReproHackaton_2023/Docker/sratoolkit/sratoolkit_3.0.7.sif docker-daemon://sratoolkit_3.0.7:latest
singularity build ~/ReproHackaton_2023/Docker/sratoolkit/trim_galore_0.6.10.sif docker-daemon://trim_galore_0.6.10:latest