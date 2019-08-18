lag1.plot <-
function(series,max.lag=1,corr=TRUE,smooth=TRUE,col=gray(.1), ...){ 
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
   par(mfrow=c(prow,pcol), mar=c(2.5, 2.5, 1, 1), mgp=c(1.6,.6,0), cex.main=1, font.main=1)
  for(h in 1:max.lag){                       
   plot(stats::lag(series,-h), series, xy.labels=FALSE, main=paste(name1,h,")",sep=""), ylab=name2, xlab="", col=col, panel.first=Grid(), ...) 
    if (smooth==TRUE) 
    lines(stats::lowess(ts.intersect(stats::lag(series,-h),series)[,1],
                 ts.intersect(stats::lag(series,-h),series)[,2]), col="red")
    if (corr==TRUE)
    legend("topright", legend=round(a[h], digits=2), text.col ="blue", bg="white", adj=.25, cex = 0.85)
   on.exit(par(old.par))
   }
}

