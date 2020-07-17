spec.ic = 
function(data, BIC=FALSE, order.max=30, main=NULL, plot=TRUE, 
           detrend=FALSE, method=NULL, ...){
  if (is.null(method)) {method='yw'}	   
  nme1 = paste("Series:", deparse(substitute(data)))	
  if (detrend) { data = resid(lm(data~time(data), na.action=NULL)); dmean = FALSE
  } else { dmean = TRUE } 		  
  aic  = as.vector(stats::ar(data, order=order.max, aic=TRUE, method=method, demean=dmean)$aic) 
  bic  = aic - 2*(0L:order.max) + (0L:order.max)*log(length(data)) 
  bic  = bic - min(bic)  
  kmin = ifelse(BIC, which.min(bic)-1, which.min(aic)-1)
  u    = stats::ar.mle(data, order=kmin, aic=FALSE)
  u2   = stats::spec.ar(u, plot=FALSE)
 if (plot){
  nme2 = ifelse(BIC,'BIC','AIC')
  if (is.null(main)) {main = paste(nme1,"  |  ",nme2," order = ", kmin, sep="")}
  tsplot(u2$freq, u2$spec, ylab='AR Spectrum', xlab='Frequency', margins=.5, 
         main=main, cex.axis=.85, las=0, ...)
  }		
  out1 = cbind(ORDER=(0L:order.max), AIC=aic, BIC=bic)
  out2 = cbind(freq=u2$freq, spec=u2$spec) 
 return(invisible(list(out1, out2)))
}
  