spec.ic =
function(xdata, BIC=FALSE, order.max=NULL, main=NULL, plot=TRUE, detrend=TRUE, 
         lowess=FALSE, method=NULL, cex.main=NULL, xlab=NULL, ...){
  if (is.null(method)) {method='yw'}   
  
  nme1  = paste('Series:', deparse(substitute(xdata)))
  nme2  = ifelse(BIC,'BIC','AIC')
  
  if (detrend) { xdata = detrend(xdata, lowess=lowess); dmean = FALSE
        } else { dmean = TRUE } 
  if (is.null(order.max)) order.max = min(100, ceiling(.1*length(xdata)))
  
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
      if (is.null(cex.main)) cex.main=1
      if (is.null(main)) {main=paste(nme1,"  |  ",nme2," order = ",0)} 
         tsplot(freq, spec, ylab='AR Spectrum', xlab='Frequency',   
           main=main, cex.axis=.85, las=0, cex.lab=.9, cex.main=cex.main,...)
     } 
   } else {
    u2   = stats::spec.ar(xdata, order=kmin, plot=FALSE)
    out2 = cbind(freq=u2$freq, spec=c(u2$spec)) 
     if(plot){
      xfreq <- frequency(x)
      if (is.null(cex.main)) cex.main=1
      if (is.null(main)) {main = paste(nme1,"  |  ",nme2," order = ", kmin, sep="")}
      if (is.null(xlab)) xlab = ifelse(xfreq>1, paste('Frequency', expression('\u00D7'), xfreq), 'Frequency')
         tsplot(u2$freq, u2$spec, ylab='AR Spectrum', xlab=xlab, 
           main=main, cex.axis=.85, las=0, cex.lab=.9, cex.main=cex.main,...) 
    }
   } 
 out1 = cbind(ORDER=(0L:order.max), AIC=aic, BIC=bic)
 return(invisible(list(out1, out2)))
} 
