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

tableCounts <- data.frame(IP1 = ensembleCounts[[1]]$mapped.sort_SRR10379721.bam,
                          IP2 = ensembleCounts[[2]]$mapped.sort_SRR10379722.bam, 
                          IP3 = ensembleCounts[[3]]$mapped.sort_SRR10379723.bam,
                          control4 = ensembleCounts[[4]]$mapped.sort_SRR10379724.bam, 
                          control5 = ensembleCounts[[5]]$mapped.sort_SRR10379725.bam,
                          control6 = ensembleCounts[[6]]$mapped.sort_SRR10379726.bam)
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


genes_interet <- data.frame(sigla = c('frr', 'infA', 'tsf', 'infC', 'infB', 'pth'),
                            id = c('SAOUHSC_01236', 'SAOUHSC_02489', 'SAOUHSC_01234',
                                   'SAOUHSC_01786', 'SAOUHSC_01246', 'SAOUHSC_00475'))


###################################################################################################


diff.df = as.data.frame(results(dds_post))
diff.df$Gene_Name = gsub("gene-","",rownames(diff.df))
diff.df$Is_Translation = "No"
vecteur_translation = read.table(snakemake@input[[7]], sep = "\t", header = F)
vecteur_translation$V1 = gsub("\\s*","",vecteur_translation$V1)
diff.df$Is_Translation[diff.df$Gene_Name %in% vecteur_translation$V1] = "Yes"
vecteur_circled = vecteur_translation$V1[72:156]

#Extracting transformed values
counts_matrix <- assay(dds)
counts_matrix <- cbind(counts_matrix, diff.df[,1:6])
write.csv(counts_matrix, file=snakemake@output[[3]])

plotma = plotMA(res,colSig = "red",colNonSig = "gray50", returnData = TRUE)

diff.df <- na.omit(diff.df)

diff.df$sigla = 'a'
for(i in 1:nrow(diff.df)){
  ligne = diff.df[i,]
  gene_name = ligne[,'Gene_Name']
  if(gene_name %in% genes_interet$id){
    diff.df[diff.df$Gene_Name == gene_name, 'sigla'] = genes_interet[genes_interet$id == gene_name, 'sigla']
  }
}

#To plot only translation
dev.size()
diff.df %>% 
  filter(Is_Translation == "Yes") %>%
  ggplot(aes(x = log2(baseMean), y = log2FoldChange,colour = padj < 0.1)) + 
  geom_point() +
  geom_point(data = diff.df %>% filter(Gene_Name %in% vecteur_circled), 
             pch = 21, 
             colour = "black",
             size = 2) +
  theme_classic() +
  theme(legend.position = c(.15, .1)) +
  labs(colour = NULL) +
  scale_color_manual(labels = c("Non Significant", "Significant"), values = c("grey50", "red")) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  ggtitle("MA-plot of genes related to translation") +
  xlab("Log2 base Mean") +
  ggrepel::geom_text_repel(data = subset(diff.df, diff.df$sigla != 'a'),
                           aes(label = sigla),
                           size = 5,
                           box.padding = 2,
                           point.padding = 0.1,
                           max.overlaps = Inf,
                           min.segment.length = 0,
                           segment.color = 'black',
                           colour = "black")
ggsave(snakemake@output[[1]])
dev.off()

dev.size()
  ggplot(plotma, aes(x = mean, y = lfc, col = isDE)) +
  geom_point(size=0.9) +
  theme_classic() +
  theme(legend.position = c(.15, .9)) +
  labs(colour = NULL) +
  scale_color_manual(labels = c("Non Significant", "Significant"), values = c("grey50", "red")) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  ggtitle("MA-plot of complete RNA-seq dataset") +
  ylab("Log fold change") + 
  xlab("Mean of normalized counts")+
  scale_x_log10()
ggsave(snakemake@output[[2]])
dev.off()