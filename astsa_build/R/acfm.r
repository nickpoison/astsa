acfm <-
function(series, max.lag = NULL,  na.action = na.pass, ylim=NULL, 
         acf.highlight = TRUE, plot = TRUE, ...)
{
nser = NCOL(series)
  if (nser < 2) {stop("Multivariate time series only")} 

xfreq = tsp(as.ts(series))[3]  

num = nrow(series)
  if (num < 3) stop("More than 2 observations per series are needed")
  if (num > 59 & is.null(max.lag)) 
      max.lag = max(ceiling(10 + sqrt(num)), 4 * xfreq)
  if (num < 60 & is.null(max.lag))  max.lag = min(floor(6*log10(num+5)), num-2)
  if (max.lag > (num - 2))
      stop("Number of lags exceeds number of observations")

u = stats::acf(series, lag.max=max.lag, plot=FALSE, na.action=na.action)
ACF = u
for (i in 1:nser){ u$acf[1,i,i] = NA }  # remove 0 lag on acfs

lowr = min(as.vector(u$acf), na.rm = TRUE) - .01
lowr = max(lowr, -1)
uppr = max(as.vector(u$acf), na.rm = TRUE) + .05
uppr = min(uppr, 1)


if (plot){
 old.par <- par(no.readonly = TRUE)
 par(mfrow=c(nser,nser), oma=c(0,2,2,0), cex.main=1)
  Xlab = ifelse(xfreq>1, paste('LAG \u00F7', xfreq), 'LAG')
  for (i in 1:nser){ 
   for (j in 1:nser){ 
      U = (-1/num)*(i==j) + (2/sqrt(num))
      L = (-1/num)*(i==j) - (2/sqrt(num))
     tsplot(u$lag[,i,j], u$acf[,i,j], type='h', ylab="", main=NULL, xlab=Xlab, ylim=c(lowr,uppr), ...)
      abline(h = c(0, L, U), lty = c(1, 2, 2), col = c(8, 4, 4))       
      txt2 = ifelse(j==1,u$snames[i],"") 
       mtext(txt2, side=2, font=2, line=2, las=0, cex=.65*(nser+1)/nser)
      txt3 = ifelse (i==1,u$snames[j],"") 
        mtext(txt3, side=3, font=2, line=.75, las=0, cex=.65*(nser+1)/nser)
       if(i==j && acf.highlight) box(col=1)
   }   
  } 
 mtext('Leads', side=3, line=.65, outer=TRUE, cex=.9) 
 mtext('Lags',  side=2, line=.65, outer=TRUE, cex=.9, las=0)  
 par(old.par)
}
return(invisible(ACF))
}

