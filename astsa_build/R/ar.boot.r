ar.boot = function(series, order.ar, nboot=500, seed=NULL, plot=TRUE, col=5){

# estimate parameters
tspar  = tsp(series)
arp    = order.ar
fit    = sarima(series, p=arp, d=0,q=0, details=FALSE)$fit
m      = fit$coef[arp+1]                    # estimate of mean
phi    = fit$coef[1:arp]                    # estimate of phis
resids = fit$resid                          # the residuals


# start boots
set.seed(seed)
nboot    = nboot                 # number of bootstrap replicates
x.star   = series                # initialize x*
phi      = matrix(phi)           # p x 1
phi.star = matrix(0, arp, nboot)
x.sim    = matrix(0, length(series), nboot)

pb = txtProgressBar(min = 0, max = nboot, initial = 0, style=3)  # progress bar

for (i in 1:nboot) {
  setTxtProgressBar(pb,i)
 resid.star =  sample(resids, replace=TRUE)
 for (t in arp:(length(series)-1)){
    x0 = matrix(x.star[t:(t-arp+1)] - m)
    x.star[t+1] = m + t(phi)%*%x0 + resid.star[t]
 }
 x.sim[,i]  = matrix(x.star) 
 phi.star[,i] = ar.yw(x.star, order=arp, aic=FALSE)$ar
}
  close(pb)
x.sim = ts(x.sim, start=tspar[1], frequency=tspar[3])
phi.star = t(phi.star)
colnames(phi.star) = names(fit$coef[1:arp])


cat('Quantiles:', "\n")
print(apply(phi.star, 2, stats::quantile, c(.01,.025,.05,.1,.25,.50,.75,.9,.95,.975,.99)), digits=4 )
cat('\n')
cat('Means:', "\n") 
print(colMeans(phi.star), digits=4)
cat('\n')

if (plot){
   old.par = par(no.readonly = TRUE)
  pairs(phi.star, col=astsa.col(col,.4), pch=19, diag.panel=.panhist, oma=rep(2,4), horOdd = TRUE, verOdd = FALSE)
   par(old.par)
 }

out = list(phi.star, x.sim)
return(invisible(out))

}

.panhist <- function(x, ...){
    usr <- par("usr") 
    par(usr = c(usr[1:2], 0, 1.5) )
    h <- hist(x, plot = FALSE)
    breaks <- h$breaks; nB <- length(breaks)
    y <- h$counts; y <- y/max(y)
    rect(breaks[-nB], 0, breaks[-1], y, ...)
     u = stats::quantile(x, c(.025,.50,.975))
    abline(v=u, col=6, lty=2)
}
