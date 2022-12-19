EM <-
function(y, A, mu0, Sigma0, Phi, Q, R, Ups=NULL, Gam=NULL, input=NULL,
           max.iter=100, tol=0.0001){
sQ = as.matrix(Q) %^% .5
sR = as.matrix(R) %^% .5
if (is.null(input)) { # no input
em = .EMno(y, A, mu0, Sigma0, Phi, sQ, sR, max.iter=max.iter, tol=tol) 
return(em)
} else { # yes input
em = .EMin(y, A, mu0, Sigma0, Phi, sQ, sR, Ups, Gam, input, max.iter=max.iter, tol=tol)
return(em)
}
}


######################################################################################
######## NO INPUT ####################################################################
######################################################################################
.EMno <-
function(y, A, mu0, Sigma0, Phi, sQ, sR, Ups, Gam, input, max.iter, tol){

## set NAs to zeros
y[is.na(y)]=0
A[is.na(A)]=0

num  = NROW(y)
pdim = NROW(Phi) 
qdim = NCOL(y)
if (is.na(dim(as.array(A))[3]) && NROW(A)==qdim && NCOL(A) == pdim){
    A = array(A, dim=c(qdim,pdim,num))
}

#################################################
#########  univariate cases p=q=1  
#################################################
if (pdim < 2 & qdim < 2){
A  = as.vector(A) 
cvg   = 1 + tol
like  = c()
miss  = ifelse(abs(y)>0, 0, 1)     # 0=observed, 1=missing (for R updates)
cat("iteration","   -loglikelihood", "\n")


#-- start EM --#
for(iter in 1:max.iter){ 
 ks = Ksmooth(y,A,mu0,Sigma0,Phi,sQ,sR,Ups=NULL,Gam=NULL,input=NULL,version=1)
  like[iter] = ks$like
  cat("   ",iter, "        ", ks$like, "\n")     
  if(iter > 1)  cvg = (like[iter-1] - like[iter])/abs(like[iter-1])
  if(cvg  < 0)  stop("Likelihood Not Increasing")
  if(abs(cvg) < tol) break
  Xs = drop(ks$Xs)
  Ps = drop(ks$Ps)
  Xf = drop(ks$Xf)
  Pf = drop(ks$Pf)
  Xp = drop(ks$Xp)
  Pp = drop(ks$Pp)
  sig = drop(ks$sig)
  J   = drop(ks$J)
  J0  = drop(ks$J0)
  X0n = drop(ks$X0n)
  P0n = drop(ks$P0n)
 
# Lag-One Covariance Smoothers 
 Pcs = c(0)            # Pcs=P_{t,t-1}^n
 Pcs[num] = (1 - ks$Kn*A[num])*Phi*Pf[num-1]
  for(k in num:3){
   Pcs[k-1] = Pf[k-1]*J[k-2] + J[k-1]*(Pcs[k] - Phi*Pf[k-1])*J[k-2]
  }
   Pcs[1] = Pf[1]*J0 + J[1]*(Pcs[2] - Phi*Pf[1])*J0

# Estimation
 S11 = Xs[1]^2 + Ps[1]
 S10 = Xs[1]*X0n + Pcs[1]
 S00 = X0n^2 + P0n
#
  oldR = miss[1]*sR^2
  R    = (y[1] - A[1]*Xs[1])^2 + A[1]^2*Ps[1] + oldR
 for (i in 2:num){
  S11  = S11 + Xs[i]^2 + Ps[i]
  S10  = S10 + Xs[i]*Xs[i-1] + Pcs[i]
  S00  = S00 + Xs[i-1]^2 + Ps[i-1]
  oldR = miss[i]*sR^2
  R    = R + (y[i] -A[i]*Xs[i])^2 + A[i]^2*Ps[i] + oldR
  }
  Phi  = S10/S00
  Q    = (S11 - Phi*S10)/num
  R    = R/num
  sQ   = sqrt(Q)
  sR   = sqrt(R)
  mu0  = ks$X0n
  Sigma0 = ks$P0n
}
} else { # end univariate  

#################################################
#########  multivariate cases
#################################################
  Phi  = as.matrix(Phi)
  pdim = nrow(Phi)
  y    = as.matrix(y)
  qdim = ncol(y)
  Q    = sQ%*%t(sQ)
  sQ   = Q%^%.5
  R    = sR%*%t(sR)
  R    = diag(diag(R), qdim)  # R forced to be diag
  sR   = sqrt(R)
  cvg  = 1 + tol
  like = c()
  miss = ifelse(abs(y)>0, 0, 1)     # 0=observed, 1=missing
  cat("iteration","   -loglikelihood", "\n")

#-- start EM --##
for(iter in 1:max.iter){ 
 ks = Ksmooth(y,A,mu0,Sigma0,Phi,sQ,sR,Ups=NULL,Gam=NULL,input=NULL,version=1)
  like[iter]=ks$like
  cat("   ",iter, "        ", ks$like, "\n")     
  if(iter>1) cvg=(like[iter-1]-like[iter])/abs(like[iter-1])
  if(cvg<0) stop("Likelihood Not Increasing")
  if(abs(cvg)<tol) break
  
# Lag-One Covariance Smoothers 
  Pcs = array(NA, dim=c(pdim,pdim,num))     # Pcs=P_{t,t-1}^n
  eye = diag(1,pdim)
    B = matrix(A[,,num], nrow=qdim, ncol=pdim)
  Pcs[,,num] = (eye - ks$Kn%*%B)%*%Phi%*%ks$Pf[,,num-1]
  for(k in num:3){
   Pcs[,,k-1] = ks$Pf[,,k-1]%*%t(ks$J[,,k-2]) + 
        ks$J[,,k-1]%*%(Pcs[,,k] - Phi%*%ks$Pf[,,k-1])%*%t(ks$J[,,k-2])
  }
  Pcs[,,1] = ks$Pf[,,1]%*%t(ks$J0) + 
        ks$J[,,1]%*%(Pcs[,,2] - Phi%*%ks$Pf[,,1])%*%t(ks$J0) 

# Estimation
  S11 = ks$Xs[,,1]%*%t(ks$Xs[,,1]) + ks$Ps[,,1]
  S10 = ks$Xs[,,1]%*%t(ks$X0n) + Pcs[,,1]
  S00 = ks$X0n%*%t(ks$X0n) + ks$P0n
    B = matrix(A[,,1], nrow=qdim, ncol=pdim)
    u = y[1,] - B%*%ks$Xs[,,1]
 oldR = diag(miss[1,],qdim)%*%R
    R = u%*%t(u) + B%*%ks$Ps[,,1]%*%t(B) + oldR
  for(i in 2:num){
    S11 = S11 + ks$Xs[,,i]%*%t(ks$Xs[,,i]) + ks$Ps[,,i]
    S10 = S10 + ks$Xs[,,i]%*%t(ks$Xs[,,i-1]) + Pcs[,,i]
    S00 = S00 + ks$Xs[,,i-1]%*%t(ks$Xs[,,i-1]) + ks$Ps[,,i-1]
      B = matrix(A[,,i], nrow=qdim, ncol=pdim)
      u = y[i,]-B%*%ks$Xs[,,i]
   oldR = diag(miss[i,],qdim)%*%(sR^2)
      R = R + u%*%t(u) + B%*%ks$Ps[,,i]%*%t(B) + oldR
  }
  Phi  =  S10%*%solve(S00)
  Q    =  (S11-Phi%*%t(S10))/num
  Q    = (Q + t(Q))/2       # make sure symmetric 
  sQ   = Q%^%.5 
  R    = R/num
  R    = diag(diag(R), qdim)  # force R to diag
  sR   = sqrt(R)
  mu0  = ks$X0n
  Sigma0 = ks$P0n
}
}
list(Phi=Phi,Q=Q,R=R,mu0=mu0,Sigma0=Sigma0,like=like[1:iter],niter=iter,cvg=cvg)
} # end no input


