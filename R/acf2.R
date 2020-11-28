acf2 <-
function(series, max.lag=NULL, plot=TRUE, main=NULL, ylim=NULL, na.action = na.pass, ...){
  num=length(series)
  if (num > 59 & is.null(max.lag))  max.lag = max(ceiling(10+sqrt(num)), 4*frequency(series)) 
  if (num < 60 & is.null(max.lag))  max.lag = floor(5*log10(num+5))
  if (max.lag > (num-1)) stop("Number of lags exceeds number of observations")
  if (is.null(main)) {main = paste("Series: ",deparse(substitute(series)))}
  ACF=stats::acf(series, max.lag, plot=FALSE, na.action = na.action,...)$acf[-1]
  PACF=stats::pacf(series, max.lag, plot=FALSE, na.action = na.action, ...)$acf
  LAG=1:max.lag/stats::frequency(series)
 if(plot){
   par = graphics::par
   plot = graphics::plot
   grid = graphics::grid
   box = graphics::box
   abline = graphics::abline
   lines = graphics::lines
   frequency = stats::frequency
   	U=2/sqrt(num)
	L=-U
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
  par(mfrow=c(2,1), mar = c(2.5,2.5,1.5,0.8), mgp = c(1.5,0.6,0), cex.main=1)
  plot(LAG, ACF, type="n", ylim=ylim, main=main)
    ###
    Grid();  box(col='gray')
    abline(h=c(0,L,U), lty=c(1,2,2), col=c('black','dodgerblue3','dodgerblue3'))
    lines(LAG, ACF, type='h')
  plot(LAG, PACF, type="n", ylim=ylim)
    Grid();  box(col='gray')
    abline(h=c(0,L,U), lty=c(1,2,2), col=c('black','dodgerblue3','dodgerblue3'))
    lines(LAG, PACF, type='h')
    on.exit(par(old.par))
    ACF<-round(ACF,2); PACF<-round(PACF,2)    
    return(rbind(ACF, PACF)) 	
  } else {
  return(cbind(ACF, PACF)) 
  }
}  

