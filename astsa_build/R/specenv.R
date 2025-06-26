specenv <-
function(xdata, section=NULL, spans=NULL, kernel=NULL, taper=0, 
          significance=.0001, plot=TRUE, ylim=NULL, real=FALSE, ...){           
 # data check 
  if (real) {
   if (ncol(xdata)<2)  stop("For continuous data, the input 'xdata' must be a matrix")
   if (is.null(section)) { x = xdata } else {
       if (!all(as.integer(diff(section))==1) && !is.integer(section))
       stop("'section' must be consecutive indices of the form 'start:end'") 
     x = xdata[section,] 
    }	 
  } else {
   if ( !is.matrix(xdata) || !all(xdata %in% c(0,1)) || !all(rowSums(xdata)==1) ) 
     stop("Input must be indicators, use 'dna2vector' to preprocess the data.")
   if  (is.null(section)) { x = xdata[,-ncol(xdata)] 
    } else {
       if (!all(as.integer(diff(section))==1) && !is.integer(section))
       stop("'section' must be consecutive indices of the form 'start:finish'") 
      x = xdata[section,-ncol(xdata)]
    }
   }  	
xspec = mvspec(x, spans=spans, kernel=kernel, taper=taper, detrend=FALSE, plot=FALSE)  
fxxr  = Re(xspec$fxx)  # fxxr is real(fxx) 
Var   = var(x)  # var-cov matrix 
Q     = Var %^% -.5

# compute spec env and scale vectors     
num     = xspec$n.used  # sample size used for FFT
nfreq   = length(xspec$freq)  # number of freqs used   
specenv = matrix(0,nfreq,1)   # initialize the spec envelope
beta    = matrix(0, nfreq, ncol(x))   # initialize the scale vectors
 
for (k in 1:nfreq){ 
  ev = eigen(2*Q%*%fxxr[,,k]%*%Q/num, symmetric=TRUE)   
  specenv[k] = ev$values[1]   # spec env at freq k/n is max evalue
  b = Q%*%ev$vectors[,1]      # beta at freq k/n 
  beta[k,] = b/sqrt(sum(b^2)) # helps to normalize beta
} 
if (!real){  
beta = cbind(beta, 0)  # add 0s for last state
} 
frequency = xspec$freq

# graphics  
if (plot){  
# threshold
m = xspec$kernel$m
etainv = ifelse(m>0, sqrt(sum(xspec$kernel[-m:m]^2)), 1)
if (is.na(significance)) { thresh=0
 } else {
thresh = 100*(2/num)*exp(qnorm(1-significance)*etainv)*rep(1,nfreq)
 }
if (is.null(ylim)) ylim = c(0, max(max(100*specenv), thresh))
tsplot(frequency, 100*specenv, type="l", ylab="Spectral Envelope (%)", xlab="frequency", ylim=ylim, ...)
if (any(thresh > 0)) lines(frequency, thresh, lty="dashed", col=4)
}
# details 
output = cbind(frequency, specenv, beta)
colnames(output) = c("freq","specenv", sprintf("coef[%d]", 1:ncol(xdata)) )
invisible(output)
}
