tsplot <- function(series, main=NULL, ylab=deparse(substitute(series)), ... ){
  x = as.ts(series)
  topper = ifelse(is.null(main), 0, 1)  
  par(mar=c(2.5,2.5,1+topper,.5), mgp=c(1.6,.6,0), cex.main=1.2)
  plot(x, type='n', main=main, ylab=ylab, ... ) 
  grid(lty=1, col=gray(.9))
  lines(x, ... )
  }
  
  