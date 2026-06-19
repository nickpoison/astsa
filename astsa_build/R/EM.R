EM <-
function(y, A, mu0, Sigma0, Phi, Q, R, Ups=NULL, Gam=NULL, input=NULL,
           max.iter=100, tol=0.0001) {
  sQ <- as.matrix(Q) %^% .5
  sR <- as.matrix(R) %^% .5
  if (is.null(input)) {
    .EMno(y, A, mu0, Sigma0, Phi, sQ, sR, max.iter=max.iter, tol=tol)
  } else {
    .EMin(y, A, mu0, Sigma0, Phi, sQ, sR, Ups, Gam, input, max.iter=max.iter, tol=tol)
  }
}


# ---------------------------------------------------------------------------
# Shared helper: preprocess inputs, handle NAs, expand A, set up miss matrix
# ---------------------------------------------------------------------------
.em_setup <- function(y, A, mu0, Sigma0, Phi, sQ, sR, input=NULL, Ups=NULL, Gam=NULL) {
  # missing-value indicator before zeroing NAs
  miss <- if (anyNA(y)) (!is.na(y)) * 0L + is.na(y) * 1L else ifelse(abs(y) > 0, 0L, 1L)
  y[is.na(y)] <- 0
  A[is.na(A)] <- 0

  num  <- NROW(y)
  pdim <- NROW(Phi)
  qdim <- NCOL(y)

  if (is.na(dim(as.array(A))[3]) && NROW(A) == qdim && NCOL(A) == pdim)
    A <- array(A, dim=c(qdim, pdim, num))

  list(y=y, A=A, miss=miss, num=num, pdim=pdim, qdim=qdim,
       mu0=mu0, Sigma0=Sigma0, Phi=Phi, sQ=sQ, sR=sR,
       Ups=Ups, Gam=Gam, input=input)
}


# ---------------------------------------------------------------------------
# Shared EM convergence check and logging — returns updated cvg
# ---------------------------------------------------------------------------
.em_converge <- function(like, iter, tol) {
  cat("   ", iter - 1, "        ", like[iter], "\n")
  if (iter == 1) return(1 + tol)
  cvg <- (like[iter-1] - like[iter]) / abs(like[iter-1])
  if (cvg < 0) stop("Likelihood Not Increasing")
  cvg
}


# ---------------------------------------------------------------------------
# Lag-one covariance smoother — shared across all EM branches
# ---------------------------------------------------------------------------
.lag1cov <- function(ks, Phi, pdim, num) {
  Pcs <- array(NA, dim=c(pdim, pdim, num))
  # for univariate ks arrays are already dropped to vectors/scalars by caller
  tJ  <- function(k) t(ks$J[,,k])
  B_last <- matrix(ks$A_last, nrow=nrow(ks$Kn), ncol=pdim)   # passed in via ks
  Pcs[,,num] <- (diag(pdim) - ks$Kn %*% B_last) %*% Phi %*% ks$Pf[,,num-1]
  for (k in num:3) {
    tJk2       <- tJ(k-2)
    Pcs[,,k-1] <- ks$Pf[,,k-1] %*% tJk2 +
                  ks$J[,,k-1] %*% (Pcs[,,k] - Phi %*% ks$Pf[,,k-1]) %*% tJk2
  }
  tJ0        <- t(ks$J0)
  Pcs[,,1]   <- ks$Pf[,,1] %*% tJ0 +
                ks$J[,,1] %*% (Pcs[,,2] - Phi %*% ks$Pf[,,1]) %*% tJ0
  Pcs
}


