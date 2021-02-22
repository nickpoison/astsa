sarima <-  
function(xdata,p,d,q,P=0,D=0,Q=0,S=-1,details=TRUE,xreg=NULL,Model=TRUE,
          fixed=NULL,tol=sqrt(.Machine$double.eps),no.constant=FALSE, ...)
{ 
   arima = stats::arima
   #
   trans = ifelse (is.null(fixed), TRUE, FALSE)
   trc = ifelse(details, 1, 0)
   n = length(xdata)
 if (is.null(xreg)) {
   constant = 1:n 
   xmean = rep(1,n);  if(no.constant==TRUE) xmean=NULL 
   if (d==0 & D==0) {	  
    fitit = arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S),
            xreg=xmean,include.mean=FALSE,fixed=fixed,trans=trans,optim.control=list(trace=trc,REPORT=1,reltol=tol))
    } else if (xor(d==1, D==1) & no.constant==FALSE) {
    fitit = arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S),
            xreg=constant,fixed=fixed,trans=trans,optim.control=list(trace=trc,REPORT=1,reltol=tol))
    } else fitit = arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S), 
                   include.mean=!no.constant,fixed=fixed,trans=trans, optim.control=list(trace=trc,REPORT=1,reltol=tol))
  }
#
  if (!is.null(xreg)) {fitit = stats::arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S), xreg=xreg, fixed=fixed,trans=trans,optim.control=list(trace=trc,REPORT=1,reltol=tol))
}
#  replace tsdiag with a better version
 if(details){
   layout = graphics::layout
   par = graphics::par
   plot = graphics::plot
   acf = stats::acf
   polygon = graphics::polygon
   abline = graphics::abline
   lines = graphics::lines
   title = graphics::title
   frequency = stats::frequency
   coef = stats::coef
   dnorm = stats::dnorm
   ppoints = stats::ppoints
   qnorm = stats::qnorm
   time = stats::time
   na.pass = stats::na.pass
   old.par <- par(no.readonly = TRUE)
  layout(matrix(c(1,2,4, 1,3,4), ncol=2))
   rs <- fitit$residuals
   stdres <- rs/sqrt(fitit$sigma2)
   num <- sum(!is.na(rs))
   tsplot(stdres, main = "Standardized Residuals", ylab = "", ...)
	if(Model){
	 if (S<0) {title(paste( "Model: (", p, "," ,d, "," ,q, ")", sep=""), adj=0) }
	 else {title(paste( "Model: (", p, "," ,d, "," ,q, ") ", "(", P, "," ,D, "," ,Q, ") [", S,"]",  sep=""), adj=0) }
	}
    alag <- max(10+sqrt(num), 3*S)    
    ACF = acf(rs, alag, plot=FALSE, na.action = na.pass)$acf[-1] 
    LAG = 1:alag/frequency(xdata)
    L=2/sqrt(num)
    tsplot(LAG, ACF, type="h", ylim=c(min(ACF)-.1,min(1,max(ACF+.4))), main = "ACF of Residuals", ...)
     abline(h=c(0,-L,L), lty=c(1,2,2), col=c(1,4,4))  
    u = qqnorm(stdres, main="Normal Q-Q Plot of Std Residuals", plot.it=FALSE)
	lwr = min(-4, min(stdres)); upr = max(4, max(stdres))
    tsplot(u$x, u$y, type='p', ylim=c(lwr,upr), ylab="Sample Quantiles", xlab="Theoretical Quantiles", main="Normal Q-Q Plot",  ...)	
      ################ qq error bnds ###########
       sR  <- !is.na(stdres)
       ord <- order(stdres[sR])
       ord.stdres <- stdres[sR][ord]
       PP  <- stats::ppoints(num)
       z   <- stats::qnorm(PP)
       y   <- stats::quantile(ord.stdres, c(.25,.75), names = FALSE, type = 7, na.rm = TRUE)
       x   <- stats::qnorm(c(.25,.75))
       b   <- diff(y)/diff(x)
       a   <- y[1L] - b * x[1L]
       abline(a,b,col=4)  #qqline
       SE  <- (b/dnorm(z))*sqrt(PP*(1-PP)/num)     
       qqfit <- a + b*z
       U <- qqfit+3.9*SE   # puts .00005 in tails
       L <- qqfit-3.9*SE
         z[1]=z[1]-.1      # extend plot -- misses the end otherwise
         z[length(z)]= z[length(z)]+.1
         xx <- c(z, rev(z))
         yy <- c(L, rev(U))
        polygon(xx, yy, border=NA, col=gray(.5, alpha=.2) )   
      ############ end qq error bnds ##########################
    nlag <- ifelse(S<7, 20, 3*S)
    ppq <- p+q+P+Q - sum(!is.na(fixed))   # decrease by number of fixed parameters
	if (nlag < ppq + 8) {nlag = ppq + 8}
    pval <- numeric(nlag)
    for (i in (ppq+1):nlag) {u <- stats::Box.test(rs, i, type = "Ljung-Box")$statistic
                             pval[i] <- stats::pchisq(u, i-ppq, lower.tail=FALSE)}            
     tsplot( (ppq+1):nlag, pval[(ppq+1):nlag], type='p', xlab = "LAG (H)", ylab = "p value", ylim = c(-.14, 
        1), main = "p values for Ljung-Box statistic", ...)
     abline(h = 0.05, lty = 2, col = 4)  
    on.exit(par(old.par)) 
}	
#  end new tsdiag
   if (is.null(fixed)) {coefs=fitit$coef
   } else { coefs = fitit$coef[is.na(fixed)]
   }  
   dfree = fitit$nobs-length(coefs) 
   t.value=coefs/sqrt(diag(fitit$var.coef)) 
   p.two = stats::pf(t.value^2, df1=1, df2=dfree, lower.tail = FALSE)   
   ttable = cbind(Estimate=coefs, SE=sqrt(diag(fitit$var.coef)), t.value, p.value=p.two)
   ttable= round(ttable,4)
   k = length(coefs) 
   n = n - (d + D)  # effective sample size
   BIC  = stats::BIC(fitit)/n
   AIC  = stats::AIC(fitit)/n
   AICc = (n*AIC + ( (2*k^2+2*k)/(n-k-1) ))/n
   list(fit=fitit, degrees_of_freedom=dfree, ttable=ttable, AIC=AIC, AICc=AICc, BIC=BIC)
}


