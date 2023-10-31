library(S4Vectors)
library(stats4)
library(BiocGenerics)
library(DESeq2)

# lecture des donnees de comptage
samples = read.table("C:/Users/HP/Downloads/output_count.txt", sep = "\t", header = T, skip = 1)
#dans ce fichier je n'ai pas la colonne de condition 
#problème de format
gene_counts <- samples [,c("Geneid","X.Users.nada.ReproHackaton_2023.output.bam")]
head('gene_counts')
names(gene_counts)[names(gene_counts)=="X.Users.nada.ReproHackaton_2023.output.bam"]<- "Sample1 "
gene_counts$Sample2 <- sample(0:1000, 77, replace = TRUE)
gene_counts$Sample3 <- sample(0:1000, 77, replace = TRUE)
gene_counts$Sample4 <- sample(0:1000, 77, replace = TRUE)
samples_tab <- c ("Sample1","Sample2","Sample3","Sample4")
treatment_tab <- c ("Treated","Treated","Treated","untreated")

Sampless <- data.frame(Samples = samples_tab, Treatment = treatment_tab)
write.table(Sampless, "Sampless.txt", sep = "\t")
rownames(gene_counts) <- gene_counts$Geneid
gene_counts$Geneid <- NULL
rownames(Sampless) <- Sampless$Samples
Sampless$Samples <- NULL
rownames(Sampless) <- colnames(gene_counts)
Sampless$Treatment <- as.factor (Sampless$Treatment)
#making sure the row names in colData matches to column names in counts_data
all(row.names(Sampless) %in% colnames(gene_counts))

#are they in the same order ?
all(colnames(gene_counts)==rownames(Sampless))

#STEP 2 : construct a DESqDataSet object
dds <- DESeqDataSetFromMatrix(countData = gene_counts ,
                              colData = Sampless,
                              design = ~Treatment)
dds

#pre filtering : removing rows with low gene counts
#keeping rows that have at least 10 reads total
keep <-rowSums(counts(dds))>=10
dds <-dds [keep,]
dds 

#set the factor level
dds$Treatment <- relevel(dds$Treatment, ref="untreated")

#NOTE : collapse technical replicates
#STEP 3 : Run DESq : estimating size factors, estimating dispersions,
#gene-wise dispersion estimates, mean-dispersion relationship, final dispersion estimates, fitting model and testing
dds <- DESeq(dds)
res <- results(dds)
res

#explore Results
summary(res)
res0.01 <- results(dds, alpha =0.01)
summary(res0.01)
resultsNames(dds)


#MA_plot
plotMA(res)


#heatmap_plot
res.df <- as.data.frame(res)
res.df                       
mat<- counts(dds,normalized = TRUE)
mat
mat.z<-t(apply(mat,1,scale))
colnames(mat.z)<-rownames(Sampless)
mat.z
heatmap(mat.z, cluster_rows = T, cluster_columns = T, column_labels = colnames(mat.z), name ='Z-score')