########################################################################################
########################################################################################
######## WITH INPUT ####################################################################
########################################################################################
########################################################################################
.EMin <-
function(y, A, mu0, Sigma0, Phi, sQ, sR, Ups, Gam, input, max.iter, tol){

# will only come here if input is not NULL
# now check if there is at least one of Ups or Gam
if (is.null(Ups) & is.null(Gam))  stop("there is 'input' but 'Ups' and 'Gam' are not specified")

## set NAs to zeros
y[is.na(y)]=0
A[is.na(A)]=0


num  = NROW(y)
pdim = NROW(Phi) 
qdim = NCOL(y)
rdim = NCOL(input)
if (is.na(dim(as.array(A))[3]) && NROW(A)==qdim && NCOL(A) == pdim){
    A = array(A, dim=c(qdim,pdim,num))
}


  Phi  = as.matrix(Phi)
  y    = as.matrix(y)
  ut   = matrix(input, nrow=num, ncol=rdim)
  Q    = sQ%*%t(sQ)
  sQ   = Q%^%.5
  R    = sR%*%t(sR)
  R    = diag(diag(R), qdim)  # R forced to be diag
  sR   = sqrt(R)
  cvg  = 1 + tol
  like = c()
  miss = ifelse(abs(y)>0, 0, 1)     # 0=observed, 1=missing (for updating R)
  cat("iteration","   -loglikelihood", "\n")


#################################################
################  (1) no Ups ####################
#################################################
if (is.null(Ups)){ # Gam is there as checked
Gam = as.matrix(Gam)
#-- start EM --  ##
for(iter in 1:max.iter){ 
 ks = Ksmooth(y,A,mu0,Sigma0,Phi,sQ,sR,Ups=NULL,Gam=Gam,input=input,version=1)
  like[iter]=ks$like
  cat("   ",iter, "        ", ks$like, "\n")     
  if(iter>1) cvg=(like[iter-1]-like[iter])/abs(like[iter-1])
  if(cvg<0) stop("Likelihood Not Increasing")
  if(abs(cvg)<tol) break
  
# Lag-One Covariance Smoothers 
  Pcs = array(NA, dim=c(pdim,pdim,num))     # Pcs=P_{t,t-1}^n
  eye = diag(1,pdim)
    B = matrix(A[,,num], nrow=qdim, ncol=pdim)
  Pcs[,,num] = (eye - ks$Kn%*%B)%*%Phi%*%ks$Pf[,,num-1]
  for(k in num:3){
   Pcs[,,k-1] = ks$Pf[,,k-1]%*%t(ks$J[,,k-2]) + 
        ks$J[,,k-1]%*%(Pcs[,,k] - Phi%*%ks$Pf[,,k-1])%*%t(ks$J[,,k-2])
  }
  Pcs[,,1] = ks$Pf[,,1]%*%t(ks$J0) + 
        ks$J[,,1]%*%(Pcs[,,2] - Phi%*%ks$Pf[,,1])%*%t(ks$J0) 

# Estimation 
  S11 = ks$Xs[,,1]%*%t(ks$Xs[,,1]) + ks$Ps[,,1]
  S10 = ks$Xs[,,1]%*%t(ks$X0n) + Pcs[,,1]
  S00 = ks$X0n%*%t(ks$X0n) + ks$P0n
  Suu = ut[1,]%*%t(ut[1,])
    B = matrix(A[,,1], nrow=qdim, ncol=pdim)
    z = y[1,] - B%*%ks$Xs[,,1] - Gam%*%ut[1,]
 oldR = diag(miss[1,],qdim)%*%(sR^2)
    R = z%*%t(z) + B%*%ks$Ps[,,1]%*%t(B) + oldR
  Sgg = (y[1,] - B%*%ks$Xs[,,1])%*%t(ut[1,])
  for(i in 2:num){
    S11 = S11 + ks$Xs[,,i]%*%t(ks$Xs[,,i]) + ks$Ps[,,i]
    S10 = S10 + ks$Xs[,,i]%*%t(ks$Xs[,,i-1]) + Pcs[,,i]
    S00 = S00 + ks$Xs[,,i-1]%*%t(ks$Xs[,,i-1]) + ks$Ps[,,i-1]
    Suu = Suu + ut[i,]%*%t(ut[i,])
      B = matrix(A[,,i], nrow=qdim, ncol=pdim)
      z = y[i,] - B%*%ks$Xs[,,i] - Gam%*%ut[i,]
   oldR = diag(miss[i,],qdim)%*%(sR^2)
      R = R + z%*%t(z) + B%*%ks$Ps[,,i]%*%t(B) + oldR 
    Sgg = Sgg + (y[i,] - B%*%ks$Xs[,,i])%*%t(ut[i,])
   }
  Phi  = S10%*%solve(S00)
  Gam  = Sgg%*%solve(Suu)
  Q    = (S11 - Phi%*%t(S10))/num
  Q    = (Q + t(Q))/2       # make sure symmetric 
  sQ   = Q%^%.5 
  R    = R/num
  R    = diag(diag(R), qdim)  # force R to diag
  sR   = sqrt(R)
  mu0  = ks$X0n
  Sigma0 = ks$P0n 
}
list(Phi=Phi,Q=Q,R=R,Ups=NULL,Gam=Gam,mu0=mu0,Sigma0=Sigma0,like=like[1:iter],niter=iter,cvg=cvg)
#################################################
#################################################
} else {  # (2) with  Ups 
#################################################
#################################################
  Ups  = as.matrix(Ups)
  Gid  = ifelse(is.null(Gam), 0L, 1L)  # is Gam NULL?
  if (Gid < 1) { Gam = matrix(0, nrow=qdim, ncol=rdim) 
                } else { Gam = as.matrix(Gam) }  # if NULL set it to 0 thruout
 
#-- start EM --  ##
for(iter in 1:max.iter){ 
 ks = Ksmooth(y,A,mu0,Sigma0,Phi,sQ,sR,Ups=Ups,Gam=Gam,input=input,version=1)
  like[iter]=ks$like
  cat("   ",iter, "        ", ks$like, "\n")     
  if(iter>1) cvg=(like[iter-1]-like[iter])/abs(like[iter-1])
  if(cvg<0) stop("Likelihood Not Increasing")
  if(abs(cvg)<tol) break
  
# Lag-One Covariance Smoothers 
  Pcs = array(NA, dim=c(pdim,pdim,num))     # Pcs=P_{t,t-1}^n
  eye = diag(1,pdim)
    B = matrix(A[,,num], nrow=qdim, ncol=pdim)
  Pcs[,,num] = (eye - ks$Kn%*%B)%*%Phi%*%ks$Pf[,,num-1]
  for(k in num:3){
   Pcs[,,k-1] = ks$Pf[,,k-1]%*%t(ks$J[,,k-2]) + 
        ks$J[,,k-1]%*%(Pcs[,,k] - Phi%*%ks$Pf[,,k-1])%*%t(ks$J[,,k-2])
  }
  Pcs[,,1] = ks$Pf[,,1]%*%t(ks$J0) + 
        ks$J[,,1]%*%(Pcs[,,2] - Phi%*%ks$Pf[,,1])%*%t(ks$J0) 

#-- Estimation 
#- initialize
# S11
  S11 = ks$Xs[,,1]%*%t(ks$Xs[,,1]) + ks$Ps[,,1]   # p by p
# S10
 S10a = ks$Xs[,,1]%*%t(ks$X0n) + Pcs[,,1]      # p by p
 S10b = ks$Xs[,,1]%*%t(ut[1,])                 # p by r
# S00  
    z = rbind(as.matrix(ks$X0n), as.matrix(ut[1,]))
    C = matrix(0, nrow=(pdim+rdim), ncol=(pdim+rdim))
    C[1:pdim,1:pdim] = ks$P0n 
  S00 = z%*%t(z) + C
#-- R
    B = matrix(A[,,1], nrow=qdim, ncol=pdim)
    e = y[1,] - B%*%ks$Xs[,,1] - Gam%*%ut[1,]
 oldR = diag(miss[1,],qdim)%*%(sR^2)
    R = e%*%t(e) + B%*%ks$Ps[,,1]%*%t(B) + oldR
# Gam
  if (Gid > 0) { Sgg = (y[1,] - B%*%ks$Xs[,,1])%*%t(ut[1,])
                 Suu = ut[1,]%*%t(ut[1,])  }   # r by r
#- updates
 for(i in 2:num){
  S11  = S11 + ks$Xs[,,i]%*%t(ks$Xs[,,i]) + ks$Ps[,,i]   # p by p
  S10a = S10a + ks$Xs[,,i]%*%t(ks$Xs[,,i-1]) + Pcs[,,i]
  S10b = S10b + ks$Xs[,,i]%*%t(ut[i,])
   z   = rbind(as.matrix(ks$Xs[,,i-1]), as.matrix(ut[i,]))
   C   = matrix(0, nrow=(pdim+rdim), ncol=(pdim+rdim))
   C[1:pdim,1:pdim] = ks$Ps[,,i-1] 
  S00  =  S00 + z%*%t(z) + C               # p+r by p+r
    B  = matrix(A[,,i], nrow=qdim, ncol=pdim)
    e  = y[i,] - B%*%ks$Xs[,,i] - Gam%*%ut[i,]
 oldR  = diag(miss[i,],qdim)%*%(sR^2)
    R  = R + e%*%t(e) + B%*%ks$Ps[,,i]%*%t(B) + oldR
   if (Gid > 0) { Suu = Suu + ut[i,]%*%t(ut[i,]) 
                  Sgg = Sgg + (y[i,] - B%*%ks$Xs[,,i])%*%t(ut[i,]) }
} # end updates - start estimates
  S10  = cbind(as.matrix(S10a), as.matrix(S10b))   # p by p+r
  PU   = S10%*%solve(S00)
  Phi  = PU[1:pdim,1:pdim]
  Ups  = PU[, (pdim+1):(pdim+rdim)]
  Q    = (S11 - PU%*%t(S10))/num
  Q    = (Q + t(Q))/2       # make sure symmetric 
  sQ   = Q%^%.5 
  R    = R/num
  R    = diag(diag(R), qdim)  # force R to diag
  sR   = sqrt(R)
  mu0  = ks$X0n
  Sigma0 = ks$P0n
  if(Gid > 0) { Gam = Sgg%*%solve(Suu) } else { Gam=matrix(0, nrow=qdim, ncol=rdim) }
}
if (Gid < 1) Gam=NULL  
list(Phi=Phi,Q=Q,R=R,Ups=Ups,Gam=Gam,mu0=mu0,Sigma0=Sigma0,like=like[1:iter],niter=iter,cvg=cvg)
}  # end with Ups
}  # end in  


