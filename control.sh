#Creation of the docker images from the Dockerfiles 

# Creation of the .sif images (if neccesary)
singularity build ~/ReproHackaton_2023/Docker/sratoolkit/sratoolkit_3.0.7.sif docker-daemon://sratoolkit_3.0.7:latest
singularity build ~/ReproHackaton_2023/Docker/sratoolkit/sratoolkit_3.0.7.sif docker-daemon://sratoolkit_3.0.7:latest