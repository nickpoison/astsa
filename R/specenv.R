specenv <-
function(xdata, section=NULL, spans=NULL, significance=.0001, plot=TRUE){
 # data check 
  if ( !is.matrix(xdata) || !all(xdata %in% c(0,1)) || !all(rowSums(xdata)==1) ) 
     stop("Input must be indicators, use 'dna2vector' to preprocess the data.")
  if  (is.null(section)) { x = xdata[,-ncol(xdata)] 
    } else {
      if (!all(diff(section))==1) 
       stop("'section' must be consecutive indices of the form 'start:finish'") 
      x = xdata[section,-ncol(xdata)]
    } 
xspec = mvspec(x, spans=spans, detrend=FALSE, plot=FALSE)  
fxxr  = Re(xspec$fxx)  # fxxr is real(fxx) 
Var   = stats::var(x)  # var-cov matrix 
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
beta = cbind(beta, 0) # add 0s for last state
frequency = xspec$freq

# graphics  
if (plot){  
# threshold
m = xspec$kernel$m
etainv = sqrt(sum(xspec$kernel[-m:m]^2))
if (is.na(significance)) { thresh=0
 } else {
thresh = 100*(2/num)*exp(qnorm(1-significance)*etainv)*rep(1,nfreq)
 }
ylimm = c(0, max(max(100*specenv), thresh))
tsplot(frequency, 100*specenv, type="l", ylab="Spectral Envelope (%)", xlab="frequency", ylim=ylimm)
if (any(thresh > 0)) lines(frequency, thresh, lty="dashed", col="blue")
}
# details 
output = cbind(frequency, specenv, beta)
colnames(output) = c("freq","specenv", sprintf("coef[%d]", 1:ncol(xdata)) )
invisible(output)
}
