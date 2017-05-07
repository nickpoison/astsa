acf1 <-
function(series, max.lag=NULL, main=paste("Series: ",deparse(substitute(series))), ...){
  par = graphics::par
  plot = graphics::plot
  grid = graphics::grid
  abline = graphics::abline
  lines = graphics::lines
  frequency = stats::frequency
  num=length(series)
  if (num > 49 & is.null(max.lag)) max.lag=ceiling(10+sqrt(num))
  if (num < 50 & is.null(max.lag))  max.lag=floor(5*log10(num))
  if (max.lag > (num-1)) stop("Number of lags exceeds number of observations")
  ACF=stats::acf(series, max.lag, plot=FALSE, ...)$acf[-1]
  LAG=1:max.lag/stats::frequency(series)
  minA=min(ACF)
  maxA=max(ACF)
  U=2/sqrt(num)
  L=-U
  minu=min(minA, L)-.01
  maxu=min(maxA+.2, 1)
  old.par <- par(no.readonly = TRUE)
  old.par <- par(no.readonly = TRUE)
  par(mar = c(2.5,2.5,1.5,0.8), mgp = c(1.5,0.6,0), cex.main=1)
  plot(LAG, ACF, type="n", ylim=c(minu,maxu), main=main)
    ###
    grid(lty=1, col=gray(.9)); box()
    abline(h=c(0,L,U), lty=c(1,2,2), col=c(1,4,4))
    lines(LAG, ACF, type='h')
  on.exit(par(old.par))    
  return(round(ACF,2)) 
  }

