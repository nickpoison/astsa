spec.ic =
function(xdata, BIC=FALSE, order.max=30, main=NULL, plot=TRUE, 
           detrend=FALSE, method=NULL, ...){
  if (is.null(method)) {method='yw'}   
  
  nme1  = paste('Series:', deparse(substitute(xdata)))
  nme2  = ifelse(BIC,'BIC','AIC')  
  
  if (detrend) { xdata = detrend(xdata); dmean = FALSE
        } else { dmean = TRUE } 
  
  u    = stats::ar(xdata, order=order.max, aic=TRUE, method=method, demean=dmean) 
  aic  = as.vector(u$aic) 
  bic  = aic - 2*(0L:order.max) + (0L:order.max)*log(length(xdata)) 
  bic  = bic - min(bic)  
  kmin = ifelse(BIC, which.min(bic)-1, which.min(aic)-1)
  
  if (kmin < 1){
    freq = seq.int(0, 0.5, length.out = 500)*frequency(xdata)
    spec = var(xdata)*rep(1,500)
    out2 = cbind(freq, spec)
     if (plot){
      if (is.null(main)) {main=paste(nme1,"  |  ",nme2," order = ",0)} 
         tsplot(freq, spec, ylab='AR Spectrum', xlab='Frequency', margins=.5, 
           main=main, cex.axis=.85, las=0, cex.main=1, cex.lab=.9, ...)
     } 
   } else {
    u2   = stats::spec.ar(xdata, order=kmin, plot=FALSE)
    out2 = cbind(freq=u2$freq, spec=c(u2$spec)) 
     if(plot){
      if (is.null(main)) {main = paste(nme1,"  |  ",nme2," order = ", kmin, sep="")}
         tsplot(u2$freq, u2$spec, ylab='AR Spectrum', xlab='Frequency', margins=.5, 
           main=main, cex.axis=.85, las=0, cex.main=1, cex.lab=.9, ...) 
    }
   } 
 out1 = cbind(ORDER=(0L:order.max), AIC=aic, BIC=bic)
 return(invisible(list(out1, out2)))
} 
