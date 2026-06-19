Ksmooth <-
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
#      cov(sQ w[t], sR v[t]) = S (must be specified even if 0 matrix)
##########################################################################
##########################################################################
# for either version (1 or 2)
#    sQ is a p*pm matrix and w[t] is pm*1, so variance comes in as 
#     Q = sQ sQ' - it can be sQ = t(chol(Q)) if Q is pd so that 
#      it's the lower triangle matrix or 
#      sQ = Q%^%.5, the square root matrix if Q is psd.
#    sR is q*qm and v[t] is qm*1 ... etc
#    t = 1,...,n, x is p-dim, y is q-dim, and input is r-dim
##-  A should be array of dim(q,p,n) unless it is constant (matrix is ok)
#########################################################################

  num  <- NROW(y)
  pdim <- NROW(Phi)
  qdim <- NCOL(y)

  ## set NAs to zeros
  y[is.na(y)] <- 0
  A[is.na(A)] <- 0

  ## run forward filter
  kf <- Kfilter(y, A, mu0, Sigma0, Phi, sQ, sR, Ups, Gam, input, S, version)

  ## allocate smoother arrays
  Xs <- array(NA, dim = c(pdim, 1,    num))
  Ps <- array(NA, dim = c(pdim, pdim, num))
  J  <- array(NA, dim = c(pdim, pdim, num))

  ## initialise at t = n
  Xs[,, num] <- kf$Xf[,, num]
  Ps[,, num] <- kf$Pf[,, num]

  ## hoist constant transpose outside the loop
  tPhi <- t(Phi)

  ## backward smoother loop — avoid repeated matrix inversion with solve(A,B)
  for (k in num:2) {
    Pp_k  <- kf$Pp[,, k]           # predicted cov at k
    Pf_k1 <- kf$Pf[,, k-1]        # filtered cov at k-1

    ## J_{k-1} = Pf_{k-1} Phi' Pp_k^{-1}
    ## solve(Pp_k, t(Pf_k1 %*% tPhi)) avoids explicit inversion;
    ## then transpose to get the (pdim x pdim) gain
    Jk <- t(solve(Pp_k, t(Pf_k1 %*% tPhi)))
    tJk <- t(Jk)                   # cache transpose — reused in P update

    J[,, k-1]  <- Jk
    innov_x    <- Xs[,, k] - kf$Xp[,, k]      # innovation in state

    Xs[,, k-1] <- kf$Xf[,, k-1] + Jk %*% innov_x
    dP         <- Ps[,, k] - Pp_k
    Ps[,, k-1] <- Pf_k1 + Jk %*% dP %*% tJk
  }

  ## initial smoother quantities (t = 0)
  J0  <- as.matrix(solve(kf$Pp[,, 1], t(Sigma0 %*% tPhi)),
                   nrow = pdim, ncol = pdim) |> t()
  X0n <- as.matrix(mu0 + J0 %*% (Xs[,, 1] - kf$Xp[,, 1]),
                   nrow = pdim, ncol = 1)
  P0n <- Sigma0 + J0 %*% (Ps[,, 1] - kf$Pp[,, 1]) %*% t(J0)

  list(Xs=Xs, Ps=Ps, X0n=X0n, P0n=P0n, J0=J0, J=J,
       Xp=kf$Xp, Pp=kf$Pp, Xf=kf$Xf, Pf=kf$Pf,
       like=kf$like, innov=kf$innov, sig=kf$sig, Kn=kf$Kn)
} # end
