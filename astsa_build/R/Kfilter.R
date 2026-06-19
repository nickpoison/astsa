Kfilter <-
function(y, A, mu0, Sigma0, Phi, sQ, sR, Ups=NULL, Gam=NULL, input=NULL, S=NULL, version=1){
##########################################################################
# version 1:  x[t]   = Ups u[t]   + Phi x[t-1] + sQ w[t],  w~iid N(0,I)
#             y[t]   = Gam u[t]   + A[t] x[t]  + sR v[t],  v~iid N(0,I)
# version 2:  x[t+1] = Ups u[t+1] + Phi x[t]   + sQ w[t],  w~iid N(0,I)
#             y[t]   = Gam u[t]   + A[t] x[t]  + sR v[t],  cov(w,v)=S
##########################################################################

  # input/Ups/Gam consistency check
  if (!is.null(input)) {
    if (is.null(Ups) && is.null(Gam))
      stop("there is 'input' but 'Ups' and 'Gam' are not specified")
  } else {
    if (!is.null(Ups) || !is.null(Gam))
      stop("'Ups' or 'Gam' are specified but there is no 'input'")
  }

  num  <- NROW(y)
  pdim <- NROW(Phi)
  qdim <- NCOL(y)

  # expand constant A to array
  if (is.na(dim(as.array(A))[3]) && NROW(A) == qdim && NCOL(A) == pdim)
    A <- array(A, dim=c(qdim, pdim, num))

  # set NAs to zero
  y[is.na(y)] <- 0
  A[is.na(A)] <- 0

  # -----------------------------------------------------------------------
  # Univariate fast path (p = q = 1)
  # -----------------------------------------------------------------------
  if (pdim < 2 && qdim < 2) {
    Q <- sQ^2
    R <- sR^2
    A <- as.vector(A)

    if (is.null(input)) {
      Ups <- 0; Gam <- 0
      ut  <- matrix(0, nrow=num, ncol=1)
    } else {
      rdim <- ncol(as.matrix(input))
      if (is.null(Ups)) Ups <- matrix(0, nrow=1, ncol=rdim)
      if (is.null(Gam)) Gam <- matrix(0, nrow=1, ncol=rdim)
      ut <- matrix(input, nrow=num, ncol=rdim)
    }

    # pre-allocate
    Xp    <- numeric(num)
    Pp    <- numeric(num)
    Xf    <- numeric(num)
    Pf    <- numeric(num)
    innov <- numeric(num)
    sig   <- numeric(num)

    if (version == 1) {
      Xp[1]    <- Phi * mu0 + Ups %*% ut[1,]
      Pp[1]    <- Phi^2 * Sigma0 + Q
      sig[1]   <- A[1]^2 * Pp[1] + R
      K        <- A[1] * Pp[1] / sig[1]
      innov[1] <- y[1] - A[1] * Xp[1] - Gam %*% ut[1,]
      Xf[1]    <- Xp[1] + K * innov[1]
      Pf[1]    <- Pp[1] * (1 - K * A[1])
      like     <- log(sig[1]) + innov[1]^2 / sig[1]

      for (i in 2:num) {
        Xp[i]    <- Phi * Xf[i-1] + Ups %*% ut[i,]
        Pp[i]    <- Phi^2 * Pf[i-1] + Q
        sig[i]   <- A[i]^2 * Pp[i] + R
        K        <- A[i] * Pp[i] / sig[i]
        innov[i] <- y[i] - A[i] * Xp[i] - Gam %*% ut[i,]
        Xf[i]    <- Xp[i] + K * innov[i]
        Pf[i]    <- Pp[i] * (1 - K * A[i])
        like     <- like + log(sig[i]) + innov[i]^2 / sig[i]
      }
      like <- 0.5 * like
    }

    if (version == 2) {
      if (is.null(S)) S <- 0
      Xp[1] <- Phi * mu0 + Ups %*% ut[1,]
      Pp[1] <- Phi^2 * Sigma0 + Q
      like  <- 0

      for (i in 1:num) {
        innov[i] <- y[i] - A[i] * Xp[i] - Gam %*% ut[i,]
        sig[i]   <- A[i]^2 * Pp[i] + R
        K        <- (Phi * Pp[i] * A[i] + sQ * S * sR) / sig[i]
        Xf[i]    <- Xp[i] + Pp[i] * A[i] * innov[i] / sig[i]
        Pf[i]    <- Pp[i] - (Pp[i] * A[i])^2 / sig[i]
        like     <- like + log(sig[i]) + innov[i]^2 / sig[i]
        if (i == num) break
        Xp[i+1] <- Phi * Xp[i] + Ups %*% ut[i+1,] + K * innov[i]
        Pp[i+1] <- Phi^2 * Pp[i] + Q - K^2 * sig[i]
      }
      like <- 0.5 * like
    }

    # wrap scalars into 1x1xnum arrays for consistent return shape
    Xp    <- array(Xp,    dim=c(1,1,num))
    Xf    <- array(Xf,    dim=c(1,1,num))
    Pp    <- array(Pp,    dim=c(1,1,num))
    Pf    <- array(Pf,    dim=c(1,1,num))
    innov <- array(innov, dim=c(1,1,num))
    sig   <- array(sig,   dim=c(1,1,num))
    return(list(Xp=Xp, Pp=Pp, Xf=Xf, Pf=Pf, Kn=K, like=like, innov=innov, sig=sig))
  }

  # -----------------------------------------------------------------------
  # Multivariate path — dispatch to version 1 or 2
  # -----------------------------------------------------------------------
  if (version == 1) {
    kf <- .Kfilter1(num, y, A, mu0, Sigma0, Phi, Ups, Gam, sQ, sR, input)
  } else {
    if (is.null(S)) S <- matrix(0, nrow=pdim, ncol=qdim)
    kf <- .Kfilter2(num, y, A, mu0, Sigma0, Phi, Ups, Gam, sQ, sR, S, input)
  }
  list(Xp=kf$xp, Pp=kf$Pp, Xf=kf$xf, Pf=kf$Pf, like=kf$like,
       innov=kf$innov, sig=kf$sig, Kn=kf$Kn)
}


