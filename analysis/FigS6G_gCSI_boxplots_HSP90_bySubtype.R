data <- read.table("../data/CellLineDrugResponse_SubtypeAssociation.tsv", sep="\t", header=TRUE, check.names=FALSE)
gCSI <- read.table("../data/CellLineDrugResponse_MeanViability.tsv", sep="\t", header=TRUE, check.names=FALSE)
gCSI <- gCSI[!gCSI$Subtype %in% "unclassified", ]
gCSI <- gCSI[gCSI$KRAS, ] # Subset of KRAS-mutant lines

# Associate HSP90i response with subtype
target <- c("HSP90")
compounds <- as.character(data$`gCGC ID`[which(data$TARGET_NAME %in% target)])
targetsID <- as.character(data$TARGET_NAME[which(data$TARGET_NAME %in% target)])
data.gCSI <- gCSI[, compounds]
rownames(data.gCSI) <- gCSI[, "Cell line"]
colnames(data.gCSI) <- paste0(compounds, " (", targetsID, ")")
nbTumors <- nrow(data.gCSI)

subtypes <- factor(gCSI$Subtype, levels=c("MUC", "PRO", "MES"))
colors <- rep("cyan3", nbTumors)
colors[subtypes %in% "PRO"] <- "mediumpurple2"
colors[subtypes %in% "MES"] <- "green3"
pchs <- rep(19, nbTumors)
pchs[!gCSI$KRAS] <- 17

i <- "gCGC00506 (HSP90)"
pdf("../figures/FigS6_CellLinesMut_17DMAGVsSubtype.pdf", width=5.5, height=6.5)
par(mar=c(4.5,4.5,3,1))
pval <- signif(kruskal.test(data.gCSI[,i] ~ subtypes)$p.value,2)
boxplot(data.gCSI[,i] ~ subtypes, ylab="Mean viability, 17-DMAG", xlab="Subtype",
			main=paste0("Cell lines - KRAS mutant (n=",nbTumors,")"),
			cex.lab=1.8, cex.axis=1.5, cex.main=1.8, outline=FALSE,
			ylim=range(data.gCSI[,i], na.rm=TRUE))
points(jitter(as.numeric(subtypes)), data.gCSI[,i], col=colors, pch=pchs, cex=1.5)
text(x=1, y=max(data.gCSI[,i], na.rm=TRUE), labels=paste0("p=",pval), cex=1.5)
dev.off()
