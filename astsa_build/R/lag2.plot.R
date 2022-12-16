lag2.plot <-
function(series1, series2, max.lag=0, corr=TRUE, smooth=TRUE, col=gray(.1),
         lwl=1, bgl ='white', ltcol=1, box.col=8, ...){ 
   #
   as.ts = stats::as.ts
   par = graphics::par
   plot = graphics::plot
   lines= graphics::lines
   ts.intersect = stats::ts.intersect
   legend = graphics::legend
   #
   name1=paste(deparse(substitute(series1)),"(t-",sep="")
   name2=paste(deparse(substitute(series2)),"(t)",sep="")
   series1=as.ts(series1)
   series2=as.ts(series2)
   max.lag=as.integer(max.lag)
   m1=max.lag+1
   prow=ceiling(sqrt(m1))
   pcol=ceiling(m1/prow)
   a=stats::ccf(series1,series2,max.lag,plot=FALSE)$acf
   old.par <- par(no.readonly = TRUE)
   par(mfrow=c(prow,pcol))
   for(h in 0:max.lag){                   
   tsplot(stats::lag(series1,-h), series2, xy.labels=FALSE, type='p', 
               xlab=paste(name1,h,")",sep=""), ylab=name2, col=col, ...) 
    if (smooth) 
    lines(stats::lowess(ts.intersect(stats::lag(series1,-h),series2)[,1],
                 ts.intersect(stats::lag(series1,-h),series2)[,2]), col=2, lwd=lwl)
    if (corr)
    legend("topright", legend=round(a[m1-h], digits=2), text.col=ltcol, bg=bgl, adj=.25, box.col=box.col)             
   on.exit(par(old.par))
   }
}


