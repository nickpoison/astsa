spec.ic = 
function(data, BIC=FALSE, order.max=30, main=NULL, plot=TRUE, 
           detrend=FALSE, method=NULL, ...){
  lm = stats::lm
  resid = stats::resid
  rnorm = stats::rnorm
  var = stats::var  
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
  if (kmin < 1){
    freq = seq.int(0, 0.5, length.out = 500)*frequency(data)
    spec = var(data)*rep(1,500)
    out2 = cbind(freq,spec)
    if (plot){
     if (is.null(main)) {main=paste(nme1,"  |  ",nme2," order = ",0)} 
     tsplot(freq, spec, ylab='AR Spectrum', xlab='Frequency', margins=.5, 
         main=main, cex.axis=.85, las=0, ...)
    }  	  
   } else {
    u    = stats::ar(data, order=kmin, aic=FALSE, method=method, demean=dmean)
    u2   = stats::spec.ar(u, plot=FALSE)	
    out2 = cbind(freq=u2$freq, spec=u2$spec) 
    if(plot){
     if (is.null(main)) {main = paste(nme1,"  |  ",nme2," order = ", kmin, sep="")}
     tsplot(u2$freq, u2$spec, ylab='AR Spectrum', xlab='Frequency', margins=.5, 
         main=main, cex.axis=.85, las=0, ...) 
    }
   }		 
 out1 = cbind(ORDER=(0L:order.max), AIC=aic, BIC=bic)
 return(invisible(list(out1, out2)))
} 
