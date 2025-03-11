sarima <-  
function(xdata,p,d,q,P=0,D=0,Q=0,S=-1,details=TRUE,xreg=NULL,Model=TRUE,
          fixed=NULL,tol=sqrt(.Machine$double.eps),no.constant=FALSE, col, ...)
{ 
   if (missing(col)) col=1
   trans = ifelse (is.null(fixed), TRUE, FALSE)
   trc   = ifelse(details, 1, 0)
   n     = length(xdata) 
  if (is.null(xreg)) {
   constant = 1:n 
   xmean    = rep(1,n)  
   if (no.constant)  xmean=NULL 
   if (d==0 & D==0) {  
           fitit = arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S),
                  xreg=xmean, include.mean=FALSE, fixed=fixed, transform.pars=trans, 
                  optim.control=list(trace=trc, REPORT=1, reltol=tol))
    } else if (xor(d==1, D==1) & no.constant==FALSE) {
           fitit = arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S),
                   xreg=constant, fixed=fixed, transform.pars=trans,
                   optim.control=list(trace=trc, REPORT=1, reltol=tol))
    } else fitit = arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S), 
                   include.mean=!no.constant, fixed=fixed, transform.pars=trans, 
                   optim.control=list(trace=trc, REPORT=1, reltol=tol))
  } 

  if (!is.null(xreg)) {
    fitit = arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S), 
                         xreg=xreg, fixed=fixed, transform.pars=trans, 
                         optim.control=list(trace=trc, REPORT=1, reltol=tol))
  }

  if (is.null(fixed)) {coefs=fitit$coef
    } else { coefs = fitit$coef[is.na(fixed)]
    }
  
   k       = length(coefs) 
   n       = fitit$nobs  # effective sample size
   dfree   = n-k 
   t.value = coefs/sqrt(diag(fitit$var.coef)) 
   p.two   = stats::pf(t.value^2, df1=1, df2=dfree, lower.tail = FALSE)   
   ttable  = cbind(Estimate=coefs, SE=sqrt(diag(fitit$var.coef)), t.value, p.value=p.two)
   ttable  = round(ttable,4)
   BIC     = stats::BIC(fitit)/n
   AIC     = stats::AIC(fitit)/n
   AICc    = (n*AIC + ( (2*k^2+2*k)/(n-k-1) ))/n


# print  results
  cat('<><><><><><><><><><><><><><>')
  cat('\n','\n')
  if (k > 0) {
   cat('Coefficients:', '\n')
   print(ttable)
   cat('\n') 
  } 
  cat('sigma^2 estimated as', fitit$sigma2, 'on', dfree, 'degrees of freedom', '\n','\n')
  cat('AIC =', AIC, ' AICc =', AICc, ' BIC =', BIC, '\n', '\n')
  out = list(fit=fitit, degrees_of_freedom=dfree, ttable=ttable, 
             ICs=c(AIC=AIC, AICc=AICc, BIC=BIC))
############################

#  replace tsdiag with a better version
 if(details){
   old.par  <- par(no.readonly = TRUE)
   layout(matrix(c(1,2,4, 1,3,4), ncol=2))
   par(cex=.85)
   rs     = fitit$residuals 
   stdres = rs/sqrt(fitit$sigma2)
   num    = sum(!is.na(rs))

# [1] 
  tsplot(stdres, main = "Standardized Residuals", ylab = "", col=col, ...)
    if(Model){
     if (S<0) {
      title(bquote('Model: ('~.(p)*','*.(d)*','*.(q)~')'), adj=0, cex.main=.95) 
      } else {
      title(bquote('Model: ('~.(p)*','*.(d)*','*.(q)~')'~'\u00D7'~'('~.(P)*','*.(D)*','*.(Q)~')'[~.(S)]), adj=0, cex.main=.95) 
      }
    }

# [2]
  acf1(rs, max.lag=NULL, main = "ACF of Residuals", col=col, ...)

# [3]
  QQnorm(stdres, col=col, main="Normal Q-Q Plot of Std Residuals", ...)

# [4] 
    nlag = ifelse(S<7, 20, 3*S)
    ppq  = p+q+P+Q - sum(!is.na(fixed))   # decrease by number of fixed parameters
    if (nlag < ppq + 8) { nlag = ppq + 8 }
    pval = numeric(nlag)
    for (i in (ppq+1):nlag) {
     u   = stats::Box.test(rs, i, type = "Ljung-Box")$statistic
     pval[i] = stats::pchisq(u, i-ppq, lower.tail=FALSE)
    } 
  tsplot( (ppq+1):nlag, pval[(ppq+1):nlag], type='p', xlab = "LAG (H)", ylab = "p value", 
          ylim = c(-.14, 1), main = "p values for Ljung-Box Statistic", col=col, minor=FALSE, ...)
   abline(h = 0.05, lty = 2, col = 4)  
   on.exit(par(old.par)) 
 }  #  end new tsdiag

invisible(out)
}