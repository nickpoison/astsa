ar.mcmc <-
function(xdata, porder, n.iter=1000, n.warmup=100, plot=TRUE,
           prior_var_phi=50, prior_sig_a=1, prior_sig_b=2, ...) {

  if (NCOL(xdata) > 1) stop("univariate time series only")

  nobs  <- length(xdata)
  lagp  <- porder
  lagp1 <- lagp + 1
  niter <- n.iter + n.warmup

  # Response and design matrix
  y <- xdata[lagp1:nobs]
  x <- matrix(1, nobs - lagp, lagp1)
  for (j in lagp1:2)
    x[, j] <- xdata[(lagp - j + 2):(nobs - j + 1)]

  # Pre-compute the part of the prior precision that never changes
  xTx        <- crossprod(x)           # t(x) %*% x — computed once
  xTy        <- crossprod(x, y)        # t(x) %*% y — computed once
  prior_prec <- diag(1 / prior_var_phi, lagp1)   # (1/sigphi) * I

  # Storage
  phi   <- matrix(0, lagp1, niter)
  sigma <- rep(1, niter)

  sigap <- prior_sig_a
  sigbp <- prior_sig_b
  siga  <- (nobs - lagp) / 2 + sigap   # shape for sigma draw — constant

  for (i in 2:niter) {

    inv_sig <- 1 / sigma[i-1]

    # --- Draw phi ---
    # Posterior precision and covariance
    prec_phi <- inv_sig * (xTx + prior_prec)   # reuse precomputed xTx
    var_phi  <- solve(prec_phi)

    mu_phi   <- var_phi %*% (inv_sig * xTy)    # reuse precomputed xTy

    # Sample from N(mu_phi, var_phi) via Cholesky  
    ch <- tryCatch(chol(var_phi), error=function(e) NULL)
    if (!is.null(ch)) {
      phi[, i] <- mu_phi + t(ch) %*% rnorm(lagp1)
    } else {
      # fallback: eigen for near-semidefinite var_phi
      eV       <- eigen(var_phi, symmetric=TRUE)
      phi[, i] <- mu_phi +
                  eV$vectors %*% (sqrt(pmax(eV$values, 0)) * rnorm(lagp1))
    }

    # --- Draw sigma^2 ---
    resid    <- y - x %*% phi[, i]
    phi_i    <- phi[, i]
    sigb     <- 1 / (sum(resid^2) / 2 + sigbp +
                     sum(phi_i^2) / (2 * prior_var_phi))  # crossprod -> sum(^2)
    sigma[i] <- 1 / rgamma(1, shape=siga, scale=sigb)
  }

  # Discard warm-up
  indx  <- (n.warmup + 1):niter
  phit  <- t(phi[, indx])
  sigma <- sqrt(sigma[indx])    # convert variance -> std dev

  colnames(phit) <- paste0('phi', 0:porder)
  u <- cbind(phit, sigma)

  cat('\nMeans:\n');     print(colMeans(u), digits=4)
  cat('\nStd.Devs:\n');  print(apply(u, 2, sd), digits=4)
  cat('\nQuantiles:\n'); print(apply(u, 2, quantile,
              c(.01,.025,.05,.1,.25,.5,.75,.9,.95,.975,.99)), digits=4)
  cat('\n')

  if (plot) tspairs(u, smooth=FALSE, ...)

  invisible(u)
}
