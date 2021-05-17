Ksmooth2 <-
function(num,y,A,mu0,Sigma0,Phi,Ups,Gam,Theta,cQ,cR,S,input){
#
# Note: Q and R are given as Cholesky decomps
#       cQ=chol(Q), cR=chol(R)
#  Use Ups=0 or Gam=0 or input=0 if these aren't needed
#
 kf=astsa::Kfilter2(num,y,A,mu0,Sigma0,Phi,Ups,Gam,Theta,cQ,cR,S,input)
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
list(xs=xs,Ps=Ps,J=J,xp=kf$xp,Pp=kf$Pp,xf=kf$xf,Pf=kf$Pf,like=kf$like,Kn=kf$K)
}

