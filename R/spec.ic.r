spec.ic = 
function(data, BIC=FALSE, order.max=30, main=NULL, plot=TRUE, 
           detrend=FALSE, method=NULL, ...){
  if (is.null(method)) {method='yw'}	   
  nme1 = paste("Series:", deparse(substitute(data)))
  nme2 = ifelse(BIC,'BIC','AIC')  
  if (detrend) { data = resid(lm(data~time(data), na.action=NULL)); dmean = FALSE
  } else { dmean = TRUE } 	
  u    = stats::ar(data, order=order.max, aic=TRUE, method=method, demean=dmean)	
  aic  = as.vector(u$aic) 
  bic  = aic - 2*(0L:order.max) + (0L:order.max)*log(length(data)) 
  bic  = bic - min(bic)  
  kmin = ifelse(BIC, which.min(bic)-1, which.min(aic)-1)
  if (kmin < 1) { kmin=NULL 
    if (plot){
     if (is.null(main)) {main=paste(nme1,"  |  ",nme2," order = ",0)}
     arma.spec(var.noise=var(data), main=main, ...)
    }
  }	
  u    = stats::ar(data, order=kmin, aic=FALSE, method=method, demean=dmean)
  u2   = stats::spec.ar(u, plot=FALSE)
 if (plot & !is.null(kmin)){
  if (is.null(main)) {main = paste(nme1,"  |  ",nme2," order = ", kmin, sep="")}
  arma.spec(ar=u$ar, var.noise=var(data), main=main, ...)
  }	
  out1 = cbind(ORDER=(0L:order.max), AIC=aic, BIC=bic)
  out2 = cbind(freq=u2$freq, spec=u2$spec) 
 return(invisible(list(out1, out2)))
} 
