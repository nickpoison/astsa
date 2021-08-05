acf2 <-
function(series, max.lag=NULL, plot=TRUE, main=NULL, ylim=NULL, na.action = na.pass, ...){
  acf  = stats::acf
  pacf = stats::pacf
  num  = length(series)
  frequency = stats::frequency
  if (num > 59 & is.null(max.lag))  max.lag = max(ceiling(10+sqrt(num)), 4*frequency(series)) 
  if (num < 60 & is.null(max.lag))  max.lag = floor(5*log10(num+5))
  if (max.lag > (num-1)) stop("Number of lags exceeds number of observations")
  if (is.null(main)) {main = paste("Series: ",deparse(substitute(series)))}
  ACF  = acf(series, max.lag, plot=FALSE, na.action = na.action,...)$acf[-1]
  PACF = pacf(series, max.lag, plot=FALSE, na.action = na.action, ...)$acf
  frequency = frequency(series)
  LAG  = (1:max.lag)/frequency
 if(plot){
   abline = graphics::abline
   par = graphics::par
   U = (-1/num) + (2/sqrt(num))
   L = (-1/num) - (2/sqrt(num))
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
   Xlab = ifelse(frequency>1, paste('LAG', expression('\u00F7'), frequency), 'LAG')
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

