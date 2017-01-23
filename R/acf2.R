acf2 <-
function(series, max.lag=NULL, plot=TRUE, main=paste("Series: ",deparse(substitute(series))), ...){
  num=length(series)
  if (num > 49 & is.null(max.lag)) max.lag=ceiling(10+sqrt(num))
  if (num < 50 & is.null(max.lag))  max.lag=floor(5*log10(num))
  if (max.lag > (num-1)) stop("Number of lags exceeds number of observations")
  ACF=stats::acf(series, max.lag, plot=FALSE, ...)$acf[-1]
  PACF=stats::pacf(series, max.lag, plot=FALSE, ...)$acf
  LAG=1:max.lag/stats::frequency(series)
 if(plot){
   par = graphics::par
   plot = graphics::plot
   grid = graphics::grid
   box = graphics::box
   abline = graphics::abline
   lines = graphics::lines
   frequency = stats::frequency
  minA=min(ACF)  
  maxA=max(ACF)
  minP=min(PACF)
  maxP=max(PACF)
  U=2/sqrt(num)
  L=-U
  minu=min(minA,minP,L)-.01
  maxu=min(max(maxA+.1, maxP+.1), 1)
  old.par <- par(no.readonly = TRUE)
  par(mfrow=c(2,1), mar = c(2.5,2.5,1.5,0.8), mgp = c(1.5,0.6,0), cex.main=1)
  plot(LAG, ACF, type="n", ylim=c(minu,maxu), main=main)
    ###
    grid(lty=1, col=gray(.9)); box()
    abline(h=c(0,L,U), lty=c(1,2,2), col=c(1,4,4))
    lines(LAG, ACF, type='h')
  plot(LAG, PACF, type="n", ylim=c(minu,maxu))
    grid(lty=1, col=gray(.9)); box()
    abline(h=c(0,L,U), lty=c(1,2,2), col=c(1,4,4))
    lines(LAG, PACF, type='h')
  on.exit(par(old.par))  
 } 
  ACF<-round(ACF,2); PACF<-round(PACF,2)    
  return(cbind(ACF, PACF)) 
  }

