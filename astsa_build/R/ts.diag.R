ts.diag <-  
function(resids, col=1, fitdf=0, nlag=20, ...) 
{ 

   if (NCOL(resids) > 1){ stop('\nUnivariate Input Only \n')}
   if (nlag < fitdf + 8) { nlag = fitdf + 8 }

   old.par  <- par(no.readonly = TRUE)
   layout(matrix(c(1,2,4, 1,3,4), ncol=2))
   par(cex=.85)
   rs     = resids - mean(resids, na.rm = TRUE)
   stdres = rs/sd(rs, na.rm = TRUE)

# [1] 
    lt = ifelse(any(is.na(resids)), 'o', 'l') 
   tsplot(stdres, main = "Standardized Residuals", ylab = "", col=col, type=lt, ...)

# [2]
  acf1(rs, max.lag=NULL, main = "ACF of Residuals", col=col, ...)

# [3]
  QQnorm(stdres, col=col, main="Normal Q-Q Plot of Std Residuals", ...)

# [4] 
    pval = c()
    for (i in (fitdf+1):nlag) {
     u   = Box.test(rs, i, type = "Ljung-Box", fitdf=fitdf)$statistic
     pval[i] =  pchisq(u, i-fitdf, lower.tail=FALSE)
    } 
  tsplot( (fitdf+1):nlag, pval[(fitdf+1):nlag], type='p', xlab = "LAG (H)", ylab = "p value", 
          ylim = c(-.14, 1), main = "p values for Ljung-Box Statistic", col=col, minor=FALSE, ...)
   abline(h = 0.05, lty = 2, col = 4)  
   on.exit(par(old.par)) 
}