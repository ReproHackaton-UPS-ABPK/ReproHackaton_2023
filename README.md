# ReproHackaton_UPS_ABPK

## À propos de ce dépôt :
Ce dépôt est dédié au projet final du cours "ReproHackaton" de l'Université Paris Saclay (Computer Science Grad School) dans le cadre du Master Deegre in Bioinformatics.
Quelques informations sur ce projet et ce cours ici : [Reprohackathons: promoting reproducibility in bioinformatics through training](https://doi.org/10.1093/bioinformatics/btad227).

Nous travaillons sur un cas d'utilisation d'analyse de données RNA-Seq, en reproduisant des parties de l'analyse effectuée par les auteurs et en utilisant des outils de construction de workflows (snakemake), des outils de conteneurisation (Docker et singularity) et des logiciels de contrôle de version (git).

Nous nous interessons dans l'article :  [Intracellular Staphylococcus aureus persisters upon antibiotic exposure](https://doi.org/10.1038/s41467-020-15966-7).

## Comment utiliser ce dépot ?
Pour utiliser ce dépôt, il suffit de le cloner, et à partir d'un terminal, changer le répertoire courant et lancer la commande snakemake, vous pouvez choisir la quantite de cores à utiliser ainsi comme choisir d'autres options de votre préference, n'oubliez pas d'inclure l'utilisation de singularity. Voici nos commandes recommandées pour exécuter le workflow.
```
git clone https://github.com/ReproHackaton-UPS-ABPK/ReproHackaton_2023.git
cd ReproHackaton_2023 <ou le nom que vous avez asiggne au répertoire>
snakemake --cores all --use-singularity
```
Au cours de l'exécution du processus, plusieurs dossiers seront créés pour stocker les fichiers résultant de chaque étape. Les résultats finaux, après l'analyse des données, se trouvent dans le dossier "results".
La liste des résultats attendus est la suivante:
* La matrice de comptage de gènes.
* MA-plot de l'ensemble des données RNA-seq.
* MA-plot des gènes liés à la traduction.
### prérequis:
* Snakemake.
* Singularity (une version de préférence égale ou supérieure à 3.8.7).

## Quels sont les outils utilisés ?

* Pour construir le workflow : **Snakemake - 7.32.4**
* Pour faire les containeurs : **Docker - 24.0.6**
* Pour télécharger et compresser les fichiers .fasta de l'expérience : **sratoolkit - 3.0.7**
* Pour faire le trimming des sequences :
    * **cutadapt -4.6**
    * **fastqc - 0.12.1**
    * **trim_galore - 0.6.10**
* Pour faire le mapping des séquences et l'indexation des annotations du génome de référence : **Bowtie2 - 2.3.5**
* Pour transformer les fichiers .sam, obtenus lors du mapping, en fichiers .bam : **samtools - 1.18**
* Pour le comptage des gènes: **subread - 1.6.2**
* Pour l'analyse statistique:
   * **DESeq2 - #TODO (sur R - 4.3.0)**
   * #TODO

### Outils dockerisés :

Tous les outils mentionnés (sauf Snakemake et Docker) se trouvent dans des conteneurs qui résident dans Docker-Hub, certains d'entre eux ont été développés pour ce projet, d'autres sont des conteneurs disponibles, développés par la communauté.

* Conteneurs développés pour ce projet:
    * sratoolkit : [docker://julagu/sratoolkit_3.0.7](https://hub.docker.com/r/julagu/sratoolkit_3.0.7)
    * cutadapt, fastqc et trim_galore : [docker://julagu/trim_galore_0.6.10](https://hub.docker.com/r/julagu/trim_galore_0.6.10)
    * DESeq2 : [docker://julagu/deseq2_r_4.3.0](https://hub.docker.com/r/julagu/deseq2_r_4.3.0)

* Conteneurs d'autres constructeurs:
    * bowtie2 : [docker://nanozoo/bowtie2](https://hub.docker.com/r/nanozoo/bowtie2)
    * samtools : [docker://staphb/samtools](https://hub.docker.com/r/staphb/samtools)
    * subread : [docker://genomicpariscentre/subread](https://hub.docker.com/r/genomicpariscentre/subread)

##
Liens des diapositives : (Weekly slides)[https://docs.google.com/presentation/d/1fjEN-x6hD_FPFjQ8IcJPGlG5etxT3W5sTkdrif7sDqI/edit?usp=sharing](https://docs.google.com/presentation/d/1Ra-zlHFUtDBsF_gb_fp-qqhgWLaTSuXA/edit#slide=id.p1)

Lien vers la liste des ARN liés à l'expérience : https://www.ncbi.nlm.nih.gov/sra?term=SRP227811
