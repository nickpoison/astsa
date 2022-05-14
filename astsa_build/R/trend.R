trend <-
function(series, order=1, lowess=FALSE, lowspan=2/3, col=c(4,6), ylab=NULL, ...){
  if (NCOL(series) > 1) stop("univariate time series only")
    name   = deparse(substitute(series))
    if (is.null(ylab)) { ylab = name }
    series = as.ts(series)
    tspar  = tsp(series)
    if (lowess) { 
      y    = c(series)
      x    = c(time(series)) 
      lo   = stats::predict(stats::loess(y ~ x, span=lowspan), se=TRUE)
      trnd = ts(lo$fit, start=tspar[1], frequency=tspar[3])
    tsplot(series, col=col[1], ylab=ylab, ...)
    lines(trnd, col=col[2], lwd=2)       
        L = lo$fit - qt(0.975, lo$df)*lo$se
        U = lo$fit + qt(0.975, lo$df)*lo$se
        xx = c(x, rev(x))
        yy = c(L, rev(U))
      polygon(xx, yy, border=8, col = gray(.6, alpha=.2) ) 
      invisible(cbind(trnd, L, U))  
    } else {
      x = as.vector(time(series))
      u = stats::lm(series~ poly(x, order), na.action=NULL)
      up = stats::predict(u, interval="confidence", level = 0.95)
      upts = ts(up, start=tspar[1], frequency=tspar[3])
      tsplot(series, col=col[1], ylab=ylab, ...)
      trnd = upts[,1]
      lines(trnd, col=col[2], lwd=2)
        xx = c(x, rev(x))
        yy = c(upts[,2], rev(upts[,3]))
      polygon(xx, yy, border=8, col = gray(.6, alpha=.2) ) 
      invisible(upts)
    }
 }
