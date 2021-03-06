library(Biobase)
library(Rtsne)

load("../data/TCGAwt_RNAseq_ClassifierGenes.RData")
data <- t(log2(exprs(eset)+1))
colors <- rep("cyan3", ncol(eset))
colors[eset$Subtype %in% "PRO"] <- "mediumpurple2"
colors[eset$Subtype %in% "MES"] <- "green3"
colors[eset$Subtype %in% "unclassified"] <- "grey"

pca <- prcomp(data, scale. = TRUE)

pdf("../figures/FigS1_TCGAwt_SubtypePCA.pdf", width = 5.5, height = 6.5)
par(mar=c(4.5, 4.5, 3, 1))
plot(pca$x[,1], pca$x[,2], xlab="PC1", ylab="PC2", 
		main = paste0("TCGA - KRAS wildtype (n=", ncol(eset), ")"),
		pch = 17, col = colors, 
		cex.main = 1.8, cex.lab = 1.8, cex.axis = 1.5, cex = 1.5)
dev.off()

tsne <- Rtsne(data, dims=2, initial_dims=10, perplexity=30, theta = 0.2,
						pca_center = TRUE, pca_scale = TRUE,
						check_duplicates = FALSE, verbose=TRUE, max_iter=2000)

pdf("../figures/FigS1_TCGAwt_SubtypetSNE 10.pdf", width = 5.5, height = 6.5)
par(mar=c(4.5, 4.5, 3, 1))
plot(tsne$Y, xlab="tSNE 1", ylab="tSNE 2", 
		main = paste0("TCGA - KRAS wildtype (n=", ncol(eset), ")"),
		pch = 17, col = colors, 
		cex.main = 1.8, cex.lab = 1.8, cex.axis = 1.5, cex = 1.5)
dev.off()
