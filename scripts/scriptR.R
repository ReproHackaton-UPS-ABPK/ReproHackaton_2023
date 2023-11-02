library(S4Vectors)
library(stats4)
library(BiocGenerics)
library(DESeq2)
library(ggplot2)
install.packages("dplyr") # A ajouter au container 
library(dplyr)

#Reading count data
samples = read.table("/Users/nada/Desktop/dossier_repro/output_count.txt", sep = "\t", header = T, skip = 1)
#in this file I don't have the condition column 
#format problem
gene_counts <- samples [,c("Geneid","sorted_output.bam")]
head('gene_counts')
names(gene_counts)[names(gene_counts)=="sorted_output.bam"]<- "Sample1 "
gene_counts$Sample2 <- sample(0:1000, 77, replace = TRUE)
gene_counts$Sample3 <- sample(0:1000, 77, replace = TRUE)
gene_counts$Sample4 <- sample(0:1000, 77, replace = TRUE)
gene_counts$Sample5 <- sample(0:1000, 77, replace = TRUE)
gene_counts$Sample6 <- sample(0:1000, 77, replace = TRUE)

samples_column <- c ("Sample1","Sample2","Sample3","Sample4","Sample5","Sample6")
type_column <- c ("persister","persister","persister","control","control","control")
type_tab <- data.frame(Samples = samples_column, Type = type_column)

write.table(type_tab, "type_tab.txt", sep = "\t")
rownames(gene_counts) <- gene_counts$Geneid
gene_counts$Geneid <- NULL
rownames(type_tab) <- type_tab$Samples
type_tab$Samples <- NULL
rownames(type_tab) <- colnames(gene_counts)
type_tab$Type <- as.factor (type_tab$Type)
#making sure the row names in colData matches to column names in counts_data
all(row.names(type_tab) %in% colnames(gene_counts))

#are they in the same order ?
all(colnames(gene_counts)==rownames(type_tab))

#STEP 2 : construct a DESqDataSet object
dds <- DESeqDataSetFromMatrix(countData = gene_counts ,
                              colData = type_tab,
                              design = ~Type)
dds

#pre filtering : removing rows with low gene counts
#keeping rows that have at least 10 reads total
keep <-rowSums(counts(dds))>=10
dds <-dds [keep,]
dds 

#set the factor level
dds$Type <- as.factor(dds$Type)
dds$Type <- relevel(dds$Type, ref="control")

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

#Preliminary operations for plot creation
diff.df = as.data.frame(results(dds))
diff.df$Gene_Name = gsub("gene-","",rownames(diff.df))
diff.df$Is_Translation = "No"
vecteur_translation = read.table("/Users/nada/Desktop/dossier_repro/translation.txt", sep = "\t", header = F)
vecteur_translation$V1 = gsub("\\s*","",vecteur_translation$V1)
diff.df$Is_Translation[diff.df$Gene_Name %in% vecteur_translation$V1] = "Yes"
vecteur_circled = vecteur_translation$V1[72:156]

#To plot only translation 
diff.df %>% 
  filter(Is_Translation == "Yes") %>%
  ggplot(aes(x = log2(baseMean), y = log2FoldChange,col = padj < 0.1)) + 
  geom_point() + 
  geom_point(data = diff.df %>% filter(Gene_Name %in% vecteur_circled), 
             pch = 21, 
             colour = "black", 
             size = 2) +
  theme_classic() +
  scale_color_manual(values = c("grey50", "red")) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  ggtitle("MA-plot of genes related to translation") +
  xlab("Log2 base Mean") +
  ggrepel::geom_text_repel(data = filter(diff.df, log2FoldChange > 2),aes(label = Gene_Name))

#To plot everything
diff.df %>% ggplot(aes(x = baseMean, y = log2FoldChange, col = padj < 0.1)) + 
  geom_point() + 
  theme_classic() +
  scale_color_manual(values = c("grey50", "red")) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  ggtitle("MA-plot of complete RNA-seq dataset") +
  xlab("Mean of normalized counts")

#heatmap_plot
res.df <- as.data.frame(res)
res.df                       
mat<- counts(dds,normalized = TRUE)
mat
mat.z<-t(apply(mat,1,scale))
colnames(mat.z)<-rownames(type_tab)
mat.z
heatmap(mat.z, cluster_rows = T, cluster_columns = T, column_labels = colnames(mat.z), name ='Z-score')

