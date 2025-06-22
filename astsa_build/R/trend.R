trend <-
function(series, order=1, lowess=FALSE, lowspan=.75, robust=TRUE, 
          col=c(4,6), ylab=NULL, ci=TRUE, results=FALSE, ...){
  if (NCOL(series) > 1) stop("univariate time series only")
  if (length(col) < 2) col = rep(col, 2)  
    name   = deparse(substitute(series))
    if (is.null(ylab)) { ylab = name }
    series = as.ts(series)
    tspar  = tsp(series)
    if (lowess) { 
      fam  = ifelse(robust, 'symmetric', 'gaussian') 
      y    = c(series)
      x    = c(time(series)) 
      lo   = predict(loess(y ~ x, span=lowspan, family=fam), se=TRUE)
      trnd = ts(lo$fit, start=tspar[1], frequency=tspar[3])
    tsplot(series, col=col[1], ylab=ylab, ...)
    lines(trnd, col=col[2], lwd=2)
      L = lo$fit - qt(0.975, lo$df)*lo$se
      U = lo$fit + qt(0.975, lo$df)*lo$se
    if(ci){
       xx = c(x, rev(x))
       yy = c(L, rev(U))
       polygon(xx, yy, border=8, col = gray(.6, alpha=.2) ) 
      }
      invisible(cbind(trnd, L, U))  
    } else {
       x = as.vector(time(series))
       u = lm(series~ poly(x, order), na.action=NULL)
       if (results){ 
           if (order==1) {time = x; u =  lm(series~ time, na.action=NULL)} 
           uu = summary(u) 
           dimnames(uu$coefficients) <- list(names(u$coefficients), 
                  c("Estimate", "     SE", " t.value", " p.value"))
            print(round(coef(uu), 2))
            cat('Noise SE estimated as:', round(uu$sigma,2), 'on', uu$df[2], 'df', '\n')
          }
      up = predict(u, interval="confidence", level = 0.95)
      upts = ts(up, start=tspar[1], frequency=tspar[3])
      tsplot(series, col=col[1], ylab=ylab, ...)
      trnd = upts[,1]
      lines(trnd, col=col[2], lwd=2)
       if(ci){
        xx = c(x, rev(x))
        yy = c(upts[,2], rev(upts[,3]))
       polygon(xx, yy, border=8, col = gray(.6, alpha=.2) )
       } 
      invisible(upts)
    }
 }