######################################################################################
######## NO INPUT ####################################################################
######################################################################################
.EMno <-
function(y, A, mu0, Sigma0, Phi, sQ, sR, max.iter, tol) {

  e <- .em_setup(y, A, mu0, Sigma0, Phi, sQ, sR)
  list2env(e, envir=environment())

  cvg  <- 1 + tol
  like <- numeric(max.iter)
  cat("iteration", "   -loglikelihood\n")

  # -----------------------------------------------------------------------
  # Univariate fast path
  # -----------------------------------------------------------------------
  if (pdim < 2 && qdim < 2) {
    A <- as.vector(A)

    for (iter in 1:max.iter) {
      ks <- Ksmooth(y, A, mu0, Sigma0, Phi, sQ, sR,
                    Ups=NULL, Gam=NULL, input=NULL, version=1)
      like[iter] <- ks$like
      cvg <- .em_converge(like, iter, tol)
      if (abs(cvg) < tol) break

      Xs  <- drop(ks$Xs);  Ps  <- drop(ks$Ps)
      Pf  <- drop(ks$Pf);  J   <- drop(ks$J);  J0 <- drop(ks$J0)
      X0n <- drop(ks$X0n); P0n <- drop(ks$P0n)

      # Lag-one covariance smoother (univariate)
      Pcs      <- numeric(num)
      Pcs[num] <- (1 - ks$Kn * A[num]) * Phi * Pf[num-1]
      for (k in num:3)
        Pcs[k-1] <- Pf[k-1]*J[k-2] + J[k-1]*(Pcs[k] - Phi*Pf[k-1])*J[k-2]
      Pcs[1] <- Pf[1]*J0 + J[1]*(Pcs[2] - Phi*Pf[1])*J0

      # Sufficient statistics — accumulate in one loop
      S11 <- Xs[1]^2 + Ps[1]
      S10 <- Xs[1]*X0n + Pcs[1]
      S00 <- X0n^2 + P0n
      R   <- (y[1] - A[1]*Xs[1])^2 + A[1]^2*Ps[1] + miss[1]*sR^2
      for (i in 2:num) {
        S11 <- S11 + Xs[i]^2   + Ps[i]
        S10 <- S10 + Xs[i]*Xs[i-1] + Pcs[i]
        S00 <- S00 + Xs[i-1]^2 + Ps[i-1]
        R   <- R + (y[i] - A[i]*Xs[i])^2 + A[i]^2*Ps[i] + miss[i]*sR^2
      }
      Phi    <- S10 / S00
      Q      <- (S11 - Phi*S10) / num
      R      <- R / num
      sQ     <- sqrt(Q);  sR <- sqrt(R)
      mu0    <- ks$X0n;   Sigma0 <- ks$P0n
    }

  } else {
    # -----------------------------------------------------------------------
    # Multivariate path
    # -----------------------------------------------------------------------
    Phi  <- as.matrix(Phi)
    y    <- as.matrix(y)
    Q    <- sQ %*% t(sQ);  sQ <- Q %^% .5
    R    <- sR %*% t(sR)
    R    <- diag(diag(R), qdim)   # force diagonal
    sR   <- sqrt(R)
    miss <- ifelse(abs(y) > 0, 0L, 1L)
    eye  <- diag(pdim)

    for (iter in 1:max.iter) {
      ks <- Ksmooth(y, A, mu0, Sigma0, Phi, sQ, sR,
                    Ups=NULL, Gam=NULL, input=NULL, version=1)
      like[iter] <- ks$like
      cvg <- .em_converge(like, iter, tol)
      if (abs(cvg) < tol) break

      # Lag-one covariance smoother
      Pcs        <- array(NA, dim=c(pdim, pdim, num))
      B_num      <- matrix(A[,,num], nrow=qdim, ncol=pdim)
      Pcs[,,num] <- (eye - ks$Kn %*% B_num) %*% Phi %*% ks$Pf[,,num-1]
      for (k in num:3) {
        tJk2       <- t(ks$J[,,k-2])
        Pcs[,,k-1] <- ks$Pf[,,k-1] %*% tJk2 +
                      ks$J[,,k-1] %*% (Pcs[,,k] - Phi %*% ks$Pf[,,k-1]) %*% tJk2
      }
      tJ0      <- t(ks$J0)
      Pcs[,,1] <- ks$Pf[,,1] %*% tJ0 +
                  ks$J[,,1] %*% (Pcs[,,2] - Phi %*% ks$Pf[,,1]) %*% tJ0

      # Sufficient statistics
      Xs1 <- ks$Xs[,,1]
      S11 <- Xs1 %*% t(Xs1) + ks$Ps[,,1]
      S10 <- Xs1 %*% t(ks$X0n) + Pcs[,,1]
      S00 <- ks$X0n %*% t(ks$X0n) + ks$P0n
      B   <- matrix(A[,,1], nrow=qdim, ncol=pdim)
      u   <- y[1,] - B %*% Xs1
      R   <- u %*% t(u) + B %*% ks$Ps[,,1] %*% t(B) + diag(miss[1,], qdim) %*% R

      for (i in 2:num) {
        Xsi  <- ks$Xs[,,i];  Xsi1 <- ks$Xs[,,i-1]
        S11  <- S11 + Xsi  %*% t(Xsi)  + ks$Ps[,,i]
        S10  <- S10 + Xsi  %*% t(Xsi1) + Pcs[,,i]
        S00  <- S00 + Xsi1 %*% t(Xsi1) + ks$Ps[,,i-1]
        B    <- matrix(A[,,i], nrow=qdim, ncol=pdim)
        u    <- y[i,] - B %*% Xsi
        R    <- R + u %*% t(u) + B %*% ks$Ps[,,i] %*% t(B) +
                diag(miss[i,], qdim) %*% (sR^2)
      }

      Phi    <- S10 %*% solve(S00)
      Q      <- (S11 - Phi %*% t(S10)) / num
      Q      <- (Q + t(Q)) * 0.5
      sQ     <- Q %^% .5
      R      <- diag(diag(R / num), qdim)
      sR     <- sqrt(R)
      mu0    <- ks$X0n;  Sigma0 <- ks$P0n
    }
  }

  list(Phi=Phi, Q=Q, R=R, mu0=mu0, Sigma0=Sigma0,
       like=like[1:iter], niter=iter-1, cvg=cvg)
}


