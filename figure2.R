


# graphing data found in Table 1

p2 <- ggplot(cancer_vs_other, aes(x = `cancer`, y = `other`)) + geom_point(color = "#153049", size=4) + ylim(0,40000) + xlim(0,40000) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') 

# statistics

lm(formula = log(cancer_vs_other$other) ~ log(cancer_vs_other$cancer), 
    data = cancer_vs_other)

#Coefficients:
#                (Intercept)  log(cancer_vs_other$cancer)  
#                     0.5281                       0.7532  
