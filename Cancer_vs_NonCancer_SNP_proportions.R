library(ggplot2)
proportions<-read.csv("proportion_diseases.tsv", header=TRUE, sep="\t", row.names=1)
proportions<-read.csv("proportion_drugs.tsv", header=TRUE, sep="\t", row.names=1)
num_can_sig<-proportions[,1]/26
num_can_not<-which(num_can_sig == 0)
num_non_sig<-proportions[,2]/74
num_non_not<-which(num_non_sig == 0)
num_not<-intersect(num_non_not, num_can_not)
num_can_sig<-jitter(proportions[,5]/26)
num_non_sig<-jitter(proportions[,6]/74)
cor.test(num_can_sig, num_non_sig, model="spearman")$p.value
summary(lm(num_can_sig[-num_not]~num_non_sig[-num_not]))$r.squared
cancer_vs_other<-data.frame(cbind(num_non_sig,num_can_sig))
cancer_vs_other<-data.frame(cbind(num_non_sig[-num_not],num_can_sig[-num_not]))
colnames(cancer_vs_other)<-c('Non.Cancer', 'Neoplasms')
p2 <- ggplot(cancer_vs_other, aes(x = `Neoplasms`, y = `Non.Cancer`)) + geom_point(color = "#153049", size=1) + scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) + xlab('Cancer Diseases') + ylab("Non-Cancer\nDiseases") + ggtitle("Proportion of Diseases with a\nSignificant SNP per Gene\n(beta > .001 and p-value < 1e-3)") + theme(plot.title = element_text(hjust = 0.5), axis.title.y = element_text(angle = 0, vjust=.5), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_rect(fill = '#e8e7ea', colour = '#a7a9ac', size=1)) 
print(p2)
plot(hexbin(num_can_sig, num_non_sig))
genes<-read.csv("gencode.v19.annotation.gtf", sep="\t", header=FALSE)
gene_length<-c()
for(i in row.names(proportions)){
  gene_name<-which(genes[,9] == i)
  gene_length<-append(gene_length, genes[gene_name[1],5] - genes[gene_name[1],4])
}
#gene_names<-which(genes[,9] %in% row.names(proportions))
#gene_length<-genes[gene_names,5] - genes[gene_names,4]
#gene_length<-gene_length[order(genes[gene_names,9])]
summary(lm(num_can_sig~gene_length))$r.squared
pcor.test(num_can_sig, num_non_sig, gene_length, method="spearman")
