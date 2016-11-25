Kfilter2 <-
function(num,y,A,mu0,Sigma0,Phi,Ups,Gam,Theta,cQ,cR,S,input){
  #
  ######## Reference Property 6.5 in Section 6.6 ###########
  # num is the number of observations
  # y is the data matrix (num by q)
  # mu0 initial mean is converted to mu1 in code
  # Sigma0 initial var is converted to Sigma1 in code
    #mu1= E(x_1) = x_1^0 = Phi%*%mu0 + Ups%*%input1 
    # Sigma1 = var(x_1)= P_1^0 =  Phi%*%Sigma0%*%t(Phi)+Theta%*%Q%*%t(Theta)
  # input has to be a matrix (num by r) - similar to obs y
  # set Ups or Gam or input to 0 if not used
  # Must give Cholesky decomp: cQ=chol(Q), cR=chol(R)  
Q=t(cQ)%*%cQ
R=t(cR)%*%cR 
  #
 Phi=as.matrix(Phi)
 pdim=nrow(Phi) 
 y=as.matrix(y)
 qdim=ncol(y)
 rdim=ncol(as.matrix(input))
  if (max(abs(Ups))==0) Ups = matrix(0,pdim,rdim)
  if (max(abs(Gam))==0) Gam = matrix(0,qdim,rdim)
 ut=matrix(input,num,rdim)
 xp=array(NA, dim=c(pdim,1,num))      # xp=x_t^{t-1}          
 Pp=array(NA, dim=c(pdim,pdim,num))   # Pp=P_t^{t-1}
 xf=array(NA, dim=c(pdim,1,num))      # xf=x_t^{t} 
 Pf=array(NA, dim=c(pdim,pdim,num))   # Pf=P_t^{t}
 Gain=array(NA, dim=c(pdim,qdim,num))
 innov=array(NA, dim=c(qdim,1,num))   # innovations
 sig=array(NA, dim=c(qdim,qdim,num))  # innov var-cov matrix
 like=0                               # -log(likelihood)
 xp[,,1]=Phi%*%mu0 + Ups%*%as.matrix(ut[1,],rdim)   # mu1
 Pp[,,1]=Phi%*%Sigma0%*%t(Phi)+Theta%*%Q%*%t(Theta)  #Sigma1
 for (i in 1:num){
	B = matrix(A[,,i], nrow=qdim, ncol=pdim) 
   innov[,,i] = y[i,]-B%*%xp[,,i]-Gam%*%as.matrix(ut[i,],rdim)
    sigma = B%*%Pp[,,i]%*%t(B)+R 
    sigma=(t(sigma)+sigma)/2     # make sure sig is symmetric
   sig[,,i]=sigma
    siginv=solve(sigma)
   Gain[,,i]=(Phi%*%Pp[,,i]%*%t(B)+Theta%*%S)%*%siginv 
    K=as.matrix(Gain[,,i], nrow=qdim, ncol=pdim)
   xf[,,i]=xp[,,i]+ Pp[,,i]%*%t(B)%*%siginv%*%innov[,,i]
   Pf[,,i]=Pp[,,i] - Pp[,,i]%*%t(B)%*%siginv%*%B%*%Pp[,,i] 
     sigma=matrix(sigma, nrow=qdim, ncol=qdim)
   like= like + log(det(sigma)) + t(innov[,,i])%*%siginv%*%innov[,,i]
   if (i==num) break
   xp[,,i+1]=Phi%*%xp[,,i] + Ups%*%as.matrix(ut[i+1,],rdim) + K%*%innov[,,i]
   Pp[,,i+1]=Phi%*%Pp[,,i]%*%t(Phi)+ Theta%*%Q%*%t(Theta) - K%*%sig[,,i]%*%t(K)
  }	 
  like=0.5*like
  list(xp=xp,Pp=Pp,xf=xf,Pf=Pf, K=Gain,like=like,innov=innov,sig=sig)
}

