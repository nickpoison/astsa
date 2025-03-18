ar.boot = function(series, order.ar, nboot=500, seed=NULL, plot=TRUE, ...){

ar.yw   = stats::ar.yw
na.omit = stats::na.omit
num     = length(series)

# estimate parameters
tspar  = stats::tsp(series)
arp    = order.ar
fit    = ar.yw(series, order=arp, aic=FALSE) 
m      = fit$x.mean               # estimate of mean
phi    = fit$ar                   # estimate of phis
resids = na.omit(fit$resid)       # the residuals


# start boots
set.seed(seed)
x.star   = series                # initialize x*
phi      = matrix(phi)           # p x 1
phi.star = matrix(0, arp, nboot)
x.sim    = matrix(0, num, nboot)

pb = txtProgressBar(min = 0, max = nboot, initial = 0, style=3)  # progress bar

for (i in 1:nboot) {
  setTxtProgressBar(pb,i)
  resid.star = c(rep(0,arp), sample(resids, replace=TRUE))
  for (t in arp:(num-1)){
    x0 = matrix(x.star[t:(t-arp+1)] - m)
    x.star[t+1] = m + t(phi)%*%x0 + resid.star[t+1]
  }
 x.sim[,i]    = matrix(x.star) 
 phi.star[,i] = ar.yw(x.star, order=arp, aic=FALSE)$ar
}
close(pb)
x.sim = ts(x.sim, start=tspar[1], frequency=tspar[3])
phi.star = t(phi.star)
colnames(phi.star) =  paste('ar', 1:arp, sep="")


cat('Quantiles:', "\n")
print(apply(phi.star, 2, stats::quantile, c(.01,.025,.05,.1,.25,.50,.75,.9,.95,.975,.99)), digits=4 )
cat('\n')
cat('Mean:', "\n") 
print(colMeans(phi.star), digits=4)
cat('\n')
bias =  t( colMeans(phi.star)-phi)
colnames(bias) = paste('ar', 1:arp, sep="")
cat('Bias:', "\n") 
print(bias, digits=4)
cat('\n')
u = diag(var(phi.star))
cat('rMSE:', "\n")
print(sqrt(u + bias^2), digits=4)
cat('\n')




if (plot){
  if(arp>1){
   tspairs(phi.star, smooth=FALSE,  ...)
  # old.par = par(no.readonly = TRUE)
  # pairs(phi.star, col=astsa.col(col,.4), pch=19, diag.panel=.panhist, oma=rep(2,4), horOdd = TRUE, verOdd = FALSE)
   #par(old.par)
  } else {
   hist(phi.star, main='', xlab=expression(phi^'*'), col=astsa.col(col, .4), breaks='FD', freq=FALSE)
   abline(v=c(stats::quantile(phi.star, probs=c(.025,.5,.975))), col=6) 
  }
}

out = list(phi.star, x.sim)
return(invisible(out))

}

# .panhist <- function(x, ...){
#     usr <- par("usr") 
#     par(usr = c(usr[1:2], 0, 1.5) )
#     h <- hist(x, plot = FALSE, breaks='FD')
#     breaks <- h$breaks; nB <- length(breaks)
#     y <- h$counts; y <- y/max(y)
#     rect(breaks[-nB], 0, breaks[-1], y, ...)
#     u = stats::quantile(x, c(.025,.50,.975))
#     abline(v=u, col=6, lty=2)
# }