######################################################################################
######## WITH INPUT ##################################################################
######################################################################################
.EMin <-
function(y, A, mu0, Sigma0, Phi, sQ, sR, Ups, Gam, input, max.iter, tol) {

  if (is.null(Ups) && is.null(Gam))
    stop("there is 'input' but 'Ups' and 'Gam' are not specified")

  e <- .em_setup(y, A, mu0, Sigma0, Phi, sQ, sR, input, Ups, Gam)
  list2env(e, envir=environment())

  Phi  <- as.matrix(Phi)
  y    <- as.matrix(y)
  rdim <- NCOL(input)
  ut   <- matrix(input, nrow=num, ncol=rdim)
  Q    <- sQ %*% t(sQ);  sQ <- Q %^% .5
  R    <- sR %*% t(sR)
  R    <- diag(diag(R), qdim)
  sR   <- sqrt(R)
  miss <- ifelse(abs(y) > 0, 0L, 1L)
  cvg  <- 1 + tol
  like <- numeric(max.iter)
  eye  <- diag(pdim)
  cat("iteration", "   -loglikelihood\n")

  # -----------------------------------------------------------------------
  # Shared lag-one smoother (multivariate, used by all input branches)
  # -----------------------------------------------------------------------
  .pcs <- function(ks) {
    Pcs        <- array(NA, dim=c(pdim, pdim, num))
    B_num      <- matrix(A[,,num], nrow=qdim, ncol=pdim)
    Pcs[,,num] <- (eye - ks$Kn %*% B_num) %*% Phi %*% ks$Pf[,,num-1]
    for (k in num:3) {
      tJk2       <- t(ks$J[,,k-2])
      Pcs[,,k-1] <- ks$Pf[,,k-1] %*% tJk2 +
                    ks$J[,,k-1] %*% (Pcs[,,k] - Phi %*% ks$Pf[,,k-1]) %*% tJk2
    }
    tJ0      <- t(ks$J0)
    Pcs[,,1] <- ks$Pf[,,1] %*% tJ0 +
                ks$J[,,1] %*% (Pcs[,,2] - Phi %*% ks$Pf[,,1]) %*% tJ0
    Pcs
  }

  # -----------------------------------------------------------------------
  # (1) Gam only (no Ups)
  # -----------------------------------------------------------------------
  if (is.null(Ups)) {
    Gam <- as.matrix(Gam)

    for (iter in 1:max.iter) {
      ks <- Ksmooth(y, A, mu0, Sigma0, Phi, sQ, sR,
                    Ups=NULL, Gam=Gam, input=input, version=1)
      like[iter] <- ks$like
      cvg <- .em_converge(like, iter, tol)
      if (abs(cvg) < tol) break

      Pcs <- .pcs(ks)

      Xs1 <- ks$Xs[,,1]
      S11 <- Xs1 %*% t(Xs1) + ks$Ps[,,1]
      S10 <- Xs1 %*% t(ks$X0n) + Pcs[,,1]
      S00 <- ks$X0n %*% t(ks$X0n) + ks$P0n
      Suu <- ut[1,] %*% t(ut[1,])
      B   <- matrix(A[,,1], nrow=qdim, ncol=pdim)
      z   <- y[1,] - B %*% Xs1 - Gam %*% ut[1,]
      R   <- z %*% t(z) + B %*% ks$Ps[,,1] %*% t(B) + diag(miss[1,], qdim) %*% (sR^2)
      Sgg <- (y[1,] - B %*% Xs1) %*% t(ut[1,])

      for (i in 2:num) {
        Xsi  <- ks$Xs[,,i];  Xsi1 <- ks$Xs[,,i-1]
        S11  <- S11 + Xsi  %*% t(Xsi)  + ks$Ps[,,i]
        S10  <- S10 + Xsi  %*% t(Xsi1) + Pcs[,,i]
        S00  <- S00 + Xsi1 %*% t(Xsi1) + ks$Ps[,,i-1]
        Suu  <- Suu + ut[i,] %*% t(ut[i,])
        B    <- matrix(A[,,i], nrow=qdim, ncol=pdim)
        z    <- y[i,] - B %*% Xsi - Gam %*% ut[i,]
        R    <- R + z %*% t(z) + B %*% ks$Ps[,,i] %*% t(B) +
                diag(miss[i,], qdim) %*% (sR^2)
        Sgg  <- Sgg + (y[i,] - B %*% Xsi) %*% t(ut[i,])
      }

      Phi    <- S10 %*% solve(S00)
      Gam    <- Sgg %*% solve(Suu)
      Q      <- (S11 - Phi %*% t(S10)) / num
      Q      <- (Q + t(Q)) * 0.5
      sQ     <- Q %^% .5
      R      <- diag(diag(R / num), qdim)
      sR     <- sqrt(R)
      mu0    <- ks$X0n;  Sigma0 <- ks$P0n
    }
    return(list(Phi=Phi, Q=Q, R=R, Ups=NULL, Gam=Gam, mu0=mu0, Sigma0=Sigma0,
                like=like[1:iter], niter=iter, cvg=cvg))
  }

  # -----------------------------------------------------------------------
  # (2) Ups present (Gam optional)
  # -----------------------------------------------------------------------
  Ups  <- as.matrix(Ups)
  Gid  <- !is.null(Gam)
  Gam  <- if (Gid) as.matrix(Gam) else matrix(0, nrow=qdim, ncol=rdim)

  for (iter in 1:max.iter) {
    ks <- Ksmooth(y, A, mu0, Sigma0, Phi, sQ, sR,
                  Ups=Ups, Gam=Gam, input=input, version=1)
    like[iter] <- ks$like
    cvg <- .em_converge(like, iter, tol)
    if (abs(cvg) < tol) break

    Pcs <- .pcs(ks)

    # Block sufficient stats for joint [Phi | Ups] update
    Xs1  <- ks$Xs[,,1]
    S11  <- Xs1 %*% t(Xs1) + ks$Ps[,,1]
    S10a <- Xs1 %*% t(ks$X0n) + Pcs[,,1]
    S10b <- Xs1 %*% t(ut[1,])
    # S00 is (p+r) x (p+r): top-left = E[x x'], off-diag = E[x u'], bottom = u u'
    z_00       <- rbind(ks$X0n, matrix(ut[1,], ncol=1))
    C          <- matrix(0, nrow=pdim+rdim, ncol=pdim+rdim)
    C[1:pdim, 1:pdim] <- ks$P0n
    S00        <- z_00 %*% t(z_00) + C
    B          <- matrix(A[,,1], nrow=qdim, ncol=pdim)
    e_resid    <- y[1,] - B %*% Xs1 - Gam %*% ut[1,]
    R          <- e_resid %*% t(e_resid) + B %*% ks$Ps[,,1] %*% t(B) +
                  diag(miss[1,], qdim) %*% (sR^2)
    if (Gid) {
      Sgg <- (y[1,] - B %*% Xs1) %*% t(ut[1,])
      Suu <- ut[1,] %*% t(ut[1,])
    }

    for (i in 2:num) {
      Xsi  <- ks$Xs[,,i];  Xsi1 <- ks$Xs[,,i-1]
      S11  <- S11  + Xsi  %*% t(Xsi)  + ks$Ps[,,i]
      S10a <- S10a + Xsi  %*% t(Xsi1) + Pcs[,,i]
      S10b <- S10b + Xsi  %*% t(ut[i,])
      z_i        <- rbind(Xsi1, matrix(ut[i,], ncol=1))
      C[1:pdim, 1:pdim] <- ks$Ps[,,i-1]
      S00  <- S00  + z_i %*% t(z_i) + C
      B    <- matrix(A[,,i], nrow=qdim, ncol=pdim)
      e_resid  <- y[i,] - B %*% Xsi - Gam %*% ut[i,]
      R    <- R + e_resid %*% t(e_resid) + B %*% ks$Ps[,,i] %*% t(B) +
              diag(miss[i,], qdim) %*% (sR^2)
      if (Gid) {
        Suu  <- Suu + ut[i,] %*% t(ut[i,])
        Sgg  <- Sgg + (y[i,] - B %*% Xsi) %*% t(ut[i,])
      }
    }

    S10  <- cbind(S10a, S10b)
    PU   <- S10 %*% solve(S00)
    Phi  <- PU[1:pdim, 1:pdim]
    Ups  <- PU[, (pdim+1):(pdim+rdim), drop=FALSE]
    Q    <- (S11 - PU %*% t(S10)) / num
    Q    <- (Q + t(Q)) * 0.5
    sQ   <- Q %^% .5
    R    <- diag(diag(R / num), qdim)
    sR   <- sqrt(R)
    mu0  <- ks$X0n;  Sigma0 <- ks$P0n
    if (Gid) Gam <- Sgg %*% solve(Suu)
  }

  if (!Gid) Gam <- NULL
  list(Phi=Phi, Q=Q, R=R, Ups=Ups, Gam=Gam, mu0=mu0, Sigma0=Sigma0,
       like=like[1:iter], niter=iter-1, cvg=cvg)
}
