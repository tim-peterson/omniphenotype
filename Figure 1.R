pairs<-read.csv("Huttlin_depmap_pairs_1000.tsv", sep="\t", header=FALSE)
is<-c()
grants<-read.csv("~/gene_grant_cost_1000_2020.tsv", sep="\t", row.names=1)
count<-0
moneys<-c()
for (i in 1:length(pairs[,1])){
  if (pairs[i,1] %in% rownames(grants) & pairs[i,2] %in% rownames(grants)){
    loc1<-which(rownames(grants) == pairs[i,1])
    loc2<-which(rownames(grants) == pairs[i,2])
    if (grants[loc1,loc2] > 0){
      count<-count + 1
      moneys<-append(moneys, grants[loc1,loc2])
      is<-append(is, i)
    }
  }
}
sum(unique(moneys))
length(unique(is))

grant_years<-read.csv("pairs_grants_year.tsv", sep="\t", header=FALSE)
lm(grant_years[,2]~grant_years[,1])
lm(cumsum(as.numeric(grant_years[,3]))/1000000~grant_years[,1])
library(ggplot2)
p2 <- ggplot(data.frame(cbind(cumsum(as.numeric(grant_years[,3]))/1000000,grant_years[,1])), aes(x = grant_years[,1], y = cumsum(grant_years[,3])/1000000)) + geom_vline(xintercept = 2020, colour="red") + geom_vline(xintercept = 2287.148, colour="blue") + geom_abline(slope = 265, intercept = -531921) + geom_point(color = "#153049", size=1) + ylim(0, 75000) + scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) + xlab('Fiscal year') + ylab("Cumulative budget\n(in millions)") + ggtitle("NIH budget spent on high-confidence gene pairs over time") + theme(plot.title = element_text(hjust = 0.5), axis.title.y = element_text(angle = 0, vjust=.5), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_rect(fill = '#e8e7ea', colour = '#a7a9ac', size=1)) 
print(p2)
