ar.mcmc <- 
function(xdata, porder, n.iter=1000, n.warmup=100, plot=TRUE, 
           prior_var_phi=50, prior_sig_a=1, prior_sig_b=2, ...){
#
if (NCOL(xdata) > 1) stop("univariate time series only")

nobs    = length(xdata)
lagp    = porder
lagp1   = lagp + 1
niter   = n.iter + n.warmup
y       = xdata[lagp1:nobs]
x       = matrix(1, nobs-lagp, lagp1)
for (j in lagp1:2) {
    x[,j] = xdata[(lagp-j+2):(nobs-j+1)]
    }

phi      = matrix(0, lagp1, niter)
sigma    = rep(1, niter)   # sigma is variance until the output
sigphi   = prior_var_phi   # priors
sigap    = prior_sig_a
sigbp    = prior_sig_b


for (i in 2:niter){
   # Drawing the phis
     var_phi   = solve((1/sigma[i-1])*(t(x)%*%x+(1/sigphi)*diag(1,lagp1)))
     mu_phi    = (1/sigma[i-1])*var_phi%*%t(x)%*%y
     Z         = as.matrix(rnorm(lagp1))
     eV        = eigen(var_phi, symmetric=TRUE)
     phi[,i]   = mu_phi + eV$vectors%*%diag(sqrt(pmax(eV$values,0)),lagp1)%*%Z
   # Drawing sigma^2
     siga       = (nobs-lagp)/2 + sigap
     sigb       = 1/(sum((y-x%*%phi[,i])^2)/2 + sigbp + (1/(2*sigphi))*(t(phi[,i])%*%phi[,i]))
     sigma[i]   = 1/rgamma(1, shape=siga, scale=sigb)
   } 
   
# print - plot results 
indx  = (n.warmup+1):niter
phit  = t(phi[,indx])
sigma = sqrt(sigma[indx])  # now sigma is stand dev
numer = 0:porder
colnames(phit) = paste('phi', numer, sep="")
u     = cbind(phit, sigma)

cat('Quantiles:', "\n")
print(apply(u, 2, stats::quantile, c(.01,.025,.05,.1,.25,.50,.75,.9,.95,.975,.99)), digits=4 )
cat('\n')

if (plot){
  tspairs(u, smooth=FALSE, ...)
}
return(invisible(u))
}


# the old v2.2 and below `if (plot)`:

# old.par = par(no.readonly = TRUE)
# ncols   = floor(sqrt(porder + 2))
# tsplot(u, main="sample traces", xlab="Iteration", col=col, ncolm=ncols)
# cat("Press [Enter] or [Left Mouse] on the active graphic device", "\n")
# par(ask=TRUE)
# pairs(u, col=astsa.col(col,.4), lower.panel=.panelcor,  diag.panel=.panelhist, ...)
# par(old.par)

