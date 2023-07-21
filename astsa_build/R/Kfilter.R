Kfilter <-
function(y,A,mu0,Sigma0,Phi,sQ,sR,Ups=NULL,Gam=NULL,input=NULL,S=NULL,version=1){
#
##########################################################################
# version 1
#    x[t] = Ups u[t] + Phi x[t-1] + sQ w[t],  w[t]~iid N(0,I)
#    y[t] = Gam u[t] + A[t] x[t] + sR v[t]    v[t]~ iid N(0,I) indep of w
##########################################################################
##########################################################################
# version 2
#    x[t+1] = Ups u[t+1] + Phi x[t] + sQ w[t],  w[t]~iid N(0,I)
#    y[t] = Gam u[t] + A[t] x[t] + sR v[t]      v[t]~ iid N(0,I) 
#      cov(w[t], v[t]) = S  
##########################################################################
##########################################################################
# for either version (1 or 2)
#    sQ is a p*pm matrix and w[t] is pm*1, so variance comes in as 
#      Q = sQ sQ' - it can be sQ = t(chol(Q)) if Q is pd so that 
#      it's the lower triangle matrix or 
#      sQ = Q%^%.5, the square root matrix if Q is psd.
#    sR is q*qm and v[t] is qm*1 ... etc
#    t = 1,...,n, x is p-dim, y is q-dim, and input is r-dim
##-  A should be array of dim(q,p,n) unless it is constant (matrix is ok)
#########################################################################

# check if input, there is at least one of Ups or Gam
if (!is.null(input)){
if (is.null(Ups) & is.null(Gam))  stop("there is 'input' but 'Ups' and 'Gam' are not specified")
} else { # or there is no input but Ups or Gam are specified
if (!is.null(Ups) | !is.null(Gam)) stop(" 'Ups' or 'Gam' are specified but there is no 'input' ")
}

 num  = NROW(y)
 pdim = NROW(Phi) 
 qdim = NCOL(y)
if (is.na(dim(as.array(A))[3]) && NROW(A)==qdim && NCOL(A) == pdim){
    A = array(A, dim=c(qdim,pdim,num))
}

## set NAs to zeros
y[is.na(y)]=0
A[is.na(A)]=0




###########################################################################
#########  univariate cases p=q=1  and r is free
###########################################################################
if (pdim < 2 & qdim < 2){
Q  = sQ^2
R  = sR^2
A  = as.vector(A) 
# input yes or no
if (is.null(input)) {Ups=0; Gam=0; ut=as.matrix(rep(0,num))
 } else {
 rdim = ncol(as.matrix(input))
  if (is.null(Ups))  Ups = matrix(0, nrow=1, ncol=rdim)
  if (is.null(Gam))  Gam = matrix(0, nrow=1, ncol=rdim)
 ut = matrix(input, nrow=num, ncol=rdim)
 }
#
Xp    = c(0)      # Xp=x_t^{t-1} 
Pp    = c(0)      # Pp=P_t^{t-1}
Xf    = c(0)      # Xf=x_t^t
Pf    = c(0)      # Pf=x_t^t
innov = c(0)      # innovations
sig   = c(0)      # innov var-cov matrix

############################################################### 
if (version == 1){
############################################################### 
# initial run
  Xp[1]    = Phi*mu0 + Ups%*%ut[1,]
  Pp[1]    = Phi^2*Sigma0 + Q
  sig[1]   = A[1]^2*Pp[1] + R
  K        = A[1]*Pp[1]/sig[1]
  innov[1] = y[1] - A[1]*Xp[1] - Gam%*%ut[1,]
  Xf[1]    = Xp[1] + K*innov[1]
  Pf[1]    = Pp[1]*(1 - K*A[1])
  like     = log(sig[1]) + innov[1]^2/sig[1]   # -log(likelihood)
############################# 
# start filter iterations
#############################
 for (i in 2:num){
  if (num < 2) break
  Xp[i]    = Phi*Xf[i-1] + Ups%*%ut[i,]
  Pp[i]    = Phi^2*Pf[i-1] + Q
  sig[i]   = A[i]^2*Pp[i] + R
  K        = A[i]*Pp[i]/sig[i]
  innov[i] = y[i] - A[i]*Xp[i] - Gam%*%ut[i,]
  Xf[i]    = Xp[i] + K*innov[i]
  Pf[i]    = Pp[i]*(1 - K*A[i])
  like     = like + log(sig[i]) + innov[i]^2/sig[i]   # -log(likelihood)
  }
 like = 0.5*like
}
############################################################### 
if (version == 2){
############################################################### 
  like  = 0                               # -log(likelihood)
  if (is.null(S)) S = 0
  Xp[1] = Phi*mu0 + Ups%*%ut[1,]
  Pp[1] = Phi^2*Sigma0 + Q
 for (i in 1:num){
  innov[i] = y[i] - A[i]*Xp[i] - Gam%*%ut[i,]
  sig[i]   = A[i]^2*Pp[i] + R 
  K        = (Phi*Pp[i]*A[i] + sQ*S*sR)/sig[i] 
  Xf[i]    = Xp[i] + Pp[i]*A[i]*innov[i]/sig[i]
  Pf[i]    = Pp[i] - (Pp[i]*A[i])^2/sig[i]
  like     = like + log(sig[i]) + innov[i]^2/sig[i]
   if (i==num) break
  Xp[i+1]  = Phi*Xp[i] + Ups%*%ut[i+1,] + K*innov[i]
  Pp[i+1]  = Phi^2*Pp[i] + Q - K^2*sig[i]
  }
  like=0.5*like
}
########## returns for univariate cases #######################
 Xp = array(Xp, dim=c(1,1,num)); Xf = array(Xf, dim=c(1,1,num))
 Pp = array(Pp, dim=c(1,1,num)); Pf = array(Pf, dim=c(1,1,num))
 innov = array(innov, dim=c(1,1,num)); sig = array(sig, dim=c(1,1,num))
return(list(Xp=Xp,Pp=Pp,Xf=Xf,Pf=Pf,Kn=K,like=like,innov=innov,sig=sig))
##### end univariate ##########################################
} else {
###############################################################################
############  multivariate cases ##############################################
###############################################################################

############################################################
if (version == 1){
############################################################
 kf = .Kfilter1(num,y,A,mu0,Sigma0,Phi,Ups,Gam,sQ,sR,input)
}

############################################################
if (version == 2){
############################################################
 if (is.null(S)) S = matrix(0, nrow=pdim, ncol=qdim)
 kf = .Kfilter2(num,y,A,mu0,Sigma0,Phi,Ups,Gam,sQ,sR,S,input)
}
######## both multivariates returns #########################
return(list(Xp=kf$xp,Pp=kf$Pp,Xf=kf$xf,Pf=kf$Pf,like=kf$like,innov=kf$innov,sig=kf$sig,Kn=kf$Kn))
} # end multivariate
} # the end 



