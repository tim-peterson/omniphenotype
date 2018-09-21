
# graphing data found in Figure 2

library(ggplot2)

p2 <- ggplot(cancer_vs_other, aes(x = `cancer`, y = `other`)) + geom_point(color = "#153049", size=1) + ylim(0,40000) + xlim(0,40000) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_rect(fill = '#e8e7ea', colour = '#a7a9ac', size=1)) 




