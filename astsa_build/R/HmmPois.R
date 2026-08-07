## ------------------------------------------------------------
## HmmPois  
## Automatically initializes lambda0/Gamma0/delta0 via k-means,
## fits by EM, and tries a few perturbations of the starting
## point in case the k-means partition was slightly awkward.
##
## y         : count time series
## m         : number of states
## n_perturb : number of extra randomized restarts to try
## ...       : passed through to .pois_hmm_em (e.g. maxiter, tol)
## ------------------------------------------------------------

HmmPois <- function(y, m = 2, n_perturb = 5,
                          se = c("none", "boot"), B = 200,
                          boot_n_perturb = 1, ...) {

  se <- match.arg(se)
  y <- as.numeric(y)       # strip any ts attributes if there
  init <- .auto_init_pois_hmm(y, m)

  ## fit at the automatic starting point
  best <- .pois_hmm_em(y, m,
                        lambda0 = init$lambda0,
                        Gamma0  = init$Gamma0,
                        delta0  = init$delta0, ...)

  ## a few small perturbations around it, in case kmeans landed
  ## on a slightly awkward partition
  for (i in 1:n_perturb) {
    lam_p <- pmax(init$lambda0 * runif(m, 0.7, 1.3), 0.1)
    fit <- tryCatch(
      .pois_hmm_em(y, m, lambda0 = sort(lam_p),
                   Gamma0 = init$Gamma0, delta0 = init$delta0, ...),
      error = function(e) NULL
    )
    if (!is.null(fit) && fit$loglik > best$loglik) best <- fit
  }

  best$init <- init

  if (se == "boot") {
    best$se <- .pois_hmm_boot(best, y, m = m, B = B,
                               n_perturb = boot_n_perturb, ...)
  }

  best
}


## ------------------------------------------------------------
## .pois_hmm_em: core EM engine for an m-state Poisson HMM
##
## y        : count time series
## m        : number of states
## lambda0  : starting rates (length m)
## Gamma0   : starting transition matrix (m x m, rows sum to 1)
## delta0   : starting initial-state distribution (length m)
## ------------------------------------------------------------
.pois_hmm_em <- function(y, m = 2,
                          lambda0 = NULL,
                          Gamma0  = NULL,
                          delta0  = NULL,
                          maxiter = 500, tol = 1e-8) {

  n <- length(y)

  if (is.null(lambda0)) {
    qs <- quantile(y, seq(0, 1, length.out = m + 2))[2:(m + 1)]
    lambda <- as.numeric(qs)
  } else lambda <- lambda0

  if (is.null(Gamma0)) {
    Gamma <- matrix(0.1 / (m - 1), m, m); diag(Gamma) <- 0.9
  } else Gamma <- Gamma0

  delta <- if (is.null(delta0)) rep(1 / m, m) else delta0

  oldloglik <- -Inf

  for (iter in 1:maxiter) {

    ## ---- emission probabilities: n x m ----
    B <- sapply(1:m, function(j) dpois(y, lambda[j]))

    ## ---- scaled forward pass ----
    alpha <- matrix(0, n, m)
    cvec  <- numeric(n)

    a         <- delta * B[1, ]
    cvec[1]   <- sum(a)
    alpha[1,] <- a / cvec[1]

    for (t in 2:n) {
      a          <- (alpha[t - 1, ] %*% Gamma) * B[t, ]
      cvec[t]    <- sum(a)
      alpha[t, ] <- a / cvec[t]
    }
    loglik <- sum(log(cvec))

    ## ---- scaled backward pass ----
    beta      <- matrix(0, n, m)
    beta[n, ] <- 1
    for (t in (n - 1):1) {
      beta[t, ] <- (Gamma %*% (B[t + 1, ] * beta[t + 1, ])) / cvec[t + 1]
    }

    ## ---- E-step: state probs (gamma) and transition probs (xi) ----
    gam <- alpha * beta
    gam <- gam / rowSums(gam)

    xi <- matrix(0, m, m)
    for (t in 1:(n - 1)) {
      num <- outer(alpha[t, ], B[t + 1, ] * beta[t + 1, ]) * Gamma
      xi  <- xi + num / cvec[t + 1]
    }

    ## ---- M-step ----
    Gamma_new  <- xi / rowSums(xi)
    lambda_new <- colSums(gam * y) / colSums(gam)
    delta_new  <- gam[1, ]

    diff <- abs(loglik - oldloglik)
    Gamma <- Gamma_new; lambda <- lambda_new; delta <- delta_new
    if (diff < tol) break
    oldloglik <- loglik
  }
  distout <- .statdist(Gamma0)
  list(lambda = lambda, Pmatrix = Gamma, delta = delta, pis=distout,
       loglik = loglik, posterior = gam, niter = iter)
}