# ---------------------------------------------------------------------------
# Shared setup helper — eliminates duplicated preamble in .Kfilter1/2
# ---------------------------------------------------------------------------
.kf_setup <- function(num, y, A, mu0, Sigma0, Phi, sQ, sR, input, Ups, Gam) {
  Phi    <- as.matrix(Phi)
  pdim   <- nrow(Phi)
  y      <- as.matrix(y)
  qdim   <- ncol(y)
  Q      <- sQ %*% t(sQ)
  R      <- sR %*% t(sR)
  mu0    <- matrix(mu0,    nrow=pdim, ncol=1)
  Sigma0 <- matrix(Sigma0, nrow=pdim, ncol=pdim)
  tPhi   <- t(Phi)          # hoisted: reused every iteration

  # input handling
  if (is.null(input)) {
    ut <- matrix(0, nrow=num, ncol=1)
    if (is.null(Ups)) Ups <- matrix(0, nrow=pdim, ncol=1)
    if (is.null(Gam)) Gam <- matrix(0, nrow=qdim, ncol=1)
  } else {
    rdim  <- ncol(as.matrix(input))
    ut    <- matrix(input, nrow=num, ncol=rdim)
    if (is.null(Ups)) Ups <- matrix(0, nrow=pdim, ncol=rdim)
    if (is.null(Gam)) Gam <- matrix(0, nrow=qdim, ncol=rdim)
    Ups <- as.matrix(Ups)
    Gam <- as.matrix(Gam)
  }

  # pre-allocate output arrays
  xp    <- array(NA, dim=c(pdim, 1,    num))
  Pp    <- array(NA, dim=c(pdim, pdim, num))
  xf    <- array(NA, dim=c(pdim, 1,    num))
  Pf    <- array(NA, dim=c(pdim, pdim, num))
  innov <- array(NA, dim=c(qdim, 1,    num))
  sig   <- array(NA, dim=c(qdim, qdim, num))

  list(Phi=Phi, tPhi=tPhi, pdim=pdim, qdim=qdim, Q=Q, R=R,
       mu0=mu0, Sigma0=Sigma0, ut=ut, Ups=Ups, Gam=Gam,
       xp=xp, Pp=Pp, xf=xf, Pf=Pf, innov=innov, sig=sig, y=y)
}


