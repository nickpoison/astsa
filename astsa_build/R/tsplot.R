tsplot <- function(x, y = NULL, main=NULL, ylab=NULL, xlab='Time', type=NULL, 
                    margins=.25, ncolm=1, byrow=TRUE, minor=TRUE, nxm=2, nym=1, 
                    xm.grid=TRUE, ym.grid=TRUE, col=1, gg=FALSE, spaghetti=FALSE, 
                    pch=NULL, lty=1, lwd=1, mgpp=0, ...)
{
  nser   = max(NCOL(x), NCOL(y))
  topper = ifelse(is.null(main), 0, .5) 
  type0  = 'n' 
  type1  = ifelse(is.null(type), 'l', type)
  pch    = rep(pch, ceiling(nser/length(pch)))
  lty    = rep(lty, ceiling(nser/length(lty)))
  lwd    = rep(lwd, ceiling(nser/length(lwd)))
  oldp   = par()
  
 if(!spaghetti || nser < 2){ # no spaghetti 
 if(!gg){                    # no gris-gris
  if (nser == 1) {           # single series
   if(is.null(ylab)) {ylab = ifelse(is.null(y), deparse(substitute(x)), 
                      deparse(substitute(y)))}
   par(mar=c(2.5,2.5,1+topper,.5)+margins, mgp=c(1.6,.3,0)+mgpp, cex.main=1.2,
              tcl=-.2, cex.axis=.9)
   plot(x, y, type = type0, axes=FALSE, ann=FALSE, main=NULL, ... )
   Grid(minor=minor, nxm=nxm, nym=nym, xm.grid=xm.grid, ym.grid=ym.grid)
   par(new=TRUE)
   plot(x, y, type=type1, main=main, ylab=ylab, xlab=xlab, col=col, pch=pch, 
        lty=lty, lwd=lwd, ... ) 
   box(col='gray62')
  } else {                   # multiple series
   if(!is.null(ylab)){ ylab = rep(ylab, ceiling(nser/length(ylab))) } 
   prow = ceiling(nser/ncolm)
   culer = rep(col, nser)
   if(byrow){
   par(mfrow = c(prow, ncolm),  cex.lab=1.1, oma = c(0,0,3*topper,0))
   } else {
   par(mfcol = c(prow, ncolm), cex.lab=1.1, oma = c(0,0,3*topper,0))
   }
   if (is.null(y) & is.null(ylab) ) { ylab=colnames(as.matrix(x))}
   if (!is.null(y) & is.null(ylab) )  { ylab=colnames(as.matrix(y))} 
   for (h in 1:nser) {
    if(is.null(y)) {tsplot(x[,h], ylab=ylab[h], col=culer[h], type=type, xlab=xlab, 
                  minor=minor, nxm=nxm, nym=nym, pch=pch[h], lty=lty[h], lwd=lwd[h], ...)
    } else {
    tsplot(x, y[,h], ylab=ylab[h], col=culer[h], type=type, xlab=xlab, minor=minor, 
                               nxm=nxm, nym=nym, pch=pch[h], lty=lty[h], lwd=lwd[h], ...)
    }
    }  
   mtext(text=main, line=-.5, outer=TRUE, font=2) 
   }    
} else {                   # gris-gris ya ya 
  if (nser == 1) {         # single series
   if(is.null(ylab)) {ylab = ifelse(is.null(y), deparse(substitute(x)), 
                      deparse(substitute(y)))}
   par(mar=c(2.5,2.5,1+topper,.5)+margins, mgp=c(1.6,.3,0)+mgpp, cex.main=1.2,  
              tcl=-.2, cex.axis=.8, las=1)    
   plot(x, y, type = type0, axes=FALSE, ann=FALSE, main=NULL, ... )
   brdr = par("usr")        
   rect(brdr[1], brdr[3], brdr[2], brdr[4], col=gray(.92), border='white')         
   Grid(minor=minor, nxm=nxm, nym=nym, xm.grid=xm.grid, ym.grid=ym.grid, col='white')
   par(new=TRUE)
   plot(x, y, type=type1, main=main, ylab=ylab, xlab=xlab, col=col, pch=pch, 
         lty=lty, lwd=lwd, ... ) 
   box(col='white', lwd=2)
  } else {                 # multiple series
   if(!is.null(ylab)){ ylab = rep(ylab, ceiling(nser/length(ylab))) } 
   prow = ceiling(nser/ncolm)
   culer = rep(col, nser)
   if(byrow){
   par(mfrow = c(prow, ncolm), cex.lab=1.1, oma = c(0,.25,3*topper,0)+margins, tcl=-.2, 
         cex.axis=.9)
   } else {
   par(mfcol = c(prow, ncolm), cex.lab=1.1, oma = c(0,.25,3*topper,0)+margins, tcl=-.2, 
         cex.axis=.9)
   }
   if (is.null(y) & is.null(ylab) ) { ylab=colnames(as.matrix(x))}
   if (!is.null(y) & is.null(ylab) )  { ylab=colnames(as.matrix(y))} 
   for (h in 1:nser) {
    if(is.null(y)) {tsplot(x[,h], ylab=ylab[h], col=culer[h], type=type, xlab=xlab, 
         gg=TRUE, minor=minor, nxm=nxm, nym=nym, pch=pch[h], lty=lty[h], lwd=lwd[h], ...)
   } else {
   tsplot(x, y[,h], ylab=ylab[h], col=culer[h], type=type, xlab=xlab, gg=TRUE, 
             minor=minor, nxm=nxm, nym=nym, pch=pch[h], lty=lty[h], lwd=lwd[h], ...)
    }
    }
   mtext(text=main, line=-.5, outer=TRUE, font=2)   
  }
}   
} else {  # when spaghetti is TRUE and nser > 1
   culer = rep(col, ceiling(nser/length(col)))
   if (is.null(ylab)) { ylab = NA }
   if (is.null(y)) {
   u = x[,1]
   u[1:2] =  c(min(x, na.rm=TRUE), max(x, na.rm=TRUE))
   tsplot(u, ylab=ylab[1],  type=type0, xlab=xlab, gg=gg, minor=minor, nxm=nxm, nym=nym, 
             main=main, pch=pch[1], margins=margins, ...)
   for (h in 1:nser) { lines(x[,h], col=culer[h], type=type1, pch=pch[h], lty=lty[h], 
              lwd=lwd[h], ...) }
    } else {
   u = y[,1]
   u[1:2] =  c(min(y, na.rm=TRUE), max(y, na.rm=TRUE))
   tsplot(x, u, ylab=ylab[1], type=type0, xlab=xlab, gg=gg, minor=minor, nxm=nxm, nym=nym, 
               main=main, pch=pch[1], margins=margins, ...)
   for (h in 1:nser) { lines(x, y[,h], col=culer[h], type=type1, pch=pch[h], 
                          lty=lty[h], lwd=lwd[h], ...) }
   }
}
las = oldp$las
return(invisible(grDevices::recordPlot()))
}