.Kfilter1 <-
function(num,y,A,mu0,Sigma0,Phi,Ups,Gam,sQ,sR,input){
#
if (is.null(input)){  # no input
 Q      = sQ %*% t(sQ)
 R      = sR %*% t(sR)
 Phi    = as.matrix(Phi)
 pdim   = nrow(Phi) 
 mu0    = matrix(mu0, nrow=pdim, ncol=1)
 Sigma0 = matrix(Sigma0, nrow=pdim, ncol=pdim)
 y      = as.matrix(y)
 qdim   = ncol(y)
 xp    = array(NA, dim=c(pdim,1,num))         # xp = x_t^{t-1}
 Pp    = array(NA, dim=c(pdim,pdim,num))      # Pp = P_t^{t-1}
 xf    = array(NA, dim=c(pdim,1,num))         # xf = x_t^t
 Pf    = array(NA, dim=c(pdim,pdim,num))      # Pf = x_t^t
 innov = array(NA, dim=c(qdim,1,num))         # innovations
 sig   = array(NA, dim=c(qdim,qdim,num))      # innov var-cov matrix
# initialize 
 xp[,,1]  = Phi%*%mu0 
 Pp[,,1]  = Phi%*%Sigma0%*%t(Phi)+Q
  B       = matrix(A[,,1], nrow=qdim, ncol=pdim)  
 sigtemp  = B%*%Pp[,,1]%*%t(B) + R
 sig[,,1] = (t(sigtemp)+sigtemp)/2    # innov var - make sure symmetric
 siginv   = solve(sig[,,1])          
 K        = Pp[,,1]%*%t(B)%*%siginv
 innov[,,1] = y[1,] - B%*%xp[,,1]
 xf[,,1]  = xp[,,1] + K%*%innov[,,1]
 Pf[,,1]  = Pp[,,1] - K%*%B%*%Pp[,,1]
 sigmat   = matrix(sig[,,1], nrow=qdim, ncol=qdim)
 like     = log(det(sigmat)) + t(innov[,,1])%*%siginv%*%innov[,,1]   # -log(likelihood)
############################# 
# start filter iterations
#############################
 for (i in 2:num){
  if (num < 2) break
  xp[,,i]   = Phi%*%xf[,,i-1]
  Pp[,,i]   = Phi%*%Pf[,,i-1]%*%t(Phi)+Q
   B        = matrix(A[,,i], nrow=qdim, ncol=pdim)  
  sigma     = B%*%Pp[,,i]%*%t(B) + R    
  sig[,,i]  = (t(sigma)+sigma)/2     # make sure sig is symmetric
  siginv    = solve(sig[,,i])          # now siginv is sig[[i]]^{-1}
  K         = Pp[,,i]%*%t(B)%*%siginv
  innov[,,i] = y[i,] - B%*%xp[,,i]
  xf[,,i]   = xp[,,i] + K%*%innov[,,i]
  Pf[,,i]   = Pp[,,i] - K%*%B%*%Pp[,,i]
  sigmat    = matrix(sig[,,i], nrow=qdim, ncol=qdim)
  like      = like + log(det(sigmat)) + t(innov[,,i])%*%siginv%*%innov[,,i]
}  # end no input
#
} else {  # start with input
#
 Q      = sQ %*% t(sQ)
 R      = sR %*% t(sR)
 Phi    = as.matrix(Phi)
 pdim   = nrow(Phi) 
 mu0    = matrix(mu0, nrow=pdim, ncol=1)
 Sigma0 = matrix(Sigma0, nrow=pdim, ncol=pdim)
 y      = as.matrix(y)
 qdim   = ncol(y)
 rdim   = ncol(as.matrix(input))
 input  = matrix(input, nrow=num, ncol=rdim)
   if (is.null(Ups)) Ups = matrix(0, nrow=pdim, ncol=rdim)
   if (is.null(Gam)) Gam = matrix(0, nrow=qdim, ncol=rdim)
   Ups = as.matrix(Ups)
   Gam = as.matrix(Gam)
 xp    = array(NA, dim=c(pdim,1,num))         # xp = x_t^{t-1}          
 Pp    = array(NA, dim=c(pdim,pdim,num))      # Pp = P_t^{t-1}
 xf    = array(NA, dim=c(pdim,1,num))         # xf = x_t^t
 Pf    = array(NA, dim=c(pdim,pdim,num))      # Pf = x_t^t
 innov = array(NA, dim=c(qdim,1,num))         # innovations
 sig   = array(NA, dim=c(qdim,qdim,num))      # innov var-cov matrix
# initialize 
 xp[,,1]  = Phi%*%mu0 + Ups%*%input[1,]
 Pp[,,1]  = Phi%*%Sigma0%*%t(Phi)+Q
  B       = matrix(A[,,1], nrow=qdim, ncol=pdim)  
 sigtemp  = B%*%Pp[,,1]%*%t(B) + R
 sig[,,1] = (t(sigtemp)+sigtemp)/2    # innov var - make sure symmetric
 siginv   = solve(sig[,,1])          
 K        = Pp[,,1]%*%t(B)%*%siginv
 innov[,,1] = y[1,] - B%*%xp[,,1] - Gam%*%input[1,]
 xf[,,1]  = xp[,,1] + K%*%innov[,,1]
 Pf[,,1]  = Pp[,,1] - K%*%B%*%Pp[,,1]
 sigmat   = matrix(sig[,,1], nrow=qdim, ncol=qdim)
 like     = log(det(sigmat)) + t(innov[,,1])%*%siginv%*%innov[,,1]   # -log(likelihood)
############################# 
# start filter iterations
#############################
 for (i in 2:num){
  if (num < 2) break
  xp[,,i]   = Phi%*%xf[,,i-1] + Ups%*%input[i,]
  Pp[,,i]   = Phi%*%Pf[,,i-1]%*%t(Phi)+Q
   B        = matrix(A[,,i], nrow=qdim, ncol=pdim)  
  sigma     = B%*%Pp[,,i]%*%t(B) + R    
  sig[,,i]  = (t(sigma)+sigma)/2     # make sure sig is symmetric
  siginv    = solve(sig[,,i])          # now siginv is sig[[i]]^{-1}
  K         = Pp[,,i]%*%t(B)%*%siginv
  innov[,,i] = y[i,] - B%*%xp[,,i] - Gam%*%input[i,]
  xf[,,i]   = xp[,,i] + K%*%innov[,,i]
  Pf[,,i]   = Pp[,,i] - K%*%B%*%Pp[,,i]
  sigmat    = matrix(sig[,,i], nrow=qdim, ncol=qdim)
  like      = like + log(det(sigmat)) + t(innov[,,i])%*%siginv%*%innov[,,i]
 }
 } # end with input
   like=0.5*like
   list(xp=xp,Pp=Pp,xf=xf,Pf=Pf,like=like,innov=innov,sig=sig,Kn=K)
}



