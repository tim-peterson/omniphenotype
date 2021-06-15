library(ggplot2)
library("scales")

# needed to invert y-axis while making it log scale
reverselog_trans <- function(base = exp(1)) {
  trans <- function(x) -log(x, base)
  inv <- function(x) base^(-x)
  trans_new(paste0("reverselog-", format(base)), trans, inv, 
            log_breaks(base = base), 
            domain = c(1e-100, Inf))
}

# plotting Pearsons vs. p-value
ggplot(MTOR_RPTOR2, aes(x=X2, y=X3, colour = "#153049")) + scale_colour_manual(values = c("#153049")) + geom_point(size=2) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_rect(fill = '#e6e7e8', colour = '#a7a9ac', size=1)) + scale_y_continuous(trans=reverselog_trans(10)) 

# if include citation counts  
#ggplot(MTOR_pearsons, aes(x=X2, y=X3, colour = X4 > 0)) + scale_colour_manual(name = 'citations > 0', values = setNames(c('red',"#153049"),c(T, F))) + geom_point(size=2) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_rect(fill = '#e6e7e8', colour = '#a7a9ac', size=1)) + scale_y_continuous(trans=reverselog_trans(10))
ggplot(tail(BDNF_SLC6A4, -2)[!(tail(BDNF_SLC6A4, -2)$X1=="TH"),], aes(x=X2, y=X3, colour = (X4 > 0 & X3 < 0.00000001))) + scale_colour_manual(name = 'citations > 0', values = setNames(c("#66AEDF","#153049"),c(T, F))) + geom_point(aes(size=2)) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_rect(fill = '#e6e7e8', colour = '#a7a9ac', size=1),legend.title = element_blank()) + scale_y_continuous(trans=reverselog_trans(10))

# if color coded above a threshold
ggplot(tail(TGFBR12, -2)[!(tail(TGFBR12, -2)$X1=="TH"),], aes(x=X2, y=X3, colour = (X4 > 0 & X3 < 0.00000001))) + scale_colour_manual(name = 'citations > 0', values = setNames(c("#66AEDF","#153049"),c(T, F))) + geom_point(aes(size=2)) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_rect(fill = '#e6e7e8', colour = '#a7a9ac', size=1)) + scale_y_continuous(trans=reverselog_trans(10))