lag2.plot <-
function(series1, series2, max.lag=0, corr=TRUE, smooth=TRUE, col=gray(.1), bg=NA,
         lwl=1, lwc=2, bgl=NULL, ltcol=1, box.col=NULL, cex=.9, gg=FALSE, 
         location="topright", xname=NULL, yname=NULL, main=NULL, ...){ 
#
  if (is.null(xname)) xname = deparse(substitute(series1))
  if (is.null(yname)) yname = deparse(substitute(series2))
  name1  = paste(xname,"(t-",sep="")
  name10 = paste(xname,"(t)",sep="")
  name2  = paste(yname,"(t)",sep="")
#
  max.lag = as.integer(max.lag)
  m1      = max.lag + 1
  prow    = ceiling(sqrt(m1))
  pcol    = ceiling(m1/prow)
  a       = ccf(series1,series2,max.lag,plot=FALSE)$acf
  old.par <- par(no.readonly = TRUE)
 if (is.null(box.col)) { 
  box.col = ifelse(gg, gray(1,.7), gray(.62,.7)) 
 }
 if (is.null(bgl)) { 
  bgl = ifelse(gg, gray(.92,.6), gray(1,.6))
 }
#
  series1 = as.ts(series1)
  series2 = as.ts(series2)
 par(mfrow = c(prow,pcol))
 if (par('cex') < .8) par(cex=.8)
 if (!is.null(main)) par(oma=c(0,0,.75,0)+.1)
 for(h in 0:max.lag){       
   u = ts.intersect(lag(series1,-h), series2)   
   Xlab = ifelse(h==0, name10, paste(name1,h,")",sep="")) 
  tsplot(u[,1], u[,2], type='p', xy.labels=FALSE, xy.lines=FALSE, xlab=Xlab, 
          ylab=name2, col=col, cex=cex, gg=gg, bg=bg, ...) 
  if (smooth) 
   lines(lowess(u[,1], u[,2]), col=lwc, lwd=lwl)
  if (corr){ 
   legend(location, legend=format(round(a[m1-h], digits=2),nsmall=2), 
           text.col=ltcol, bg=bgl, adj=.25, box.col=box.col, cex=.8)
  if (gg) { box(col=gray(1)) } else { box(col=gray(.62)) }
 }
  if (!is.null(main))  title(main, outer=TRUE, line=-.10)
 on.exit(par(old.par))
}
}

