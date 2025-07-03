lag1.plot <-
function(series, max.lag=1, corr=TRUE, smooth=TRUE, col=gray(.1), bg=NA,
         lwl=1, lwc=2, bgl=NULL, ltcol=1, box.col=NULL, cex=.9, gg=FALSE,
         location="topright", ...){ 

  name1   = paste(deparse(substitute(series)),"(t-",sep="")
  name2   = paste(deparse(substitute(series)),"(t)",sep="")
  max.lag = as.integer(max.lag)
  prow    = ceiling(sqrt(max.lag))
  pcol    = ceiling(max.lag/prow)
  a       = acf1(series, max.lag, plot=FALSE) 
  old.par <- par(no.readonly = TRUE)
 if (is.null(box.col)) { 
  box.col = ifelse(gg, gray(1,.7), gray(.62,.7)) 
  }
 if (is.null(bgl)) { 
  bgl = ifelse(gg, gray(.92,.6), gray(1,.6))
  }

 series = as.ts(series)
 par(mfrow = c(prow, pcol))
 if (par('cex') < .9) par(cex =.9)
 for(h in 1:max.lag){ 
   u = ts.intersect(lag(series,-h), series)
  tsplot(u[,1], u[,2], type='p', xy.labels=FALSE, xy.lines=FALSE, gg=gg,
          xlab=paste(name1,h,")",sep=""), ylab=name2, col=col, cex=cex, bg=bg, ...) 
  if (smooth) 
   lines(lowess(u[,1], u[,2]), col=lwc, lwd=lwl)
  if (corr) {  
   legend(location, legend=format(round(a[h], digits=2), nsmall=2), 
           text.col=ltcol, bg=bgl, adj=.25, box.col=box.col, cex=.8)
   if (gg) { box(col=gray(1)) } else { box(col=gray(.62)) }
 }
 on.exit(par(old.par))
}
}

