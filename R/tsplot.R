tsplot <- function(x, y = NULL, main=NULL, ylab=NULL, xlab='Time', type='l', margins=.25, 
                   minor=TRUE, nxm=2, nym=2, ... ){
  par = graphics::par
  plot = graphics::plot
  lines = graphics::lines
  topper = ifelse(is.null(main), 0, .5)  
  if(is.null(ylab)) {ylab = ifelse(is.null(y), deparse(substitute(x)), deparse(substitute(y)))}
  par(mar=c(2.5,2.5,1+topper,.5)+margins, mgp=c(1.6,.6,0), cex.main=1.2)
  plot(x, y, type='n', main=main, ylab=ylab, xlab=xlab, ... ) 
  Grid(minor=minor, nxm=nxm, nym=nym)
  lines(x, y, type=type, ... )
  box()
  }
  