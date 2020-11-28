acf1 <-
function(series, max.lag=NULL, plot=TRUE, main=NULL, ylim=NULL, pacf=FALSE, 
          na.action = na.pass, ...){
  num=length(series)
  if (num > 59 & is.null(max.lag))  max.lag = max(ceiling(10+sqrt(num)), 4*frequency(series)) 
  if (num < 60 & is.null(max.lag))  max.lag = floor(5*log10(num+5))
  if (max.lag > (num-1)) stop("Number of lags exceeds number of observations")
  if (is.null(main)) {main = paste("Series: ",deparse(substitute(series)))}
  if (pacf) {
   ACF=stats::pacf(series, max.lag, plot=FALSE, na.action = na.action, ...)$acf
   ACF=as.numeric(ACF)
   } else {
   ACF=stats::acf(series, max.lag, plot=FALSE, na.action = na.action, ...)$acf[-1]
  }
  LAG=1:max.lag/stats::frequency(series)
 if(plot){ 
  par = graphics::par
  plot = graphics::plot
  grid = graphics::grid
  abline = graphics::abline
  lines = graphics::lines
  frequency = stats::frequency
  U=2/sqrt(num)
  L=-U
  if (is.null(ylim)) { 
	minA=min(ACF)
	maxA=max(ACF)
	minu=min(minA, L)-.01
	maxu=min(maxA+.2, 1)
	ylim = c(minu,maxu) 
 }
  Ylab = ifelse(pacf, 'PACF', 'ACF')
  par(mar = c(2.5,2.5,1.5,0.5), mgp = c(1.5,0.6,0))
  plot(LAG, ACF, type="n", ylim=ylim, main=main, ylab=Ylab)
    ###
    Grid();  box(col='gray')
    abline(h=c(0,L,U), lty=c(1,2,2), col=c('black','dodgerblue3','dodgerblue3'))
    lines(LAG, ACF, type='h', ...) 
	return(round(ACF,2)) 
 }	else {
  return(ACF)
  }
}

