detrend <-
function(series, order=1, lowess=FALSE, lowspan=2/3){
  if (NCOL(series) > 1) stop("univariate time series only")
    if (lowess) { 
      u = stats::lowess(series, f=lowspan)
      return(series-u$y)  
    } else {
      y = as.vector(time(series))
      u = stats::lm(series~ poly(y, order), na.action=NULL)
      return(resid(u))
    }
 }