#########################################################
# this is Kfilter2 without Theta 
#########################################################
.Kfilter2 <-
function(num,y,A,mu0,Sigma0,Phi,Ups,Gam,sQ,sR,S,input){
#
if (is.null(input)){  # no input
 Phi   = as.matrix(Phi) 
 num   = NROW(y)
 pdim  = NROW(Phi) 
 qdim  = NCOL(y)
 Q     = sQ %*% t(sQ)
 R     = sR %*% t(sR)
 S     = as.matrix(S)
 y     = as.matrix(y)
 mu0   = as.matrix(mu0)
 Sigma0 = as.matrix(Sigma0)
 xp    =  array(NA, dim=c(pdim,1,num))      # xp = x_t^{t-1} 
 Pp    =  array(NA, dim=c(pdim,pdim,num))   # Pp = P_t^{t-1}
 xf    =  array(NA, dim=c(pdim,1,num))      # xf = x_t^{t} 
 Pf    =  array(NA, dim=c(pdim,pdim,num))   # Pf = P_t^{t}
 innov =  array(NA, dim=c(qdim,1,num))      # innovations
 sig   =  array(NA, dim=c(qdim,qdim,num))   # innov var-cov matrix
 like  = 0                                  # -log(likelihood)
 xp[,,1] = Phi%*%mu0      # mu1
 Pp[,,1] = Phi%*%Sigma0%*%t(Phi)+ Q       # Sigma1
 for (i in 1:num){
   B         = matrix(A[,,i], nrow=qdim, ncol=pdim)  
  innov[,,i] = y[i,] - B%*%xp[,,i]  
  sigma      = B%*%Pp[,,i]%*%t(B) + R 
  sig[,,i]   = (t(sigma)+sigma)/2     # make sure sig is symmetric
  siginv     = solve(sigma)
  K          = (Phi%*%Pp[,,i]%*%t(B) + sQ%*%S%*%t(sR))%*%siginv 
  xf[,,i]    = xp[,,i] + Pp[,,i]%*%t(B)%*%siginv%*%innov[,,i]
  Pf[,,i]    = Pp[,,i] - Pp[,,i]%*%t(B)%*%siginv%*%B%*%Pp[,,i] 
  like       = like + log(det(sigma)) + t(innov[,,i])%*%siginv%*%innov[,,i]
  if (i==num) break
  xp[,,i+1]  = Phi%*%xp[,,i] + K%*%innov[,,i]
  Pp[,,i+1]  = Phi%*%Pp[,,i]%*%t(Phi) + Q - K%*%sig[,,i]%*%t(K)
  } # end no input
#
} else { # start with input
#
 Phi   = as.matrix(Phi) 
 num   = NROW(y)
 pdim  = NROW(Phi) 
 qdim  = NCOL(y)
 Q     = sQ %*% t(sQ)
 R     = sR %*% t(sR)
 S     = as.matrix(S)
 y     = as.matrix(y)
 rdim  =  ncol(as.matrix(input))
 input = matrix(input, nrow=num, ncol=rdim)
  if (is.null(Ups)) Ups = matrix(0, nrow=pdim, ncol=rdim)
  if (is.null(Gam)) Gam = matrix(0, nrow=qdim, ncol=rdim)
  Ups = as.matrix(Ups)
  Gam = as.matrix(Gam)
 mu0    = as.matrix(mu0)
 Sigma0 = as.matrix(Sigma0)
 xp    =  array(NA, dim=c(pdim,1,num))      # xp = x_t^{t-1} 
 Pp    =  array(NA, dim=c(pdim,pdim,num))   # Pp = P_t^{t-1}
 xf    =  array(NA, dim=c(pdim,1,num))      # xf = x_t^{t} 
 Pf    =  array(NA, dim=c(pdim,pdim,num))   # Pf = P_t^{t}
 innov =  array(NA, dim=c(qdim,1,num))      # innovations
 sig   =  array(NA, dim=c(qdim,qdim,num))   # innov var-cov matrix
 like  = 0                                  # -log(likelihood)
 xp[,,1] = Phi%*%mu0 + Ups%*%input[1,]    # mu1
 Pp[,,1] = Phi%*%Sigma0%*%t(Phi)+ Q       # Sigma1
 for (i in 1:num){
   B         = matrix(A[,,i], nrow=qdim, ncol=pdim)  
  innov[,,i] = y[i,] - B%*%xp[,,i] - Gam%*%input[i,]
  sigma      = B%*%Pp[,,i]%*%t(B) + R 
  sig[,,i]   = (t(sigma)+sigma)/2     # make sure sig is symmetric
  siginv     = solve(sigma)
  K          = (Phi%*%Pp[,,i]%*%t(B) + sQ%*%S%*%t(sR))%*%siginv 
  xf[,,i]    = xp[,,i] + Pp[,,i]%*%t(B)%*%siginv%*%innov[,,i]
  Pf[,,i]    = Pp[,,i] - Pp[,,i]%*%t(B)%*%siginv%*%B%*%Pp[,,i] 
  like       = like + log(det(sigma)) + t(innov[,,i])%*%siginv%*%innov[,,i]
  if (i==num) break
  xp[,,i+1]  = Phi%*%xp[,,i] + Ups%*%input[i+1,] + K%*%innov[,,i]
  Pp[,,i+1]  = Phi%*%Pp[,,i]%*%t(Phi) + Q - K%*%sig[,,i]%*%t(K)
  }
}  # end with input   
  like=0.5*like
  list(xp=xp,Pp=Pp,xf=xf,Pf=Pf, Kn=K,like=like,innov=innov,sig=sig)
}

