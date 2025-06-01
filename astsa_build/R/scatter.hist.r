scatter.hist <- 
function(x, y, xlab = NULL, ylab = NULL, title = NULL, 
         pt.size = 1, hist.col = gray(.82), pt.col = gray(.1,.25), 
         pch = 19, reset.par = TRUE, ...){
  
# orig par
  old.par <- par(no.readonly = TRUE)
 
  if (is.null(xlab)) xlab= deparse(substitute(x))
  if (is.null(ylab)) ylab= deparse(substitute(y))
  
  if (is.null(title)){
   zones <- matrix(c(0,4,0, 1,5,3, 0,2,0), ncol = 3, byrow = TRUE)
   layout(zones, widths=c(0.3,4,1), heights = c(3,10,.75))
   } else {
   zones <- matrix(c(1,1,1, 0,5,0, 2,6,4, 0,3,0), ncol = 3, byrow = TRUE)
   layout(zones, widths=c(0.3,4,1), heights = c(1,3,10,.75))
   }

  xc    <- hist(x, plot = FALSE)$count
  yc    <- hist(y, plot = FALSE)$count
  top   <- max(xc, yc)

 par(xaxt="n", yaxt="n", bty="n", mar = c(.3,2,.3,0) +.05)

  # title
  if (!is.null(title)){
    plot(x=1,y=1,type="n",ylim=c(-1,1), xlim=c(-1,1))
    text(0,0,paste(title), cex=2)
  }	
  # fig 
  plot(x=1,y=1,type="n",ylim=c(-1,1), xlim=c(-1,1))
  text(0,0,ylab, cex=1.5, srt=90)
  # fig 
  plot(x=1,y=1,type="n",ylim=c(-1,1), xlim=c(-1,1))
  text(0,0,xlab, cex=1.5)
  # fig 
  par(mar = c(2,0,1,1))
  barplot(yc, axes = FALSE, xlim = c(0, top), 
          space = 0, horiz = TRUE, col=hist.col)
  # fig 
  par(mar = c(0,2,1,1))
  barplot(xc, axes = FALSE, ylim = c(0, top), space = 0, col=hist.col)
  # fig 
  par(mar = c(2,2,.5,.5), xaxt="s", yaxt="s", bty="n")
  plot(x, y, type='n')
  Grid(...)
  points(x, y, pch=pch, col=pt.col, cex=pt.size)
  # reset the graphics, if desired 
  if(reset.par) {par(old.par)}
}