## ------------------------------------------------------------
## .auto_init_pois_hmm: data-driven starting values for lambda0,
## Gamma0, and delta0 via k-means clustering of the counts
## (quantile binning fallback for very small samples).
## ------------------------------------------------------------
.auto_init_pois_hmm <- function(y, m = 2) {
  n <- length(y)

  ## --- hard clustering step ---
  if (n >= 5 * m) {
    km  <- kmeans(y, centers = m, nstart = 25)
    cl  <- km$cluster
    ord <- order(km$centers)              # relabel so state 1 = lowest rate
    map <- match(cl, ord)
    lambda0 <- sort(km$centers)
  } else {
    ## fallback for tiny samples: quantile binning instead of kmeans
    qs  <- quantile(y, seq(0, 1, length.out = m + 1))
    map <- cut(y, breaks = qs, labels = FALSE, include.lowest = TRUE)
    lambda0 <- sapply(1:m, function(j) mean(y[map == j]))
  }

  ## --- empirical transition matrix from the hard-assigned state sequence ---
  Gamma0 <- matrix(0, m, m)
  for (t in 1:(n - 1)) {
    Gamma0[map[t], map[t + 1]] <- Gamma0[map[t], map[t + 1]] + 1
  }
  Gamma0 <- Gamma0 + 0.5              # small pseudo-count: avoids zero rows
  Gamma0 <- Gamma0 / rowSums(Gamma0)

  ## --- initial-state distribution from marginal cluster frequencies ---
  delta0 <- as.numeric(table(factor(map, levels = 1:m)))
  delta0 <- delta0 / sum(delta0)

  list(lambda0 = lambda0, Gamma0 = Gamma0, delta0 = delta0, cluster = map)
}

## ------------------------------------------------------------
## .statdist: stationary distribution of a transition matrix
## (used for the histogram-overlay mixing weights pi1, pi2, ...)
## ------------------------------------------------------------
.statdist <- function(Gamma) {
  ev  <- eigen(t(Gamma))
  vec <- Re(ev$vectors[, which.min(abs(ev$values - 1))])
  distout <- vec / sum(vec)
}


## ------------------------------------------------------------
## .sim_pois_hmm: simulate a length-n series from a Poisson HMM
## (used only by .pois_hmm_boot below)
## ------------------------------------------------------------
.sim_pois_hmm <- function(n, lambda, Gamma, delta) {
  m <- length(lambda)
  state <- integer(n)
  state[1] <- sample(m, 1, prob = delta)
  for (t in 2:n) {
    state[t] <- sample(m, 1, prob = Gamma[state[t - 1], ])
  }
  rpois(n, lambda[state])
}


## ------------------------------------------------------------
## .pois_hmm_boot: parametric bootstrap SEs/CIs for lambda
##
## fit : output of fit_pois_hmm() (needs fit$lambda/Gamma/delta)
## y   : original series (only its length is used)
## m   : number of states
## B   : number of bootstrap replicates
## ... : passed through to fit_pois_hmm (n_perturb, maxiter, tol)
## ------------------------------------------------------------
.pois_hmm_boot <- function(fit, y, m = 2, B = 200, ...) {
  n <- length(y)
  lam_boot <- matrix(NA_real_, B, m)

  dots <- list(...)               # whatever n_perturb/maxiter/tol arrived with
  dots$m  <- NULL                 # guard against accidental collisions
  dots$se <- NULL

  b <- 1
  tries <- 0
  while (b <= B && tries < 5 * B) {
    tries <- tries + 1
    y_sim <- .sim_pois_hmm(n, fit$lambda, fit$Gamma, fit$delta)

    fit_b <- tryCatch(
      do.call(HmmPois, c(list(y = y_sim, m = m, se = "none"), dots)),
      error = function(e) { message("BOOT ERROR: ", conditionMessage(e)); NULL }
    )

    ## defensive: skip anything that didn't come back looking like a real fit
    if (is.null(fit_b) || is.null(fit_b$lambda) || length(fit_b$lambda) != m ||
        anyNA(fit_b$lambda)) next

    perm <- order(fit_b$lambda)
    lam_boot[b, ] <- fit_b$lambda[perm]
    b <- b + 1
  }

  if (b <= B) warning(sprintf("only %d/%d bootstrap fits converged", b - 1, B))
  lam_boot <- lam_boot[seq_len(max(b - 1, 0)), , drop = FALSE]

  if (nrow(lam_boot) < 2) {
    stop("fewer than 2 bootstrap fits converged -- check .pois_hmm_boot for errors, ",
         "or increase boot_n_perturb")
  }

  se_boot <- apply(lam_boot, 2, sd, na.rm = TRUE)
  ci      <- apply(lam_boot, 2, quantile, probs = c(0.025, 0.975), na.rm = TRUE)

  data.frame(
    state   = 1:m,
    lambda  = sort(fit$lambda),
    se_boot = se_boot,
    lower95 = ci[1, ],
    upper95 = ci[2, ],
    n_boot  = nrow(lam_boot)
  )
}