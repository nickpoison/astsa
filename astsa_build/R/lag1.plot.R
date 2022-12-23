lag1.plot <-
function(series, max.lag=1, corr=TRUE, smooth=TRUE, col=gray(.1), 
         lwl=1, lwc=2, bgl=gray(1,.65), ltcol=1, box.col=8, cex=.9, ...){ 
  #
  as.ts = stats::as.ts
  par   = graphics::par
  plot  = graphics::plot
  lines = graphics::lines
  ts.intersect = stats::ts.intersect
  legend = graphics::legend
  #
  name1 = paste(deparse(substitute(series)),"(t-",sep="")
  name2 = paste(deparse(substitute(series)),"(t)",sep="")
  max.lag = as.integer(max.lag)
  prow = ceiling(sqrt(max.lag))
  pcol = ceiling(max.lag/prow)
  a = stats::acf(series,max.lag,plot=FALSE)$acf[-1]
  old.par <- par(no.readonly = TRUE)

 par(mfrow=c(prow,pcol))
 for(h in 1:max.lag){
  tsplot(stats::lag(series,-h), series, type='p', xy.labels=FALSE, 
          xlab=paste(name1,h,")",sep=""), ylab=name2, col=col, cex=cex, ...) 
   if (smooth) 
   lines(stats::lowess(ts.intersect(stats::lag(series,-h),series)[,1],
                ts.intersect(stats::lag(series,-h),series)[,2]), col=lwc, lwd=lwl)
   if (corr)
   legend("topright", legend=round(a[h], digits=2), text.col=ltcol, bg=bgl, 
           adj=.25, box.col=box.col, cex=.9)
 }
 on.exit(par(old.par))
}

