QQnorm = 
function(xdata, col=c(4,6), ylab='Sample Quantiles', xlab='Theoretical Quantiles', 
         main="Normal Q-Q Plot", ylim=NULL, ci=TRUE, qqlwd=1, ...){


  if (ci < 0) { ci=FALSE 
     cat('Really? You want a negative confidence level? \nIn that case, you get no CI at all!\n') }
  xdata = c(xdata)
  scat  = qqnorm(xdata, plot.it=FALSE)
  if (length(col) < 2) col= rep(col,2)
 
   num  = length(xdata)
   xord = xdata[order(xdata)]
   PP   = ppoints(num)
   z    = qnorm(PP)
   y    = quantile(xord, c(.25,.75), names=FALSE, type=7, na.rm=TRUE)
   x    = qnorm(c(.25,.75))
   b    = diff(y)/diff(x)
   a    = y[1] - b*x[1]
   SE   = (b/dnorm(z))*sqrt(PP*(1-PP)/num)     
   qqfit = a + b*z
 
  if (ci>0){
   # check CI width is valid
   if (ci < 1) ci = 100*ci
   if (ci >= 100 | isTRUE(ci))  ci = 99.99    # default
   ci    = ifelse(ci > 50, (100 - ci)/2, ci/2)
   wde   = qnorm(ci/100, lower.tail=FALSE)
   U     = qqfit + wde*SE   
   L     = qqfit - wde*SE
   if (is.null(ylim)) ylim=c(min(xord[1],L[1],na.rm=TRUE), max(xord[num],U[num],na.rm=TRUE))
   tsplot(scat$x, scat$y, type='p', col=col[1], ylab=ylab, xlab=xlab, main=main, ylim=ylim, ...)
   abline(a, b, col=col[2], lwd=qqlwd)  # qqline
     z[1]=z[1]-.1      # extend CI -- misses the end otherwise
     z[length(z)]= z[length(z)]+.1
     xx <- c(z, rev(z))
     yy <- c(L, rev(U))
    polygon(xx, yy, border=NA, col=gray(.5, alpha=.2) )   
  } else { # no ci
  if (is.null(ylim)) ylim=c(min(xord[1],qqfit[1],na.rm=TRUE), max(xord[num],qqfit[num],na.rm=TRUE))
  tsplot(scat$x, scat$y, type='p', col=col[1], ylab=ylab, xlab=xlab, main=main, ylim=ylim, ...)
  abline(a, b, col=col[2], lwd=qqlwd)  # qqline
}
}