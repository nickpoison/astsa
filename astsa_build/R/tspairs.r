tspairs <-
    function(x, main=NA, pt.col=astsa.col(4,.6), pch=20, pt.size=1.1, lab.size=1.25, 
             title.size=1.5,scale=1, corr=TRUE, smooth=TRUE, lwl=1, lwc=2, gg=FALSE, 
             hist.diag=TRUE, col.diag=4, ...)
{
    plot.new()
    old.par <- par(no.readonly = TRUE)
    nser <- NCOL(x)
    colnames(x) = colnames(x, do.NULL=FALSE, prefix= "Ser.") 
    if (nser < 2) stop('need at least 2 series')
    topper = ifelse(is.na(main),0,2) 
    Corr = cor(x)
    par(mfrow = c(nser, nser), mgp=c(1.6,.6,0), mar=c(0,0,0,0)+.5,
         oma =  c(.25,.25,0+topper,0))
    par(cex = par('cex')*scale)   
   for (j in 1:nser) for (i in 1:nser) {
      if (i==j) {      
        if (hist.diag) {
          xh <- hist(x[,i], plot = FALSE) 
          tsplot(xh$mids, xh$counts, ylab=NA, xlab=NA, type='n', gg=gg, 
            main=NA, minor=FALSE, ...)
         hist(x[,i], col=grDevices::adjustcolor(col.diag,.5), border=col.diag, add=TRUE)
         } else {
        tsplot(x[,i], ylab=NA, xlab=NA, col=col.diag, gg=gg, main=NA, ...)
        box(col=gray(1)) 
        }
       } else {
       tsplot(x[,i], x[,j], type='p', pch=pch, xlab=NA, ylab=NA, 
              margins=c(0,0,-.8,0)+.2, col=pt.col, cex=pt.size, gg=gg, ...) 
      if (smooth) { lines(stats::lowess(x[,i], x[,j]), col=lwc, lwd=lwl) }
      if (corr) {
       if (gg) { boxc=gray(1,.7); bgc=gray(.92,.8) 
                } else { boxc=gray(.62,.3); bgc=gray(1,.8) }
        legend("topright", legend=format(round(Corr[i,j], digits=2), nsmall=2),  
                box.col=boxc, bg=bgc, cex=.9*scale, adj=.25) 
      }
      if (gg) { box(col=gray(.8)) } else { box(col=gray(.62)) } 
   }
      if (i == 1) {
       title(ylab=colnames(x)[j], xpd = NA, cex.lab=lab.size )  }
      if (j == nser) {
       title(xlab=colnames(x)[i], xpd = NA, cex.lab=lab.size) }
      mtext(main, side=3, line=0, outer=TRUE, font = 1, cex=title.size*scale)
  } 
      on.exit(par(old.par))
}


## an example if want to use lagged variables
# tspairs(ts.intersect(cmort,tempr, partL4=lag(part,-4)),pt=1.1 ,gg=T,  scale=1.1)
