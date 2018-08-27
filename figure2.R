


# graphing data found in Table 1

p2 <- ggplot(cancer_vs_other, aes(x = `cancer`, y = `other`)) + geom_point(color = "#153049", size=4) + ylim(0,40000) + xlim(0,40000) + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10') 

# statistics

# intercept and slope

lm(formula = log(cancer_vs_other$other) ~ log(cancer_vs_other$cancer), 
    data = cancer_vs_other)

#Coefficients:
#                (Intercept)  log(cancer_vs_other$cancer)  
#                     0.5281                       0.7532  


# correlation coefficient 

cor(log(cancer_vs_other$other),log(cancer_vs_other$cancer))

#[1] 0.6890797


# skewness
fit = lm(formula = log(cancer_vs_other$other) ~ log(cancer_vs_other$cancer), data = cancer_vs_other)

# plot shows skewness decreases up to about 10^4 citations
plot(log(cancer_vs_other$other),abs(fit$residuals))