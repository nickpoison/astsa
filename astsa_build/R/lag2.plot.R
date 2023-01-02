lag2.plot <-
function(series1, series2, max.lag=0, corr=TRUE, smooth=TRUE, col=gray(.1),
         lwl=1, lwc=2, bgl=gray(1,.65), ltcol=1, box.col=8, cex=.9, ...){ 
#
  name1  = paste(deparse(substitute(series1)),"(t-",sep="")
  name10 = paste(deparse(substitute(series1)),"(t)",sep="")
  name2  = paste(deparse(substitute(series2)),"(t)",sep="")
#
  max.lag = as.integer(max.lag)
  m1      = max.lag + 1
  prow    = ceiling(sqrt(m1))
  pcol    = ceiling(m1/prow)
  a       = stats::ccf(series1,series2,max.lag,plot=FALSE)$acf
  old.par <- par(no.readonly = TRUE)
#
  series1 = as.ts(series1)
  series2 = as.ts(series2)
 par(mfrow = c(prow,pcol))
 for(h in 0:max.lag){       
   u = ts.intersect(stats::lag(series1,-h), series2)            
   Xlab = ifelse(h==0, name10, paste(name1,h,")",sep="")) 
  tsplot(u[,1], u[,2], type='p', xy.labels=FALSE, xy.lines=FALSE, xlab=Xlab, 
          ylab=name2, col=col, cex=cex, ...) 
  if (smooth) 
   lines(stats::lowess(u[,1], u[,2]), col=lwc, lwd=lwl)
  if (corr)
   legend("topright", legend=format(round(a[m1-h], digits=2),nsmall=2), 
           text.col=ltcol, bg=bgl, adj=.25, box.col=box.col, cex=.9)
 }
 on.exit(par(old.par))
}


