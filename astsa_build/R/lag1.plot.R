lag1.plot <-
function(series, max.lag=1, corr=TRUE, smooth=TRUE, col=gray(.1), 
         lwl=1, lwc=2, bgl=gray(1,.65), ltcol=1, box.col=8, cex=.9, ...){ 

  name1   = paste(deparse(substitute(series)),"(t-",sep="")
  name2   = paste(deparse(substitute(series)),"(t)",sep="")
  max.lag = as.integer(max.lag)
  prow    = ceiling(sqrt(max.lag))
  pcol    = ceiling(max.lag/prow)
  a       = acf1(series, max.lag, plot=FALSE) 
  old.par <- par(no.readonly = TRUE)

 series = as.ts(series)
 par(mfrow = c(prow, pcol))
 for(h in 1:max.lag){
   u = ts.intersect(stats::lag(series,-h), series)
  tsplot(u[,1], u[,2], type='p', xy.labels=FALSE, xy.lines=FALSE,
          xlab=paste(name1,h,")",sep=""), ylab=name2, col=col, cex=cex, ...) 
  if (smooth) 
   lines(stats::lowess(u[,1], u[,2]), col=lwc, lwd=lwl)
  if (corr)
   legend("topright", legend=format(round(a[h], digits=2), nsmall=2), 
           text.col=ltcol, bg=bgl, adj=.25, box.col=box.col, cex=.9)
 }
 on.exit(par(old.par))
}

