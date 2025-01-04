QQnorm = 
function(xdata, col=c(4,6), ylab='Sample Quantiles', xlab='Theoretical Quantiles', 
         main="Normal Q-Q Plot", ylim=NULL, ci=TRUE, width.ci=99.995, qqlwd=1, ...){

  scat = stats::qqnorm(xdata, plot.it=FALSE)
   # check colors and CI width are valid
   if (length(col) < 2) col= rep(col,2)
   if (width.ci <=0) stop('width.ci should be greater than 0')
   if (width.ci <= 1) width.ci = 100*width.ci
   if (width.ci >= 100) width.ci = 99.995

   num  = length(xdata)
   xord = xdata[order(xdata)]
   PP   = stats::ppoints(num)
   z    = stats::qnorm(PP)
   y    = stats::quantile(xord, c(.25,.75), names=FALSE, type=7, na.rm=TRUE)
   x    = stats::qnorm(c(.25,.75))
   b    = diff(y)/diff(x)
   a    = y[1] - b*x[1]
   SE    = (b/dnorm(z))*sqrt(PP*(1-PP)/num)     
   qqfit = a + b*z
   wde   = stats::qnorm(width.ci/100)
   U     = qqfit + wde*SE   # default puts .00005 in tails
   L     = qqfit - wde*SE

# start plotting
  if (is.null(ylim)) ylim=c(min(xord[1],L[1],na.rm=TRUE), max(xord[num],U[num],na.rm=TRUE))
  tsplot(scat$x, scat$y, type='p', col=col[1], ylab=ylab, xlab=xlab, main=main, ylim=ylim, ...)
  abline(a, b, col=col[2], lwd=qqlwd)  # qqline
  if (ci){
     z[1]=z[1]-.1      # extend CI -- misses the end otherwise
     z[length(z)]= z[length(z)]+.1
     xx <- c(z, rev(z))
     yy <- c(L, rev(U))
    polygon(xx, yy, border=NA, col=gray(.5, alpha=.2) )   
  }
}