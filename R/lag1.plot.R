lag1.plot <-
function(series, max.lag=1, corr=TRUE, smooth=TRUE, col=gray(.1), 
         bgl ='white', lwl=1, ...){ 
   #
   as.ts = stats::as.ts
   par = graphics::par
   plot = graphics::plot
   lines= graphics::lines
   ts.intersect = stats::ts.intersect
   legend = graphics::legend
   #
   name1=paste(deparse(substitute(series)),"(t-",sep="")
   name2=paste(deparse(substitute(series)),"(t)",sep="")
   series=as.ts(series)
   max.lag=as.integer(max.lag)
   prow=ceiling(sqrt(max.lag))
   pcol=ceiling(max.lag/prow)
   a=stats::acf(series,max.lag,plot=FALSE)$acf[-1]
   old.par <- par(no.readonly = TRUE)
   par(mfrow=c(prow,pcol))
  for(h in 1:max.lag){                       
   tsplot(stats::lag(series,-h), series, type='p', xy.labels=FALSE, xlab=paste(name1,h,")",sep=""), ylab=name2, col=col, ...) 
    if (smooth==TRUE) 
    lines(stats::lowess(ts.intersect(stats::lag(series,-h),series)[,1],
                 ts.intersect(stats::lag(series,-h),series)[,2]), col=2, lwd=lwl)
    if (corr==TRUE)
    legend("topright", legend=round(a[h], digits=2), text.col=4, bg=bgl, adj=.25, cex = 0.85)
   on.exit(par(old.par))
   }
}

