EM0 <-
function(num,y,A,mu0,Sigma0,Phi,cQ,cR,max.iter=50,tol=.01){
#
# Note: Q and R are given as Cholesky decomps
#       cQ=chol(Q), cR=chol(R)
#
   Phi=as.matrix(Phi)
   pdim=nrow(Phi)
   y=as.matrix(y)
   qdim=ncol(y)
   cvg=1+tol
   like=matrix(0,max.iter,1)
   cat("iteration","   -loglikelihood", "\n")
#----------------- start EM -------------------------
for(iter in 1:max.iter){ 
  ks=astsa::Ksmooth0(num,y,A,mu0,Sigma0,Phi,cQ,cR)
  like[iter]=ks$like
  cat("   ",iter, "        ", ks$like, "\n")
  if(iter>1) cvg=(like[iter-1]-like[iter])/abs(like[iter-1])
  if(cvg<0) stop("Likelihood Not Increasing")
  if(abs(cvg)<tol) break
# Lag-One Covariance Smoothers 
  Pcs=array(NA, dim=c(pdim,pdim,num))     # Pcs=P_{t,t-1}^n
  eye=diag(1,pdim)
  Pcs[,,num]=(eye-ks$Kn%*%A)%*%Phi%*%ks$Pf[,,num-1]
   for(k in num:3){
   Pcs[,,k-1]=ks$Pf[,,k-1]%*%t(ks$J[,,k-2])+
           ks$J[,,k-1]%*%(Pcs[,,k]-Phi%*%ks$Pf[,,k-1])%*%t(ks$J[,,k-2])}
   Pcs[,,1]=ks$Pf[,,1]%*%t(ks$J0)+
           ks$J[,,1]%*%(Pcs[,,2]-Phi%*%ks$Pf[,,1])%*%t(ks$J0)       
# Estimation
    S11 = ks$xs[,,1]%*%t(ks$xs[,,1]) + ks$Ps[,,1]
    S10 = ks$xs[,,1]%*%t(ks$x0n) + Pcs[,,1]
    S00 = ks$x0n%*%t(ks$x0n) + ks$P0n
      u = y[1,]-A%*%ks$xs[,,1]
	R = u%*%t(u) + A%*%ks$Ps[,,1]%*%t(A)
  for(i in 2:num){
    S11 = S11 + ks$xs[,,i]%*%t(ks$xs[,,i]) + ks$Ps[,,i]
    S10 = S10 + ks$xs[,,i]%*%t(ks$xs[,,i-1]) + Pcs[,,i]
    S00 = S00 + ks$xs[,,i-1]%*%t(ks$xs[,,i-1]) + ks$Ps[,,i-1]
      u = y[i,]-A%*%ks$xs[,,i]
    R = R + u%*%t(u) + A%*%ks$Ps[,,i]%*%t(A)
  }
  Phi=S10%*%solve(S00)
  Q=(S11-Phi%*%t(S10))/num
   Q=(t(Q)+Q)/2        # make sure symmetric
  cQ=chol(Q)
  R=R/num
  cR=chol(R)
  mu0=ks$x0n
# mu0=mu0              # uncomment this line to keep mu0 fixed
  Sigma0=ks$P0n
# Sigma0=Sigma0        # uncomment this line to keep Sigma0 fixed
}
 list(Phi=Phi,Q=Q,R=R,mu0=mu0,Sigma0=Sigma0,like=like[1:iter],niter=iter,cvg=cvg)
}

