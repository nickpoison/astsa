acf1 <-
function(series, max.lag=NULL, plot=TRUE, main=NULL, na.action = na.pass, ...){
  num=length(series)
  if (num > 59 & is.null(max.lag))  max.lag = max(ceiling(10+sqrt(num)), 4*frequency(series)) 
  if (num < 60 & is.null(max.lag))  max.lag = floor(5*log10(num+5))
  if (max.lag > (num-1)) stop("Number of lags exceeds number of observations")
  if (is.null(main)) {main = paste("Series: ",deparse(substitute(series)))}
  ACF=stats::acf(series, max.lag, plot=FALSE, na.action = na.action, ...)$acf[-1]
  LAG=1:max.lag/stats::frequency(series)
 if(plot){ 
  par = graphics::par
  plot = graphics::plot
  grid = graphics::grid
  abline = graphics::abline
  lines = graphics::lines
  frequency = stats::frequency
  minA=min(ACF)
  maxA=max(ACF)
  U=2/sqrt(num)
  L=-U
  minu=min(minA, L)-.01
  maxu=min(maxA+.2, 1)
  par(mar = c(2.5,2.5,1.5,0.5), mgp = c(1.5,0.6,0), cex.main=1)
  plot(LAG, ACF, type="n", ylim=c(minu,maxu), main=main)
    ###
    grid(lty=1, col=gray(.9)); box()
    abline(h=c(0,L,U), lty=c(1,2,2), col=c(1,4,4))
    lines(LAG, ACF, type='h', ...) 
 }	
  return(round(ACF,2)) 
  }

