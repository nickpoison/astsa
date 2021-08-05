acf1 <-
function(series, max.lag=NULL, plot=TRUE, main=NULL, ylim=NULL, pacf=FALSE, 
          ylab=NULL, na.action = na.pass, ...){
  frequency = stats::frequency
  acf  = stats::acf
  num  = length(series)
  if (num > 59 & is.null(max.lag))  max.lag = max(ceiling(10+sqrt(num)), 4*frequency(series)) 
  if (num < 60 & is.null(max.lag))  max.lag = floor(5*log10(num+5))
  if (max.lag > (num-1)) stop("Number of lags exceeds number of observations")
  if (is.null(main)) {main = paste("Series: ",deparse(substitute(series)))}
  if (pacf) {
   ACF = stats::pacf(series, max.lag, plot=FALSE, na.action = na.action, ...)$acf
   ACF = as.numeric(ACF)
   } else {
   ACF = acf(series, max.lag, plot=FALSE, na.action = na.action, ...)$acf[-1]
  }
  frequency = frequency(series)
  LAG = (1:max.lag)/frequency
 if(plot){ 
  abline = graphics::abline
  U = (-1/num) + (2/sqrt(num))
  L = (-1/num) - (2/sqrt(num))
  if (is.null(ylim)) { 
   minA = min(ACF)
   maxA = max(ACF)
   minu = min(minA, L)-.01
   maxu = min(maxA+.2, 1)
   ylim = c(minu,maxu) 
 }
  Xlab = ifelse(frequency>1, paste('LAG', expression('\u00F7'), frequency), 'LAG')
  Ylab = ifelse(pacf, 'PACF', 'ACF')  
  if (!is.null(ylab)) Ylab=ylab
  tsplot(LAG, ACF, ylim=ylim, main=main, xlab=Xlab, ylab=Ylab, type='h', ...)
  abline(h=c(0,L,U), lty=c(1,2,2), col=c(8,4,4))
  return(round(ACF, 2)) 
 } else {
  return(ACF)
  }
}


