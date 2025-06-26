ffbs <-
function(y,A,mu0,Sigma0,Phi,sQ,sR,Ups=NULL,Gam=NULL,input=NULL){
#
#    x[t] = Ups u[t] + Phi x[t-1] + sQ w[t],  w[t]~iid N(0,I)
#    y[t] = Gam u[t] + A[t] x[t] + sR v[t]    v[t]~ iid N(0,I) indep of w
#    sQ is a p*pm matrix and w[t] is pm*1, so variance comes in as sQ sQ'
#         it can be t(chol(Q)) so that it's the lower triangle matrix
#    sR is q*qm and v[t] is qm*1 ... etc
#    t = 1,...,n, x is p-dim, y is q-dim

 num  = NROW(y)
 qdim = NCOL(y)
 pdim = NROW(Phi)
 mu0 = as.matrix(mu0); Sigma0 = as.matrix(Sigma0)
 Phi = as.matrix(Phi) 
 sR  = as.matrix(sR);  sQ = as.matrix(sQ)
 kf =  Kfilter(y,A,mu0,Sigma0,Phi,sQ,sR,Ups,Gam,input,version=1)
##
 Xs        =  array(NA, dim=c(pdim,1,num))     # xs are sampled x[t]s
 Xs[,,num] = .rmvnorm(kf$Xf[,,num], kf$Pf[,,num])
##
 for(k in num:2)  { # k is t+1 here
 J          =   kf$Pf[,,k-1]%*%t(Phi)%*%solve(kf$Pp[,,k])
 m          =   as.matrix(kf$Xf[,,k-1] + J%*%(Xs[,,k] - kf$Xp[,,k]))
 V          =   as.matrix(kf$Pf[,,k-1] - J%*%kf$Pp[,,k]%*%t(J))
 Xs[,,k-1]  =  .rmvnorm(m, V)
}
# and now for the initial values because R can't count backward to zero
  J   = (Sigma0%*%t(Phi))%*%solve(kf$Pp[,,1])
  m   = mu0 + J%*%(Xs[,,1]-kf$Xp[,,1])
  V   = Sigma0 + J%*%kf$Pp[,,1]%*%t(J)
  X0n = .rmvnorm(m, V)
list(Xs=Xs,X0n=X0n)
}

## - this is built off of MASS::mvrnorm
# it just generates one mv-normal
.rmvnorm <-
 function(mu, Sigma, tol=1e-8){
  p   <- length(mu)
  eS  <- eigen(Sigma, symmetric = TRUE)
  ev  <- eS$values
  if(!all(ev >= -tol*abs(ev[1L]))) stop("'Sigma' is not positive definite")
  X  <- matrix(rnorm(p), 1)
  X  <- drop(mu) + eS$vectors %*% diag(sqrt(pmax(ev, 0)), p) %*% t(X)
  return(drop(X)) 
}