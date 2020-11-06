 tsplot <- function(x, y = NULL, main=NULL, ylab=NULL, xlab='Time', type=NULL, 
                   margins=.25, ncolm=1, byrow=TRUE, minor=TRUE, nxm=2, nym=2, 
				   col=1, gg=FALSE, ...)
{
  par   = graphics::par
  plot  = graphics::plot
  lines = graphics::lines
  nser  = max(NCOL(x), NCOL(y))
  topper = ifelse(is.null(main), 0, .5) 
  type0 <- 'n' 
  type1 <- ifelse(is.null(type), 'l', type)
 if(!gg){
  if (nser == 1) {
   if(is.null(ylab)) {ylab = ifelse(is.null(y), deparse(substitute(x)), deparse(substitute(y)))}
   par(mar=c(2.5,2.5,1+topper,.5)+margins, mgp=c(1.6,.6,0), cex.main=1.2)
   plot(x, y, type = type0, axes=FALSE, ann=FALSE, main=NULL, ... )
   Grid(minor=minor, nxm=nxm, nym=nym)
   par(new=TRUE)
   plot(x, y, type=type1, main=main, ylab=ylab, xlab=xlab, col=col, ... ) 
   box(col='gray')
  } else {
   prow = ceiling(nser/ncolm)
   culer = matrix(col, nser)
   if(byrow){
   par(mfrow = c(prow, ncolm),  cex.lab=1.1, oma = c(0,0,3*topper,0))
   } else {
   par(mfcol = c(prow, ncolm), cex.lab=1.1, oma = c(0,0,3*topper,0))
   }
   if (is.null(y)) { ylab=colnames(as.matrix(x)) } else { ylab=colnames(as.matrix(y))} 
   if (is.null(ylab)) { ylab = NA }
   for (h in 1:nser) {
    if(is.null(y)) {tsplot(x[,h], ylab=ylab[h], col=culer[h,], type=type, xlab=xlab, minor=minor, nxm=nxm, nym=nym, ...)
	} else {
	tsplot(x, y[,h], ylab=ylab[h], col=culer[h,], type=type, xlab=xlab, minor=minor, nxm=nxm, nym=nym, ...)
    }
    }  	
   mtext(text=main, line=-.5, outer=TRUE, font=2) 
   }    
} else { 
  if (nser == 1) {
   if(is.null(ylab)) {ylab = ifelse(is.null(y), deparse(substitute(x)), deparse(substitute(y)))}
   par(mar=c(2.5,2.6,1+topper,.5)+margins, mgp=c(1.8,.6,0), cex.main=1.2,  tcl=-.2, las=1, cex.axis=.9)    
   plot(x, y, type = type0, axes=FALSE, ann=FALSE, main=NULL, ... )
   brdr = par("usr")        
   rect(brdr[1], brdr[3], brdr[2], brdr[4], col=gray(.9,.9), border='white')         
   Grid(minor=minor, nxm=nxm, nym=nym, col='white')
   par(new=TRUE)
   plot(x, y, type=type1, main=main, ylab=ylab, xlab=xlab, col=col, ... ) 
   box(col=gray(1))
  } else {
   prow = ceiling(nser/ncolm)
   culer = matrix(col, nser)
   if(byrow){
   par(mfrow = c(prow, ncolm), cex.lab=1.1, oma = c(0,.25,3*topper,0), tcl=-.2, las=1, cex.axis=.9)
   } else {
   par(mfcol = c(prow, ncolm), cex.lab=1.1, oma = c(0,.25,3*topper,0), tcl=-.2, las=1, cex.axis=.9)
   }
   if (is.null(y)) { ylab=colnames(as.matrix(x)) } else { ylab=colnames(as.matrix(y))} 
   if (is.null(ylab)) { ylab = NA }
   for (h in 1:nser) {
    if(is.null(y)) {tsplot(x[,h], ylab=ylab[h], col=culer[h,], type=type, xlab=xlab, gg=TRUE, minor=minor, nxm=nxm, nym=nym,...)
	} else {
	tsplot(x, y[,h], ylab=ylab[h], col=culer[h,], type=type, xlab=xlab, gg=TRUE, minor=minor, nxm=nxm, nym=nym, ...)
    }
    }  	
   mtext(text=main, line=-.5, outer=TRUE, font=2) 
   }    
}
}