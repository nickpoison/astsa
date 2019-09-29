tsplot <- function(x, y = NULL, main=NULL, ylab=NULL, xlab='Time', type='l', margins=.25, 
                    ncolm=1, minor=TRUE, nxm=2, nym=2, col=1, ... ){
  par   = graphics::par
  plot  = graphics::plot
  lines = graphics::lines
  nser  = max(NCOL(x), NCOL(y))
  topper = ifelse(is.null(main), 0, .5) 
  old.par <- par(no.readonly = TRUE)  
  if (nser == 1) {
  if(is.null(ylab)) {ylab = ifelse(is.null(y), deparse(substitute(x)), deparse(substitute(y)))}
  par(mar=c(2.5,2.5,1+topper,.5)+margins, mgp=c(1.6,.6,0), cex.main=1.2)
  plot(x, y, type='n', main=main, ylab=ylab, xlab=xlab, ... ) 
  Grid(minor=minor, nxm=nxm, nym=nym)
  lines(x, y, type=type, col=col, ... ) 
  box()
  } else {
  prow = ceiling(nser/ncolm)
  culer = matrix(col, nser)
  par(mfrow = c(prow, ncolm), mar = c(2, 2, .5, .25)+margins, mgp = c(1.6,.6, 0), cex.lab=1.1, oma = c(0,0,3*topper,0))
  if (is.null(y)) { ylab=colnames(as.matrix(x)) } else { ylab=colnames(as.matrix(y))} 
  if (is.null(ylab)) { ylab = NA }
  for (h in 1:nser) {
    if(is.null(y)) {tsplot(x[,h], ylab=ylab[h], col=culer[h,], type=type, xlab=xlab, ...)
	} else {
	tsplot(x, y[,h], ylab=ylab[h], col=culer[h,], type=type, xlab=xlab, ...)
    }
    }  	
   mtext(text=main, line=-.5, outer=TRUE, font=2) 
   } 
on.exit(par(old.par))    
}
