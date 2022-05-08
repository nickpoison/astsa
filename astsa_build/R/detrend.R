detrend <-
function(series, order=1, lowess=FALSE, lowspan=2/3){
    if (lowess) { 
      u = stats::lowess(series, f=lowspan)
      return(series-u$y)  
    } else {
      y = as.vector(time(series))
      u = stats::lm(series~ poly(y, order), na.action=NULL)
      return(round(resid(u),4))
    }
 }
