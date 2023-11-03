library(DESeq2)
library(dplyr)
library(ggplot2)

paths <- c(snakemake@input[[1]],
snakemake@input[[2]],
snakemake@input[[3]],
snakemake@input[[4]],
snakemake@input[[5]],
snakemake@input[[6]])

ensembleCounts = c()
for(i in 1:6){
  path = paths[i]
  ensembleCounts[[i]] <- read.table(path, header = T, skip = 1, sep = '\t')
}

tableCounts <- data.frame(sample1 = ensembleCounts[[1]]$mapped.sort_SRR10379721.bam,
                          sample2 = ensembleCounts[[2]]$mapped.sort_SRR10379722.bam, sample3 = ensembleCounts[[3]]$mapped.sort_SRR10379723.bam,
                          sample4 = ensembleCounts[[4]]$mapped.sort_SRR10379724.bam, sample5 = ensembleCounts[[5]]$mapped.sort_SRR10379725.bam,
                          sample6 = ensembleCounts[[6]]$mapped.sort_SRR10379726.bam)
rownames(tableCounts) <- ensembleCounts[[1]]$Geneid

samples_column <- c(colnames(tableCounts))
type_column <- c ("persister","persister","persister","control","control","control")
type_tab <- data.frame(Type = type_column)
rownames(type_tab) <- samples_column

dds <- DESeqDataSetFromMatrix(countData = tableCounts,
                              colData = type_tab,
                              design = ~ Type)

dds$Type <- relevel(dds$Type, ref = "control")

dds_post <- DESeq(dds)
res <- results(dds_post, alpha = 0.05)


###################################################################################################



diff.df = as.data.frame(results(dds_post))
diff.df$Gene_Name = gsub("gene-","",rownames(diff.df))
diff.df$Is_Translation = "No"
vecteur_translation = read.table(snakemake@input[[7]], sep = "\t", header = F)
vecteur_translation$V1 = gsub("\\s*","",vecteur_translation$V1)
diff.df$Is_Translation[diff.df$Gene_Name %in% vecteur_translation$V1] = "Yes"
vecteur_circled = vecteur_translation$V1[72:156]

#To plot only translation
dev.size()
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
ggsave(snakemake@output[[1]])
dev.off()

#To plot everything
dev.size()
diff.df %>% ggplot(aes(x = baseMean, y = log2FoldChange, col = padj < 0.1)) + 
  geom_point() + 
  theme_classic() +
  scale_color_manual(values = c("grey50", "red")) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  ggtitle("MA-plot of complete RNA-seq dataset") +
  xlab("Mean of normalized counts")
ggsave(snakemake@output[[2]])
dev.off()

#heatmap_plot
res.df <- as.data.frame(res)
mat<- counts(dds_post,normalized = TRUE)
mat.z<-t(apply(mat,1,scale))
colnames(mat.z)<-rownames(type_tab)


#heatmap(mat.z, cluster_rows = T, cluster_columns = T, column_labels = colnames(mat.z), name ='Z-score', cexCol=1)
#dev.copy2pdf(file="results/heatmap.pdf")