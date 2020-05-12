library("reshape2")

genes_drugs_over_time_t_v2 <- read_csv("genes-drugs-over-time_t_v2.csv")

dat.m <- melt(genes_drugs_over_time_t_v2, id.vars = "year")

ggplot(dat.m, aes(x=year, y=value, colour = variable)) + scale_colour_manual(values = c("#153049", "#66aedf")) + geom_point(size=2) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_rect(fill = '#e6e7e8', colour = '#a7a9ac', size=1)) 
