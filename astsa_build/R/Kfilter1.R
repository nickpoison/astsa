Kfilter1 <-
function(num,y,A,mu0,Sigma0,Phi,Ups,Gam,cQ,cR,input){
  #
  # NOTE: must give cholesky decomp: cQ=chol(Q), cR=chol(R)
 Q=t(cQ)%*%cQ
 R=t(cR)%*%cR
   # y is num by q  (time=row series=col)
   # input is num by r (use 0 if not needed)
   # A is an array with dim=c(q,p,num)
   # Ups is p by r  (use 0 if not needed)
   # Gam is q by r  (use 0 if not needed)
   # R is q by q
   # mu0 is p by 1
   # Sigma0, Phi, Q are p by p
 Phi=as.matrix(Phi)
 pdim=nrow(Phi)     
 y=as.matrix(y)
 qdim=ncol(y)
 rdim=ncol(as.matrix(input))
  if (max(abs(Ups))==0) Ups = matrix(0,pdim,rdim)
  if (max(abs(Gam))==0) Gam = matrix(0,qdim,rdim)
  Ups=as.matrix(Ups)
  Gam=as.matrix(Gam)
 ut=matrix(input,num,rdim)
 xp=array(NA, dim=c(pdim,1,num))         # xp=x_t^{t-1}          
 Pp=array(NA, dim=c(pdim,pdim,num))      # Pp=P_t^{t-1}
 xf=array(NA, dim=c(pdim,1,num))         # xf=x_t^t
 Pf=array(NA, dim=c(pdim,pdim,num))      # Pf=x_t^t
 innov=array(NA, dim=c(qdim,1,num))      # innovations
 sig=array(NA, dim=c(qdim,qdim,num))     # innov var-cov matrix
# initialize (because R can't count from zero) 
 x00=as.matrix(mu0, nrow=pdim, ncol=1)
   P00=as.matrix(Sigma0, nrow=pdim, ncol=pdim)
   xp[,,1]=Phi%*%x00 + Ups%*%ut[1,]
   Pp[,,1]=Phi%*%P00%*%t(Phi)+Q
     B = matrix(A[,,1], nrow=qdim, ncol=pdim)  
     sigtemp=B%*%Pp[,,1]%*%t(B)+R
   sig[,,1]=(t(sigtemp)+sigtemp)/2     # innov var - make sure it's symmetric
   siginv=solve(sig[,,1])          
   K=Pp[,,1]%*%t(B)%*%siginv
   innov[,,1]=y[1,]-B%*%xp[,,1]-Gam%*%ut[1,]
   xf[,,1]=xp[,,1]+K%*%innov[,,1]
   Pf[,,1]=Pp[,,1]-K%*%B%*%Pp[,,1]
   sigmat=as.matrix(sig[,,1], nrow=qdim, ncol=qdim)
   like = log(det(sigmat)) + t(innov[,,1])%*%siginv%*%innov[,,1]   # -log(likelihood)
############################# 
# start filter iterations
#############################
 for (i in 2:num){
	 if (num < 2) break
  xp[,,i]=Phi%*%xf[,,i-1] + Ups%*%ut[i,]
  Pp[,,i]=Phi%*%Pf[,,i-1]%*%t(Phi)+Q
      B = matrix(A[,,i], nrow=qdim, ncol=pdim)  
      siginv=B%*%Pp[,,i]%*%t(B)+R
  sig[,,i]=(t(siginv)+siginv)/2     # make sure sig is symmetric
    siginv=solve(sig[,,i])          # now siginv is sig[[i]]^{-1}
  K=Pp[,,i]%*%t(B)%*%siginv
  innov[,,i]=y[i,]-B%*%xp[,,i]-Gam%*%ut[i,]
  xf[,,i]=xp[,,i]+K%*%innov[,,i]
  Pf[,,i]=Pp[,,i]-K%*%B%*%Pp[,,i]
    sigmat=matrix(sig[,,i], nrow=qdim, ncol=qdim)
  like= like + log(det(sigmat)) + t(innov[,,i])%*%siginv%*%innov[,,i]
  }
    like=0.5*like
    list(xp=xp,Pp=Pp,xf=xf,Pf=Pf,like=like,innov=innov,sig=sig,Kn=K)
}