# ---------------------------------------------------------------------------
# .Kfilter1  (version 1 — no cross-covariance S)
# ---------------------------------------------------------------------------
.Kfilter1 <-
function(num, y, A, mu0, Sigma0, Phi, Ups, Gam, sQ, sR, input) {

  e <- .kf_setup(num, y, A, mu0, Sigma0, Phi, sQ, sR, input, Ups, Gam)
  list2env(e, envir=environment())   # unpack into local names

  # initialise
  xp[,,1]  <- Phi %*% mu0 + Ups %*% ut[1,]
  Pp[,,1]  <- Phi %*% Sigma0 %*% tPhi + Q

  like <- 0

  for (i in 1:num) {
    B          <- matrix(A[,,i], nrow=qdim, ncol=pdim)
    tB         <- t(B)
    PptB       <- Pp[,,i] %*% tB          # pdim x qdim — reused for K and Pf
    sigma      <- B %*% PptB + R
    sig[,,i]   <- (sigma + t(sigma)) * 0.5   # symmetrise

    # use Cholesky for the inverse — faster and more stable than solve()
    ch         <- tryCatch(chol(sig[,,i]), error=function(e) NULL)
    if (is.null(ch)) {
      siginv <- solve(sig[,,i])
      logdet <- log(det(sig[,,i]))
    } else {
      siginv <- chol2inv(ch)
      logdet <- 2 * sum(log(diag(ch)))
    }

    innov[,,i] <- y[i,] - B %*% xp[,,i] - Gam %*% ut[i,]
    K          <- PptB %*% siginv
    xf[,,i]    <- xp[,,i] + K %*% innov[,,i]
    Pf[,,i]    <- Pp[,,i] - K %*% B %*% Pp[,,i]
    like       <- like + logdet + drop(t(innov[,,i]) %*% siginv %*% innov[,,i])

    if (i == num) break
    xp[,,i+1]  <- Phi %*% xf[,,i] + Ups %*% ut[i+1,]
    Pp[,,i+1]  <- Phi %*% Pf[,,i] %*% tPhi + Q
  }

  like <- 0.5 * like
  list(xp=xp, Pp=Pp, xf=xf, Pf=Pf, like=like, innov=innov, sig=sig, Kn=K)
}


# ---------------------------------------------------------------------------
# .Kfilter2  (version 2 — allows cross-covariance S)
# ---------------------------------------------------------------------------
.Kfilter2 <-
function(num, y, A, mu0, Sigma0, Phi, Ups, Gam, sQ, sR, S, input) {

  e <- .kf_setup(num, y, A, mu0, Sigma0, Phi, sQ, sR, input, Ups, Gam)
  list2env(e, envir=environment())

  S     <- as.matrix(S)
  sQStR <- sQ %*% S %*% t(sR)   # constant cross-cov term — hoisted out of loop

  # initialise
  xp[,,1] <- Phi %*% mu0 + Ups %*% ut[1,]
  Pp[,,1] <- Phi %*% Sigma0 %*% tPhi + Q

  like <- 0

  for (i in 1:num) {
    B          <- matrix(A[,,i], nrow=qdim, ncol=pdim)
    tB         <- t(B)
    PptB       <- Pp[,,i] %*% tB
    sigma      <- B %*% PptB + R
    sig[,,i]   <- (sigma + t(sigma)) * 0.5

    ch <- tryCatch(chol(sig[,,i]), error=function(e) NULL)
    if (is.null(ch)) {
      siginv <- solve(sig[,,i])
      logdet <- log(det(sig[,,i]))
    } else {
      siginv <- chol2inv(ch)
      logdet <- 2 * sum(log(diag(ch)))
    }

    innov[,,i] <- y[i,] - B %*% xp[,,i] - Gam %*% ut[i,]
    K          <- (Phi %*% PptB + sQStR) %*% siginv
    xf[,,i]    <- xp[,,i] + PptB %*% siginv %*% innov[,,i]
    Pf[,,i]    <- Pp[,,i] - PptB %*% siginv %*% B %*% Pp[,,i]
    like       <- like + logdet + drop(t(innov[,,i]) %*% siginv %*% innov[,,i])

    if (i == num) break
    xp[,,i+1]  <- Phi %*% xp[,,i] + Ups %*% ut[i+1,] + K %*% innov[,,i]
    Pp[,,i+1]  <- Phi %*% Pp[,,i] %*% tPhi + Q - K %*% sig[,,i] %*% t(K)
  }

  like <- 0.5 * like
  list(xp=xp, Pp=Pp, xf=xf, Pf=Pf, Kn=K, like=like, innov=innov, sig=sig)
}
