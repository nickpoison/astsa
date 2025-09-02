tsplot <- function(x, y = NULL, main=NULL, ylab=NULL, xlab='Time', type=NULL, 
                    margins=.25, ncolm=1, byrow=TRUE, nx = NULL, ny = nx, 
                    minor=TRUE, nxm=2, nym=1, xm.grid=TRUE, ym.grid=TRUE, col=1, 
                    gg=FALSE, spaghetti=FALSE, pch=NULL, lty=1, lwd=1, mgpp=0, 
                    topper=NULL, addLegend=FALSE, location='topright', boxit=TRUE,
                    horiz=FALSE, legend=NULL, llwd=NULL, scale=1, reset.par = TRUE, ...)
{
  old.par <- par(no.readonly = TRUE)    # orig parameters
  nser   = max(NCOL(x), NCOL(y))
  if (is.null(topper)){
  topper = ifelse(is.null(main), 0, .5) } 
  type0  = 'n' 
  type1  = ifelse(is.null(type), 'l', type)
  pch    = rep(pch, ceiling(nser/length(pch)))
  lty    = rep(lty, ceiling(nser/length(lty)))
  lwd    = rep(lwd, ceiling(nser/length(lwd)))
  if (is.na(any(nx))) nxm=0
  if (is.na(any(ny))) nym=0
  
 if(!spaghetti || nser < 2){ # no spaghetti 
 if(!gg){                    # no gris-gris
  if (nser == 1) {           # single series
   if(is.null(ylab)) {ylab = ifelse(is.null(y), deparse(substitute(x)), 
                      deparse(substitute(y)))}
   par(mar=c(2.5,2.5,1+topper,.5)+margins, mgp=c(1.6,.3,0)+mgpp, cex.main=1.2,
              tcl=-.2, cex.axis=.9)
   plot(x, y, type = type0, axes=FALSE, ann=FALSE, main=NULL, ... )
   Grid(nx=nx, ny=ny, minor=minor, nxm=nxm, nym=nym, xm.grid=xm.grid, ym.grid=ym.grid)
   par(new=TRUE)
   plot(x, y, type=type1, main=main, ylab=ylab, xlab=xlab, col=col, pch=pch, 
        lty=lty, lwd=lwd, ... ) 
   box(col='gray62')
  } else {                   # multiple series
   if(!is.null(ylab)){ ylab = rep(ylab, ceiling(nser/length(ylab))) } 
   prow = ceiling(nser/ncolm)
   culer = rep(col, nser)
   if(byrow){
   par(mfrow = c(prow, ncolm),  cex.lab=1.1, oma = c(0,0,3*topper,0)+margins)
   } else {
   par(mfcol = c(prow, ncolm), cex.lab=1.1, oma = c(0,0,3*topper,0)+margins )
   }
  par(cex=.9*scale)
   if (is.null(y) & is.null(ylab) ) { ylab=colnames(as.matrix(x))}
   if (!is.null(y) & is.null(ylab) )  { ylab=colnames(as.matrix(y))} 
   for (h in 1:nser) {
    if(is.null(y)) {tsplot(x[,h], ylab=ylab[h], col=culer[h], type=type, xlab=xlab, 
                  nx=nx, ny=ny, minor=minor, nxm=nxm, nym=nym, pch=pch[h], lty=lty[h], lwd=lwd[h], ...)
    } else {
    tsplot(x, y[,h], ylab=ylab[h], col=culer[h], type=type, xlab=xlab, minor=minor, 
                     nx=nx, ny=ny, nxm=nxm, nym=nym, pch=pch[h], lty=lty[h], lwd=lwd[h], ...)
    }
    }  
   mtext(text=main, line=-.5, outer=TRUE, font=2) 
   if(reset.par) {par(old.par)}
   }    
} else {                   # gris-gris ya ya 
  if (nser == 1) {         # single series
   if(is.null(ylab)) {ylab = ifelse(is.null(y), deparse(substitute(x)), 
                      deparse(substitute(y)))}
   par(mar=c(2.5,2.5,1+topper,.5)+margins, mgp=c(1.6,.3,0)+mgpp, cex.main=1.2,  
              tcl=-.2, cex.axis=.8)    
   plot(x, y, type = type0, axes=FALSE, ann=FALSE, main=NULL, ... )
   brdr = par("usr")        
   rect(brdr[1], brdr[3], brdr[2], brdr[4], col=gray(.92), border='white')         
   Grid(nx=nx, ny=ny, minor=minor, nxm=nxm, nym=nym, xm.grid=xm.grid, ym.grid=ym.grid, col='white')
   par(new=TRUE)
   plot(x, y, type=type1, main=main, ylab=ylab, xlab=xlab, col=col, pch=pch, 
         lty=lty, lwd=lwd, las=1, ... ) 
   box(col='white', lwd=2)
  } else {                 # multiple series
   if(!is.null(ylab)){ ylab = rep(ylab, ceiling(nser/length(ylab))) } 
   prow = ceiling(nser/ncolm)
   culer = rep(col, nser)
   if(byrow){
   par(mfrow = c(prow, ncolm), cex.lab=1.1, oma = c(0,.25,3*topper,0)+margins, tcl=-.2, 
         cex.axis=.9, cex=.9*scale)
   } else {
   par(mfcol = c(prow, ncolm), cex.lab=1.1, oma = c(0,.25,3*topper,0)+margins, tcl=-.2, 
         cex.axis=.9, cex=.9*scale)
   }
par(cex=.9*scale)
   if (is.null(y) & is.null(ylab) ) { ylab=colnames(as.matrix(x))}
   if (!is.null(y) & is.null(ylab) )  { ylab=colnames(as.matrix(y))} 
   for (h in 1:nser) {
    if(is.null(y)) {tsplot(x[,h], ylab=ylab[h], col=culer[h], type=type, xlab=xlab, 
         gg=TRUE, nx=nx, ny=ny, minor=minor, nxm=nxm, nym=nym, pch=pch[h], lty=lty[h], lwd=lwd[h], ...)
   } else {
   tsplot(x, y[,h], ylab=ylab[h], col=culer[h], type=type, xlab=xlab, gg=TRUE, nx=nx, ny=ny,
             minor=minor, nxm=nxm, nym=nym, pch=pch[h], lty=lty[h], lwd=lwd[h], ...)
    }
    }
   mtext(text=main, line=-.5, outer=TRUE, font=2)  
   if(reset.par) {par(old.par)} 
  }
}   
} else {  # when spaghetti is TRUE and nser > 1
   culer = rep(col, ceiling(nser/length(col)))
   if (is.null(ylab)) { ylab = NA }
   if (is.null(y)) {
   u = x[,1]
   u[1:2] =  c(min(x, na.rm=TRUE), max(x, na.rm=TRUE))
   tsplot(u, ylab=ylab[1],  type=type0, xlab=xlab, gg=gg, nx=nx, ny=ny, minor=minor, nxm=nxm, nym=nym, 
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
  if (addLegend){ 
    if (is.null(legend)){
      if (is.null(y)){ namez = colnames(as.matrix(x))
       } else { namez = colnames(as.matrix(y))
      }
     } else {
      namez = legend
     }
   if (gg) { box.col=gray(1,.7); bg=gray(.92,.8) } else { box.col=gray(.62,.3); bg=gray(1,.8) }
   if (boxit) bty='o' else bty='n'
   if (!is.null(llwd)) lwd=llwd 
   legend(location, legend=namez, lty=lty, col=col, bty=bty, box.col=box.col, bg=bg,
          lwd=lwd, pch=pch, horiz=horiz, cex=.9) 
  }
    if (gg) { box(col=gray(1)) } else { box(col=gray(.62)) }
}
return(invisible(recordPlot()))
}
