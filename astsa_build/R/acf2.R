acf2 <-
function(series, max.lag=NULL, plot=TRUE, main=NULL, ylim=NULL, na.action=na.pass, ...){

  num   = length(series)
  xfreq = frequency(series)

  if (num < 3) stop("More than 2 observations are needed")
  if (num > 59 & is.null(max.lag))  max.lag = max(ceiling(10+sqrt(num)), 4*xfreq) 
  if (num < 60 & is.null(max.lag))  max.lag =  floor(6*log10(num))
  if (max.lag > (num-1)) max.lag = floor(6*log10(num)*(num<60) + (10+sqrt(num))*(num>59))
  if (is.null(main)) main = paste("Series: ",deparse(substitute(series)))

  ACF  = acf(series, lag.max=max.lag, plot=FALSE, na.action = na.action,...)$acf[-1]
  PACF = pacf(series, lag.max=max.lag, plot=FALSE, na.action = na.action, ...)$acf

 if(plot){
   U = (-1/num) + (2/sqrt(num))
   L = (-1/num) - (2/sqrt(num))
   LAG  = (1:max.lag)/xfreq
   old.par <- par(no.readonly = TRUE)
   if (is.null(ylim)) { 
    minA=min(ACF)  
    maxA=max(ACF)
    minP=min(PACF)
    maxP=max(PACF)
    minu=min(minA,minP,L)-.01
    maxu=min(max(maxA+.1, maxP+.1), 1)
    ylim = c(minu,maxu)
   }
  par(mfrow=c(2,1), cex.main=1) 
   Xlab = ifelse(xfreq>1, paste('LAG \u00F7', xfreq), 'LAG')
   tsplot(LAG, ACF, ylim=ylim, main=main, xlab=Xlab, ylab='ACF', type='h', ...)
    abline(h=c(0,L,U), lty=c(1,2,2), col=c(8,4,4))
   tsplot(LAG, PACF, ylim=ylim, main=NULL, xlab=Xlab, ylab='PACF', type='h', ...)
    abline(h=c(0,L,U), lty=c(1,2,2), col=c(8,4,4))
   on.exit(par(old.par))
   ACF  <- round(ACF,2) 
   PACF <- round(PACF,2)    
  return(rbind(ACF, PACF)) 	
  } else {
  return(cbind(ACF, PACF)) 
  }
}  

