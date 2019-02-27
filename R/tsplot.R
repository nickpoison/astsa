tsplot <- function(x, y = NULL, main=NULL, ylab=NULL, xlab='Time', type='l', margins=.25, ... ){
  par = graphics::par
  plot = graphics::plot
  grid = graphics::grid
  lines = graphics::lines
  topper = ifelse(is.null(main), 0, .5)  
  if(is.null(ylab)) {ylab = ifelse(is.null(y), deparse(substitute(x)), deparse(substitute(y)))}
  par(mar=c(2.5,2.5,1+topper,.5)+margins, mgp=c(1.6,.6,0), cex.main=1.2)
  plot(x, y, type='n', main=main, ylab=ylab, xlab=xlab, ... ) 
  grid(lty=1, col=gray(.9))
  lines(x, y, type=type, ... )
  box()
  }
  