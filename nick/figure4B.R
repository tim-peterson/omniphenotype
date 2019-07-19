library(ggplot2)

go_genes<-read.csv("go_gene.tsv", header=FALSE, sep="\t")
go_terms<-unique(go_genes[,2])

rsq = c()
for (i in 1:30){
  header_interactions<-read.csv(paste0("~/header_intersection_drugs_FDA_",i,"000000.tsv"), sep="\t")
  header_interactions<-header_interactions[-which(header_interactions[,1] <= 0),]
  header_interactions<-header_interactions[-which(header_interactions[,2] <= 0),]
  header_interactions<-header_interactions[order(header_interactions[,1]+header_interactions[,2], decreasing = TRUE),]
  rem_list<-c()
  for (j in 2:length(header_interactions[,1])){
    if (all(header_interactions[j,] == header_interactions[(j-1),])){
      rem_list<-append(rem_list, j)
    }
  }
  header_interactions<-header_interactions[-rem_list,]
  go_lines<-header_interactions[which(rownames(header_interactions) %in% genes_in_go),]
  rsq<-append(rsq, round(summary(lm(log10(go_lines[,1]) ~ log10(go_lines[,2])))$r.squared,3))
}

dates<-c(1994,1997,1999,2000,2002,2004,2005,2006,2008,2008.9,2009.9,2011,2012,2013,2014,2014.5,2015.2,2016.5,2017.4,2017.8)
cancer_vs_other<-data.frame(cbind(sqrt(append(rsq[8:12],rsq[15:29])),dates))
colnames(cancer_vs_other)<-c('Non.Cancer', 'Neoplasms')
pdf(paste0("~/Drug Graphs/header_intersection_drugs_FDA_over_time.pdf"))
p2 <- ggplot(cancer_vs_other, aes(x = `Neoplasms`, y = `Non.Cancer`)) + geom_point(color = "#153049", size=1) + scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_rect(fill = '#e8e7ea', colour = '#a7a9ac', size=1)) 
print(p2)
dev.off()