Ksmooth0 <-
function(num,y,A,mu0,Sigma0,Phi,cQ,cR){
#
# Note: Q and R are given as Cholesky decomps
#       cQ=chol(Q), cR=chol(R)
#
 kf=astsa::Kfilter0(num,y,A,mu0,Sigma0,Phi,cQ,cR)
 pdim=nrow(as.matrix(Phi))  
 xs=array(NA, dim=c(pdim,1,num))      # xs=x_t^n
 Ps=array(NA, dim=c(pdim,pdim,num))   # Ps=P_t^n
 J=array(NA, dim=c(pdim,pdim,num))    # J=J_t
 xs[,,num]=kf$xf[,,num] 
 Ps[,,num]=kf$Pf[,,num]
 for(k in num:2)  {
 J[,,k-1]=(kf$Pf[,,k-1]%*%t(Phi))%*%solve(kf$Pp[,,k])
 xs[,,k-1]=kf$xf[,,k-1]+J[,,k-1]%*%(xs[,,k]-kf$xp[,,k])
 Ps[,,k-1]=kf$Pf[,,k-1]+J[,,k-1]%*%(Ps[,,k]-kf$Pp[,,k])%*%t(J[,,k-1])
}
# and now for the initial values because R can't count backward to zero
    x00=mu0
    P00=Sigma0
   J0=as.matrix((P00%*%t(Phi))%*%solve(kf$Pp[,,1]), nrow=pdim, ncol=pdim)
   x0n=as.matrix(x00+J0%*%(xs[,,1]-kf$xp[,,1]), nrow=pdim, ncol=1)
   P0n= P00 + J0%*%(Ps[,,1]-kf$Pp[,,1])%*%t(J0)
list(xs=xs,Ps=Ps,x0n=x0n,P0n=P0n,J0=J0,J=J,xp=kf$xp,Pp=kf$Pp,xf=kf$xf,Pf=kf$Pf,like=kf$like,Kn=kf$K)
}

