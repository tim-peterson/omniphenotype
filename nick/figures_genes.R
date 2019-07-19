library(ggplot2)

go_genes<-read.csv("go_gene.tsv", header=FALSE, sep="\t")
go_terms<-unique(go_genes[,2])

rsq = c()

#FIGURE 3A

#To graph any of the million divisions from 1,000,000 to 30,000,000
for (i in 1:30){
  header_interactions<-read.csv(paste0("~/header_intersection_limited_homolog_filtered",i,"000000.tsv"), sep="\t")
  header_interactions<-header_interactions[-which(header_interactions[,1] <= 0),]
  header_interactions<-header_interactions[-which(header_interactions[,2] <= 0),]
  go_lines<-header_interactions[which(rownames(header_interactions) %in% genes_in_go),]
  cancer_vs_other<-go_lines
  png(paste0("~/Gene Graphs/header_intersection_genes_",i,"000000.png"))
  p2 <- ggplot(cancer_vs_other, aes(x = `Neoplasms`, y = `Non.Cancer`)) + geom_point(color = "#153049", size=1) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_rect(fill = '#e8e7ea', colour = '#a7a9ac', size=1)) 
  print(p2)
  dev.off()
  rsq<-append(rsq, round(summary(lm(log10(go_lines[,1]) ~ log10(go_lines[,2])))$r.squared,3))
}

#FIGURE 3B

go_correlation<-matrix(nrow=0, ncol=3)
go_genes<-read.csv("go_gene.tsv", header=FALSE, sep="\t")
go_terms<-unique(go_genes[,2])
for (i in go_terms){
  go_lines<-header_interactions[which(rownames(header_interactions) %in% go_genes[which(go_genes[,2] == i),1]),]
  if (dim(go_lines)[1] > 3){
    go_correlation<-rbind(go_correlation, c(i, round(summary(lm(log10(go_lines[,1]) ~ log10(go_lines[,2])))$r.squared,3), dim(go_lines)[1]))
  }
}
heat_cor<-matrix(nrow=0, ncol=2)
colors<-c()

immune<-as.character(read.csv("~/immune system process.tsv", header=FALSE)[,1])
immune_cor<-as.numeric(go_correlation[which(go_correlation[,1] %in% immune),2])
heat_cor<-rbind(heat_cor, cbind(immune_cor, immune_cor))
colors<-append(colors, rep("#c2b59b", length(immune_cor)))

metabolic<-as.character(read.csv("~/metabolic process.tsv", header=FALSE)[,1])
met_cor<-as.numeric(go_correlation[which(go_correlation[,1] %in% metabolic),2])
heat_cor<-rbind(heat_cor, cbind(met_cor, met_cor))
colors<-append(colors, rep("darkolivegreen4", length(met_cor)))

behavior<-as.character(read.csv("~/behavior.tsv", header=FALSE)[,1])
behavior_cor<-as.numeric(go_correlation[which(go_correlation[,1] %in% behavior),2])
heat_cor<-rbind(heat_cor, cbind(behavior_cor, behavior_cor))
colors<-append(colors, rep("darkorchid2", length(behavior_cor)))

development<-as.character(read.csv("~/developmental process.tsv", header=FALSE)[,1])
dev_cor<-as.numeric(go_correlation[which(go_correlation[,1] %in% development),2])
heat_cor<-rbind(heat_cor, cbind(dev_cor, dev_cor))
colors<-append(colors, rep("black", length(dev_cor)))

proliferation<-as.character(read.csv("~/cell population proliferation.tsv", header=FALSE)[,1])
pro_cor<-as.numeric(go_correlation[which(go_correlation[,1] %in% proliferation),2])
heat_cor<-rbind(heat_cor, cbind(pro_cor, pro_cor))
colors<-append(colors, rep("brown3", length(pro_cor)))

rownames(heat_cor)<-c(go_correlation[which(go_correlation[,1] %in% immune),1], go_correlation[which(go_correlation[,1] %in% metabolic),1], go_correlation[which(go_correlation[,1] %in% behavior),1], go_correlation[which(go_correlation[,1] %in% development),1], go_correlation[which(go_correlation[,1] %in% proliferation),1])
ord<-order(heat_cor[,1], decreasing = TRUE)
heat_cor<-heat_cor[ord,]
colors<-colors[ord]
heatmap.2(heat_cor, trace="n", Colv = NA, Rowv=FALSE, dendrogram = "none", labCol = "", labRow = "", RowSideColors = colors, col=colorRampPalette(c("#66aedf", "#153049"))(25))
legend("topright", legend=c("immune system process", "metabolic process", "behavior", "developmental process", "cell proliferation"), fill=c("#c2b59b", "darkolivegreen4", "darkorchid2", "black", "brown3"), cex=.8)

#FIGURE 4B

dates<-c(1994,1997,1999,2000,2002,2004,2005,2006,2008,2008.9,2009.9,2011,2012,2013,2014,2014.5,2015.2,2016.5,2017.4,2017.8)
cancer_vs_other<-data.frame(cbind(sqrt(append(rsq[8:12],rsq[15:29])),dates))
colnames(cancer_vs_other)<-c('Non.Cancer', 'Neoplasms')
pdf(paste0("~/Drug Graphs/header_intersection_drugs_FDA_over_time.pdf"))
p2 <- ggplot(cancer_vs_other, aes(x = `Neoplasms`, y = `Non.Cancer`)) + geom_point(color = "#153049", size=1) + scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_rect(fill = '#e8e7ea', colour = '#a7a9ac', size=1)) 
print(p2)
dev.off()