sarima <-
function(xdata,p,d,q,P=0,D=0,Q=0,S=-1,details=TRUE,xreg=NULL,Model=TRUE,tol=sqrt(.Machine$double.eps),no.constant=FALSE)
{ 
  #
   layout = graphics::layout
   par = graphics::par
   plot = graphics::plot
   grid = graphics::grid
   abline = graphics::abline
   lines = graphics::lines
   frequency = stats::frequency
   na.pass = stats::na.pass
   #
 trc = ifelse(details==TRUE, 1, 0)
 n = length(xdata)
  if (is.null(xreg)) {
  constant = 1:n 
  xmean = rep(1,n);  if(no.constant==TRUE) xmean=NULL 
  if (d==0 & D==0) {	  
    fitit = stats::arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S),
              xreg=xmean,include.mean=FALSE, optim.control=list(trace=trc,REPORT=1,reltol=tol))
} else if (xor(d==1, D==1) & no.constant==FALSE) {
    fitit = stats::arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S),
              xreg=constant,optim.control=list(trace=trc,REPORT=1,reltol=tol))
} else fitit = stats::arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S), 
                     include.mean=!no.constant, optim.control=list(trace=trc,REPORT=1,reltol=tol))
}
#
  if (!is.null(xreg)) {fitit = stats::arima(xdata, order=c(p,d,q), seasonal=list(order=c(P,D,Q), period=S), xreg=xreg, optim.control=list(trace=trc,REPORT=1,reltol=tol))
}
#
#  replace tsdiag with a better version
    old.par <- par(no.readonly = TRUE)
    layout(matrix(c(1,2,4, 1,3,4), ncol=2))
    rs <- fitit$residuals
    stdres <- rs/sqrt(fitit$sigma2)
    num <- sum(!is.na(rs))
     plot.ts(stdres,  main = "Standardized Residuals", ylab = "")
	 if(Model){
	 if (S<0) {title(paste( "Model: (", p, "," ,d, "," ,q, ")", sep=""), adj=0) }
	 else {title(paste( "Model: (", p, "," ,d, "," ,q, ") ", "(", P, "," ,D, "," ,Q, ") [", S,"]",  sep=""), adj=0) }
	           }
    alag <- 10+sqrt(num)
    ACF = stats::acf(rs, alag, plot=FALSE, na.action = na.pass)$acf[-1] 
    LAG = 1:alag/frequency(xdata)
    L=2/sqrt(num)
     plot(LAG, ACF, type="h", ylim=c(min(ACF)-.1,min(1,max(ACF+.4))), main = "ACF of Residuals")
     abline(h=c(0,-L,L), lty=c(1,2,2), col=c(1,4,4))  
    stats::qqnorm(stdres, main="Normal Q-Q Plot of Std Residuals")  #stats::qqline(stdres, col=4) 
        ################qq error bnds - used CAR code ###########
        good <- !is.na(stdres)
        ord <- order(stdres[good])
        ord.stdres <- stdres[good][ord]
        PP <- ppoints(num)
        z  <- qnorm(PP)
        coe <- coef(MASS::rlm(ord.stdres~z))
        a <- coe[1]
        b <- coe[2]
        abline(a,b,col=4)
        SE <- (b/dnorm(z))*sqrt(PP*(1-PP)/num)     
        fit.value <- a + b*z
        U <- fit.value+3.9*SE   # puts .0005 in tails
        L <- fit.value-3.9*SE
          xx <- c(z, rev(z))
          yy <- c(L, rev(U))
        polygon(xx, yy, border=NA, col=gray(.6, alpha=.2) )   
        ############ end qq error bnds ##########################
    nlag <- ifelse(S<4, 20, 3*S)
    ppq <- p+q+P+Q
    pval <- numeric(nlag)
    for (i in (ppq+1):nlag) {u <- stats::Box.test(rs, i, type = "Ljung-Box")$statistic
                             pval[i] <- stats::pchisq(u, i-ppq, lower.tail=FALSE)}            
     plot( (ppq+1):nlag, pval[(ppq+1):nlag], xlab = "lag", ylab = "p value", ylim = c(0, 
        1), main = "p values for Ljung-Box statistic")
     abline(h = 0.05, lty = 2, col = "blue")  
    on.exit(par(old.par))    
#  end new tsdiag

  dfree = n-length(fitit$coef)
  t.value=fitit$coef/sqrt(diag(fitit$var.coef)) 
  p.two = stats::pf(t.value^2, df1=1, df2=dfree, lower.tail = FALSE)   
  ttable = cbind(Estimate=fitit$coef, SE=sqrt(diag(fitit$var.coef)), t.value, p.value=p.two)
  ttable= round(ttable,4)
  k = length(fitit$coef)
  BIC = log(fitit$sigma2)+(k*log(n)/n)
  AICc = log(fitit$sigma2)+((n+k)/(n-k-2))
  AIC = log(fitit$sigma2)+((n+2*k)/n)
  list(fit=fitit, degrees_of_freedom=dfree, ttable=ttable, AIC=AIC, AICc=AICc, BIC=BIC)
}


