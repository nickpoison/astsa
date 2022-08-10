ffbs <-
function(y,A,mu0,Sigma0,Phi,Ups,Gam,sQ,sR,input){
#
#    x[t] = Ups u[t] + Phi x[t-1] + sQ w[t],  w[t]~iid N(0,I)
#    y[t] = Gam u[t] + A[t] x[t] + sR v[t]    v[t]~ iid N(0,I) indep of w
#    sQ is a p*pm matrix and w[t] is pm*1, so variance comes in as sQ sQ'
#         it can be t(chol(Q)) so that it's the lower triangle matrix
#    sR is q*qm and v[t] is qm*1 ... etc
#    t = 1,...,n, x is p-dim, y is q-dim
##-  A should be array of dim(q,p,n) unless it is constant (matrix is ok)
##-       then we'll fit it below
 num  = NROW(y)
 pdim = NROW(Phi) 
 qdim = NCOL(y)
if (is.na(dim(as.array(A))[3]) && NROW(A)==qdim && NCOL(A) == pdim){
    A = array(A, dim=c(qdim,pdim,num))
}
##- as.matrix everything  
mu0=as.matrix(mu0); Sigma0=as.matrix(Sigma0); Phi=as.matrix(Phi);
Ups=as.matrix(Ups); Gam=as.matrix(Gam); input=as.matrix(input)
sR=as.matrix(sR); sQ=as.matrix(sQ)
##
 cQ = t(sQ); cR = t(sR)  # match inputs to Kfilter1 
 kf = astsa::Kfilter1(num,y,A,mu0,Sigma0,Phi,Ups,Gam,cQ,cR,input)
##
 xs        = array(NA, dim=c(pdim,1,num))      # xs are sampled x[t]s
 xs[,,num] = .rmvnorm(1, kf$xf[,,num], kf$Pf[,,num])
##
 for(k in num:2)  { # k is t+1 here
 J         =   kf$Pf[,,k-1]%*%t(Phi)%*%solve(kf$Pp[,,k])
 m         =   kf$xf[,,k-1] + J%*%(xs[,,k] - kf$xp[,,k]) 
 V         =   kf$Pf[,,k-1] - J%*%kf$Pp[,,k]%*%t(J)
 xs[,,k-1] =  .rmvnorm(1, m, V)
}
# and now for the initial values because R can't count backward to zero
  J   = (Sigma0%*%t(Phi))%*%solve(kf$Pp[,,1])
  m   = mu0 + J%*%(xs[,,1]-kf$xp[,,1])
  V   = Sigma0 + J%*%kf$Pp[,,1]%*%t(J)
  x0n = .rmvnorm(1, m, V)
list(xs=xs,x0n=x0n)
}



.rmvnorm <-
function(n = 1, mu, Sigma, tol=1e-8){
## - this is built off of MASS::mvrnorm
  p   <- length(mu)
  eS  <- eigen(Sigma, symmetric = TRUE)
  ev  <- eS$values
  if(!all(ev >= -tol*abs(ev[1L]))) stop("'Sigma' is not positive definite")
  X  <- matrix(stats::rnorm(p * n), n)
  X  <- drop(mu) + eS$vectors %*% diag(sqrt(pmax(ev, 0)), p) %*% t(X)
  nm <- names(mu)
    if(is.null(nm) && !is.null(dn <- dimnames(Sigma))) nm <- dn[[1L]]
  dimnames(X) <- list(nm, NULL)
  if(n == 1) drop(X) else t(X)
}
